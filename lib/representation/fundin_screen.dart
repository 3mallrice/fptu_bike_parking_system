import 'package:bai_system/api/model/bai_model/wallet_model.dart';
import 'package:bai_system/api/service/bai_be/package_service.dart';
import 'package:bai_system/api/service/bai_be/wallet_service.dart';
import 'package:bai_system/component/empty_box.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_button.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/payment.dart';
import 'package:bai_system/representation/wallet.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/bai_model/coin_package_model.dart';
import '../component/app_bar_component.dart';
import '../component/dialog.dart';
import '../component/internet_connection_wrapper.dart';
import '../component/shadow_container.dart';
import '../component/snackbar.dart';
import '../core/helper/asset_helper.dart';
import 'login.dart';

class FundinScreen extends StatefulWidget {
  const FundinScreen({super.key});

  static String routeName = '/fundin_screen';

  @override
  State<FundinScreen> createState() => _FundinScreenState();
}

class _FundinScreenState extends State<FundinScreen> with ApiResponseHandler {
  final CallPackageApi _packageApi = CallPackageApi();
  final CallWalletApi _walletApi = CallWalletApi();
  final Logger _logger = Logger();

  int _balance = 0;
  int _extraBalance = 0;
  bool _hideBalance = false;
  bool _isLoading = true;
  List<CoinPackage> _packages = [];

