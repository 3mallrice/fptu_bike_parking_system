import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/representation/receipt.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/bai_model/wallet_model.dart';
import '../api/service/bai_be/wallet_service.dart';
import '../component/app_bar_component.dart';
import '../component/date_picker.dart';
import '../component/dialog.dart';
import '../component/empty_box.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frontend/message.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/local_storage_helper.dart';
import 'fundin_screen.dart';
import 'navigation_bar.dart';

class WalletScreen extends StatefulWidget {
  final int? walletType;
  const WalletScreen({
    super.key,
    this.walletType,
  });

  static const String routeName = '/wallet';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin, ApiResponseHandler {
  late int walletType;
  late TabController _tabController;
  bool _hideBalance = false;
  var log = Logger();
  final CallWalletApi callWalletApi = CallWalletApi();
  late int mainBalance = 0;
  late int extraBalance = 0;
  DateTime? expiredDate;
  List<WalletModel> mainTransactions = [];
  List<WalletModel> extraTransactions = [];
  bool mainTransactionsLoading = false;
  bool extraTransactionsLoading = false;
  String? mainErrorMessage;
  String? extraErrorMessage;

  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();

  int totalMainTransactions = 0;
  int totalExtraTransactions = 0;

  int mainPageIndex = 1;
  int extraPageIndex = 1;
  late int _pageSize = 10;

  final RefreshController _mainRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _extraRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    walletType = widget.walletType ?? 0;
    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: walletType,
        animationDuration: const Duration(milliseconds: 300));
    _hideBalance = GetLocalHelper.getHideBalance();
    _pageSize = GetLocalHelper.getPageSize();
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mainRefreshController.dispose();
    _extraRefreshController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      getMainBalance(),
      getExtraBalance(),
      getMainTransactions(),
      getExtraTransactions(),
    ]);
  }

  void _toggleHideBalance() {
    setState(() {
      _hideBalance = !_hideBalance;
    });
  }

  void _catchError(APIResponse response) async {
    if (!mounted) return;

    final bool isResponseValid = await handleApiResponse(
      context: context,
      response: response,
      showErrorDialog: _showErrorDialog,
    );

    if (!isResponseValid) return;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  Future<void> getMainBalance() async {
    try {
      final APIResponse<int> result =
          await callWalletApi.getMainWalletBalance();
      _catchError(result);
      if (!mounted) return;
      setState(() {
        mainBalance = result.data ?? 0;
      });
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
  }

  Future<void> getExtraBalance() async {
    try {
      APIResponse<ExtraBalanceModel> extraBalanceModel =
          await callWalletApi.getExtraWalletBalance();
      _catchError(extraBalanceModel);
      if (!mounted) return;
      if (extraBalanceModel.data != null) {
        setState(() {
          extraBalance = extraBalanceModel.data!.balance;
          expiredDate = extraBalanceModel.data!.expiredDate;
        });
      }
    } catch (e) {
      log.e('Error during get extra balance: $e');
    }
  }

  Future<void> getMainTransactions({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      setState(() {
        mainTransactionsLoading = true;
        mainErrorMessage = null;
      });
    }
    try {
      final APIResponse<List<WalletModel>> result = await callWalletApi
          .getMainWalletTransactions(mainPageIndex, _pageSize, from, to);
      _catchError(result);
      if (!mounted) return;
      setState(() {
        if (isLoadMore) {
          mainTransactions.addAll(result.data ?? []);
        } else {
          mainTransactions = result.data ?? [];
        }
        totalMainTransactions = result.totalRecord ?? 0;
        mainTransactionsLoading = false;
      });
    } catch (e) {
      log.e('Error during get main wallet transactions: $e');
      setState(() {
        mainTransactionsLoading = false;
        mainErrorMessage = 'Error loading data: $e';
      });
    }
  }

  Future<void> getExtraTransactions({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      setState(() {
        extraTransactionsLoading = true;
        extraErrorMessage = null;
      });
    }
    try {
      final APIResponse<List<WalletModel>> result = await callWalletApi
          .getExtraWalletTransactions(extraPageIndex, _pageSize, from, to);
      _catchError(result);
      if (!mounted) return;
      setState(() {
        if (isLoadMore) {
          extraTransactions.addAll(result.data ?? []);
        } else {
          extraTransactions = result.data ?? [];
        }
        totalExtraTransactions = result.totalRecord ?? 0;
        extraTransactionsLoading = false;
      });
    } catch (e) {
      log.e('Error during get extra wallet transactions: $e');
      setState(() {
        extraTransactionsLoading = false;
        extraErrorMessage = 'Error loading data: $e';
      });
    }
  }

  void _onMainRefresh() async {
    mainPageIndex = 1;
    await getMainBalance();
    await getMainTransactions();
    _mainRefreshController.refreshCompleted();
  }

  void _onMainLoading() async {
    mainPageIndex++;
    await getMainTransactions(isLoadMore: true);
    _mainRefreshController.loadComplete();
  }

  void _onExtraRefresh() async {
    extraPageIndex = 1;
    await getExtraBalance();
    await getExtraTransactions();
    _extraRefreshController.refreshCompleted();
  }

  void _onExtraLoading() async {
    extraPageIndex++;
    await getExtraTransactions(isLoadMore: true);
    _extraRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        routeName: MyNavigationBar.routeName,
        appBarText: 'My Wallet',
        action: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(FundinScreen.routeName),
              icon: Icon(
                Icons.input_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              iconSize: 21,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
            tabAlignment: TabAlignment.fill,
            automaticIndicatorColorAdjustment: true,
            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
            splashBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            tabs: const [
              Tab(text: 'Main Wallet'),
              Tab(text: 'Extra Wallet'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWalletContent(isMain: true),
                _buildWalletContent(isMain: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletContent({required bool isMain}) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const ClassicHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle &&
              (isMain ? mainPageIndex : extraPageIndex) * _pageSize <
                  (isMain ? totalMainTransactions : totalExtraTransactions)) {
            body = const Text('pull up load');
          } else if (mode == LoadStatus.loading) {
            body = const LoadingCircle(
              size: 50,
            );
          } else if (mode == LoadStatus.failed) {
            body = const Text('Load Failed!Click retry!');
          } else if (mode == LoadStatus.canLoading) {
            body = const Text('release to load more');
          } else {
            body = const Text('No more Data');
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: isMain ? _mainRefreshController : _extraRefreshController,
      onRefresh: isMain ? _onMainRefresh : _onExtraRefresh,
      onLoading: isMain ? _onMainLoading : _onExtraLoading,
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: ShadowContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: GestureDetector(
                    onTap: _toggleHideBalance,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isMain ? 'Current balance' : 'Extra coin',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hideBalance
                              ? '******'
                              : '${UltilHelper.formatMoney(isMain ? mainBalance : extraBalance)} bic',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (!isMain && expiredDate != null)
                          Text(
                            '${UltilHelper.formatMoney(extraBalance)} bic will expire on ${UltilHelper.formatDate(expiredDate!)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 10,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GestureDetector(
                  onTap: showFilterDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HISTORIES',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          children: [
                            Text(
                              'FILTER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.filter_alt_outlined,
                              color: Theme.of(context).colorScheme.onSecondary,
                              size: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              mainTransactionsLoading || extraTransactionsLoading
                  ? const LoadingCircle()
                  : (mainErrorMessage != null || extraErrorMessage != null)
                      ? Center(
                          child: Text(
                            mainErrorMessage ?? extraErrorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : isMain
                          ? _buildTransactionList(mainTransactions)
                          : _buildTransactionList(extraTransactions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<WalletModel> transactions) {
    return transactions.isEmpty
        ? EmptyBox(
            message: EmptyBoxMessage.emptyList(label: ListName.transaction))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Color itemBackgroundColor = index % 2 == 0
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary;
              return GestureDetector(
                onTap: () => showReceiptDialog(transactions[index]),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: itemBackgroundColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transactions[index].type == 'IN'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        child: Icon(
                          transactions[index].type == 'IN'
                              ? Icons.attach_money_rounded
                              : Icons.local_parking_rounded,
                        ),
                      ),
                      title: Text(
                        transactions[index].type == 'IN'
                            ? 'Deposit'
                            : 'Parking Fee',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactions[index].description ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            UltilHelper.formatDate(transactions[index].date),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          )
                        ],
                      ),
                      trailing: Text(
                        (transactions[index].type == 'IN' ? '+' : '-') +
                            UltilHelper.formatMoney(transactions[index].amount),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: 'Filter by period',
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: DatePicker(
              fromDate: from,
              toDate: to,
              onDateSelected: (startDate, endDate) {
                setState(() {
                  from = startDate;
                  to = endDate;
                });
              },
            ),
          ),
          onClick: () {
            Navigator.of(context).pop();
            _tabController.index == 0 ? _onMainRefresh() : _onExtraRefresh();
          },
        );
      },
    );
  }

  void showReceiptDialog(WalletModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: 'Receipt',
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ReceiptScreen(transaction: transaction),
            ),
          ),
          onClick: () => Navigator.of(context).pop(),
          contentPadding: const EdgeInsets.all(20),
        );
      },
    );
  }
}
