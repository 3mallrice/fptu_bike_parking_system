import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/snackbar.dart';
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
import '../component/internet_connection_wrapper.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frontend/message.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/local_storage_helper.dart';
import 'fundin_screen.dart';
import 'login.dart';
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
  late final String _currentEmail =
      LocalStorageHelper.getCurrentUserEmail() ?? '';
  late int mainBalance = 0;
  late int extraBalance = 0;
  DateTime? expiredDate;
  List<WalletModel> mainTransactions = [];
  List<WalletModel> extraTransactions = [];
  bool mainTransactionsLoading = false;
  bool extraTransactionsLoading = false;
  String? mainErrorMessage;
  String? extraErrorMessage;

  DateTime? from;
  DateTime? to;
  DateTime? extraFrom;
  DateTime? extraTo;

  bool isMainFiltered = false;
  bool isExtraFiltered = false;

  int totalMainTransactions = 0;
  int totalExtraTransactions = 0;

  int mainPageIndex = 1;
  int extraPageIndex = 1;
  late int _pageSize = 10;
  String _errorMessage = '';

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
    _hideBalance = GetLocalHelper.getHideBalance(_currentEmail);
    _pageSize = GetLocalHelper.getPageSize(_currentEmail);
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
    Set<String> errorMessages = {};

    await Future.wait([
      getMainBalance(errors: errorMessages, isAlone: false),
      getExtraBalance(errors: errorMessages, isAlone: false),
      getMainTransactions(errors: errorMessages, isAlone: false),
      getExtraTransactions(errors: errorMessages, isAlone: false),
    ]);

    if (errorMessages.isNotEmpty) {
      setState(() {
        mainTransactionsLoading = false;
        extraTransactionsLoading = false;
      });
      String errorMessage;

      if (errorMessages.length > 1) {
        errorMessage = errorMessages.map((e) => '\u2022 $e').join('\n');
      } else {
        errorMessage = errorMessages.first;
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _toggleHideBalance() {
    setState(() {
      _hideBalance = !_hideBalance;
    });
  }

  Future<String?> _catchError(APIResponse response) async {
    final String? errorMessage = await handleApiResponse(
      context: context,
      response: response,
    );

    if (errorMessage == ApiResponseHandler.invalidToken) {
      _goToPage(routeName: LoginScreen.routeName);
      _showSnackBar(
        message: ErrorMessage.tokenInvalid,
        isSuccessful: false,
      );
    }

    return errorMessage;
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
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }

  Future<void> getMainBalance(
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      final APIResponse<int> result =
          await callWalletApi.getMainWalletBalance();
      final error = await _catchError(result);

      if (error != null) {
        if (isAlone) {
          _showErrorDialog(error);
        }
        errors?.add(error);
      }

      if (mounted) {
        setState(() {
          mainBalance = result.data ?? 0;
        });
      }
    } catch (e) {
      log.e('Error during get main balance: $e');
      if (isAlone) {
        _showErrorDialog(
            'Load Main Balance: ${ErrorMessage.somethingWentWrong}');
      }
      errors?.add('Load Main Balance: ${ErrorMessage.somethingWentWrong}');
    }
  }

  Future<void> getExtraBalance(
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      APIResponse<ExtraBalanceModel> extraBalanceModel =
          await callWalletApi.getExtraWalletBalance();
      final error = await _catchError(extraBalanceModel);

      if (error != null) {
        if (isAlone) {
          _showErrorDialog(error);
        }
        errors?.add(error);
      }

      if (mounted && extraBalanceModel.data != null) {
        setState(() {
          extraBalance = extraBalanceModel.data!.balance;
          expiredDate = extraBalanceModel.data!.expiredDate;
        });
      }
    } catch (e) {
      log.e('Error during get extra balance: $e');
      if (isAlone) {
        _showErrorDialog(
            'Load Extra Balance: ${ErrorMessage.somethingWentWrong}');
      }
      errors?.add('Load Extra Balance: ${ErrorMessage.somethingWentWrong}');
    }
  }

  Future<void> getMainTransactions(
      {Set<String>? errors,
      bool isLoadMore = false,
      bool isAlone = false}) async {
    if (!isLoadMore) {
      setState(() {
        mainTransactionsLoading = true;
        mainErrorMessage = null;
      });
    }

    try {
      final APIResponse<List<WalletModel>> result = await callWalletApi
          .getMainWalletTransactions(mainPageIndex, _pageSize, from, to);
      final error = await _catchError(result);

      if (error != null) {
        if (isAlone) {
          _showErrorDialog(error);
        }
        errors?.add(error);
        if (!isAlone) return;
      }

      if (mounted) {
        setState(() {
          if (isLoadMore) {
            mainTransactions.addAll(result.data ?? []);
          } else {
            mainTransactions = result.data ?? [];
          }
          totalMainTransactions = result.totalRecord ?? 0;
          mainTransactionsLoading = false;
        });
      }
    } catch (e) {
      log.e('Error during get main wallet transactions: $e');
      if (isAlone) {
        _showErrorDialog(
            'Load Main Transactions: ${ErrorMessage.somethingWentWrong}');
      }
      errors?.add('Load Main Transactions: ${ErrorMessage.somethingWentWrong}');
      setState(() {
        mainTransactionsLoading = false;
        mainErrorMessage = 'Error loading data: $e';
      });
      if (!isAlone) return;
    }
  }

  Future<void> getExtraTransactions(
      {Set<String>? errors,
      bool isLoadMore = false,
      bool isAlone = false}) async {
    if (!isLoadMore) {
      setState(() {
        extraTransactionsLoading = true;
        extraErrorMessage = null;
      });
    }

    try {
      final APIResponse<List<WalletModel>> result =
          await callWalletApi.getExtraWalletTransactions(
              extraPageIndex, _pageSize, extraFrom, extraTo);
      final error = await _catchError(result);

      if (error != null) {
        if (isAlone) {
          _showErrorDialog(error);
        }
        errors?.add(error);
        if (!isAlone) return;
      }

      if (mounted) {
        setState(() {
          if (isLoadMore) {
            extraTransactions.addAll(result.data ?? []);
          } else {
            extraTransactions = result.data ?? [];
          }
          totalExtraTransactions = result.totalRecord ?? 0;
          extraTransactionsLoading = false;
        });
      }
    } catch (e) {
      log.e('Error during get extra wallet transactions: $e');
      if (isAlone) {
        _showErrorDialog(
            'Load Extra Transactions: ${ErrorMessage.somethingWentWrong}');
      }
      errors
          ?.add('Load Extra Transactions: ${ErrorMessage.somethingWentWrong}');
      setState(() {
        extraTransactionsLoading = false;
        extraErrorMessage = 'Error loading data: $e';
      });
      if (!isAlone) return;
    }
  }

  void _onMainRefresh() async {
    Set<String> errorMessages = {};

    mainPageIndex = 1;
    await getMainBalance(errors: errorMessages, isAlone: false);
    await getMainTransactions(errors: errorMessages, isAlone: false);
    _mainRefreshController.refreshCompleted();

    if (errorMessages.isNotEmpty) {
      String errorMessage;

      if (errorMessages.length > 1) {
        errorMessage = errorMessages.map((e) => '\u2022 $e').join('\n');
      } else {
        errorMessage = errorMessages.first;
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _onMainLoading() async {
    mainPageIndex++;
    await getMainTransactions(isLoadMore: true, isAlone: true);
    _mainRefreshController.loadComplete();
  }

  void _onExtraRefresh() async {
    Set<String> errorMessages = {};

    extraPageIndex = 1;
    await getExtraBalance();
    await getExtraTransactions();
    _extraRefreshController.refreshCompleted();

    if (errorMessages.isNotEmpty) {
      String errorMessage;

      if (errorMessages.length > 1) {
        errorMessage = errorMessages.map((e) => '\u2022 $e').join('\n');
      } else {
        errorMessage = errorMessages.first;
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _onExtraLoading() async {
    extraPageIndex++;
    await getExtraTransactions(isLoadMore: true, isAlone: true);
    _extraRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: MyAppBar(
          automaticallyImplyLeading: true,
          routeName: MyNavigationBar.routeName,
          title: 'My Wallet',
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
      ),
    );
  }

  Widget _buildWalletContent({required bool isMain}) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(
        refreshingText: 'Refreshing...',
        idleText: 'Pull down to refresh',
        releaseText: 'Release to refresh',
        completeText: 'Refreshed',
        failedText: 'Failed to refresh',
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
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
          } else if (mode == LoadStatus.canLoading &&
              (isMain ? mainPageIndex : extraPageIndex) * _pageSize <
                  (isMain ? totalMainTransactions : totalExtraTransactions)) {
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
                        if (!isMain)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Expire on ${UltilHelper.formatDate(expiredDate, showTime: false)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 10,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
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
                  onTap: () => showFilterDialog(isMain: isMain),
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
                        _buildFilterIndicator(isMain: isMain),
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
                          color: Theme.of(context).colorScheme.surface,
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

  void showFilterDialog({required bool isMain}) {
    DateTime? tempFrom = isMain ? from : extraFrom;
    DateTime? tempTo = isMain ? to : extraTo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ConfirmDialog(
              title: 'Filter by period',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DatePicker(
                    fromDate: tempFrom ??
                        DateTime.now().subtract(const Duration(days: 7)),
                    toDate: tempTo ?? DateTime.now(),
                    onDateSelected: (startDate, endDate) {
                      setState(() {
                        // Ensure _errorMessage is updated within StatefulBuilder's setState
                        if (startDate.isAfter(endDate)) {
                          _errorMessage = 'From date cannot be after to date!';
                        } else {
                          _errorMessage = '';
                          tempFrom = startDate;
                          tempTo = endDate;
                        }
                      });
                    },
                  ),
                  Visibility(
                    visible: _errorMessage.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              onConfirm: () {
                if (_errorMessage.isEmpty) {
                  setState(() {
                    if (isMain) {
                      from = tempFrom;
                      to = tempTo;
                      isMainFiltered = true;
                    } else {
                      extraFrom = tempFrom;
                      extraTo = tempTo;
                      isExtraFiltered = true;
                    }
                  });
                  Navigator.of(context).pop();
                  isMain ? _onMainRefresh() : _onExtraRefresh();
                }
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  void clearFilter({required bool isMain}) {
    setState(() {
      if (isMain) {
        from = null;
        to = null;
        isMainFiltered = false;
      } else {
        extraFrom = null;
        extraTo = null;
        isExtraFiltered = false;
      }
    });
    isMain ? _onMainRefresh() : _onExtraRefresh();
  }

  Widget _buildFilterIndicator({required bool isMain}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'FILTER',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 5),
        Icon(
          Icons.filter_alt_outlined,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 15,
        ),
        if (isMain ? isMainFiltered : isExtraFiltered)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: GestureDetector(
              onTap: () => clearFilter(isMain: isMain),
              child: Text(
                'Clear',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
      ],
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

  void _goToPage({String? routeName}) {
    routeName != null
        ? Navigator.of(context).pushNamed(routeName)
        : Navigator.of(context).pop();
  }

  void _showSnackBar({required String message, required bool isSuccessful}) {
    Color background = Theme.of(context).colorScheme.surface;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: isSuccessful
              ? Icon(
                  Icons.check_circle_rounded,
                  color: background,
                )
              : Icon(
                  Icons.cancel_rounded,
                  color: background,
                ),
          message: message,
          backgroundColor: isSuccessful
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.error,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