  late String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
  int _currentPage = 1;
  bool _hasNextPage = true;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.75 &&
        !_scrollController.position.outOfRange &&
        !_isLoadingMore &&
        _hasNextPage) {
      _loadNextPage();
    }
  }

  Future<void> _initializeData() async {
    Set<String> errorMessages = {};

    await Future.wait([
      _loadHideBalance(),
      getBalance(errors: errorMessages, isAlone: false),
      getExtraBalance(errors: errorMessages, isAlone: false),
      _loadPackages(errors: errorMessages, isAlone: false),
    ]);

    if (errorMessages.isNotEmpty) {
      String errorMessage;

      if (errorMessages.length > 1) {
        errorMessage = errorMessages.map((e) => '\u2022 $e').join('\n');
      } else {
        errorMessage = errorMessages.first;
      }

      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadHideBalance() async {
    bool? hideBalance = await LocalStorageHelper.getValue(
        LocalStorageKey.isHiddenBalance, currentEmail);
    _logger.i('Hide balance: $hideBalance');
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  void _toggleHideBalance() {
    setState(() {
      _hideBalance = !_hideBalance;
      LocalStorageHelper.setValue(
          LocalStorageKey.isHiddenBalance, _hideBalance, currentEmail);
      _logger.i('Toggle hide balance: $_hideBalance');
    });
  }

  Future<void> getBalance({Set<String>? errors, bool isAlone = false}) async {
    try {
      final APIResponse<int> result = await _walletApi.getMainWalletBalance();

      final error = await _catchError(result);
      if (error != null) {
        errors?.add(error);
        if (isAlone) {
          _showErrorDialog(error);
        }
        return;
      }

      if (mounted) {
        setState(() {
          _balance = result.data ?? 0;
        });
      }
    } catch (e) {
      _logger.e('Error during get main wallet balance: $e');
      errors?.add(ErrorMessage.somethingWentWrong);
      if (isAlone) {
        _showErrorDialog(ErrorMessage.somethingWentWrong);
      }
    }
  }

  Future<void> getExtraBalance(
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      APIResponse<ExtraBalanceModel> extraBalanceModel =
          await _walletApi.getExtraWalletBalance();

      final error = await _catchError(extraBalanceModel);
      if (error != null) {
        errors?.add(error);
        if (isAlone) {
          _showErrorDialog(error);
        }
        return;
      }

      if (mounted && extraBalanceModel.data != null) {
        setState(() {
          _extraBalance = extraBalanceModel.data!.balance;
        });
      }
    } catch (e) {
      _logger.e('Error during get extra balance: $e');
      errors?.add(ErrorMessage.somethingWentWrong);
      if (isAlone) {
        _showErrorDialog(ErrorMessage.somethingWentWrong);
      }
    }
  }

  Future<void> _loadPackages(
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      final packages = await _packageApi.getPackages(_currentPage);

      final error = await _catchError(packages);
      if (error != null) {
        errors?.add(error);
        if (isAlone) {
          _showErrorDialog(error);
        }
        return;
      }

      if (mounted) {
        setState(() {
          if (_currentPage == 1) {
            _packages = packages.data ?? [];
          } else {
            _packages.addAll(packages.data ?? []);
          }
          _hasNextPage = packages.data!.length <= (packages.totalRecord ?? 0);
        });
      }
    } catch (e) {
      _logger.e('Error during load packages: $e');
      errors?.add(ErrorMessage.somethingWentWrong);
      if (isAlone) {
        _showErrorDialog(ErrorMessage.somethingWentWrong);
      }
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    _currentPage++;
    await _loadPackages();
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _showPackageDetail(CoinPackage package) {
    showBarModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInCirc,
      barrierColor: Theme.of(context).colorScheme.outline.withOpacity(0.35),
      expand: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      closeProgressThreshold: 0.3,
      enableDrag: true,
      elevation: 4,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (context) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildBottomSheet(package),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(CoinPackage package) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Package Detail',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20),
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          _buildPackageDetailRow('Package Name:', package.packageName),
          _buildPackageDetailRow(
              'Price:', '${UltilHelper.formatMoney(package.price)}đ'),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Divider(
              color:
                  Theme.of(context).colorScheme.onSecondary.withOpacity(0.12),
              thickness: 1,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPackageDescription(package),
                ],
              ),
            ),
          ),
          _buildBottomSheetFooter(package),
        ],
      ),
    );
  }

  Widget _buildPackageDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 19,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDescription(CoinPackage package) => Text(
        packageDetail(package),
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget _buildBottomSheetFooter(CoinPackage package) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                'By tapping BUY NOW you agree to deposit bai coins into your wallet.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                PaymentScreen.routeName,
                arguments: package,
              );
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              child: ShadowButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                height: MediaQuery.of(context).size.height * 0.07,
                buttonTitle:
                    '${UltilHelper.formatMoney(package.price)} VND - BUY NOW',
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: MyAppBar(
          automaticallyImplyLeading: true,
          title: 'Fund in',
          action: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(WalletScreen.routeName),
                icon: Icon(
                  Icons.wallet,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                iconSize: 21,
              ),
            )
          ],
        ),
        body: _isLoading
            ? const LoadingCircle(isHeight: false)
            : Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildBody(),
              ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletInfo(),
              const SizedBox(height: 35),
              _buildProviderSection(),
              const SizedBox(height: 35),
              _buildPackagesSection(),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletInfo() {
    return GestureDetector(
      onTap: _toggleHideBalance,
      child: ShadowContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('TO', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(width: 30),
                Text('BAi Wallet',
                    style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
            const SizedBox(height: 5),
            Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                thickness: 1),
            const SizedBox(height: 5),
            _buildBalanceRow('Current balance:', _balance),
            _buildBalanceRow('Extra balance:', _extraBalance),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          _hideBalance ? '******' : 'bic ${UltilHelper.formatMoney(amount)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildProviderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text('PROVIDER', style: Theme.of(context).textTheme.bodyLarge),
        ),
        ShadowContainer(
          child: Image(
            image: const AssetImage(AssetHelper.baiLogo),
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            'AMOUNT(1K = 1.000)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (_packages.isEmpty)
          EmptyBox(
            message: EmptyBoxMessage.emptyList(label: ListName.package),
          )
        else
          _buildCoinPackageGridView(_packages),
      ],
    );
  }

  Widget _buildCoinPackageGridView(List<CoinPackage> packages) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 11,
      ),
      itemCount: packages.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildPackageItem(packages[index]);
      },
    );
  }

  Widget _buildPackageItem(CoinPackage package) {
    return GestureDetector(
      onTap: () => _showPackageDetail(package),
      child: ShadowContainer(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${UltilHelper.formatMoney(int.parse(package.amount) + (package.extraCoin ?? 0))} ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                        TextSpan(
                          text: 'bic',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (package.extraEXP != null)
                    Text(
                      '${package.extraEXP} days',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSecondary),
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${package.price ~/ 1000}K\nVND',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.background,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
