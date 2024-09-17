import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/how_did_you_pay.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/heroic_achivement.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:bai_system/representation/cashless_hero.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/statistic.dart';
import '../api/service/bai_be/statistic_service.dart';
import '../component/dialog.dart';
import '../core/const/frontend/message.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  static const String routeName = '/insight_screen';

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> with ApiResponseHandler {
  final StatisticApi _statisticApi = StatisticApi();
  final Logger _logger = Logger();

  bool _isLoading = true;
  HowDidYouParkAndSpend? _howDidYouParkAndSpend;
  List<PaymentMethodUsage> _paymentMethodUsageList = [
    PaymentMethodUsage(method: 'Wallet', count: 0),
    PaymentMethodUsage(method: 'Other/Cash', count: 0),
  ];
  String _currentHeroLevel = HeroicAchievement.starter;
  String _currentHeroImage = AssetHelper.cashlessStarter;

  @override
  void initState() {
    super.initState();
    _fetchStatisticData();
  }

  Future<void> _fetchStatisticData() async {
    setState(() => _isLoading = true);
    try {
      final parkResponse = await _statisticApi.getHowDidYouPark();
      final payResponse = await _statisticApi.getHowDidYouPay();

      if (!mounted) return;

      final isParkResValid = await handleApiResponse(
        context: context,
        response: parkResponse,
        showErrorDialog: _showErrorDialog,
      );

      if (!mounted) return;
      final isPayResValid = await handleApiResponse(
        context: context,
        response: payResponse,
        showErrorDialog: _showErrorDialog,
      );

      if (!isParkResValid || !isPayResValid) return;

      setState(() {
        _howDidYouParkAndSpend = parkResponse.data;
        _paymentMethodUsageList = payResponse.data ?? _paymentMethodUsageList;
      });
      _logger.i('HowDidYouPay response: ${payResponse.data}');
      _calculateHeroLevel();
    } catch (e, stackTrace) {
      _logger.e('Error in _fetchStatisticData: $e');
      _logger.e(stackTrace.toString());
      _showErrorDialog('An error occurred while fetching data.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _calculateHeroLevel() {
    int totalPaymentCount = _paymentMethodUsageList
        .map((usage) => usage.count)
        .reduce((value, element) => value + element);

    int walletUsageCount = _paymentMethodUsageList
        .firstWhere((usage) => usage.method == 'WALLET',
            orElse: () => PaymentMethodUsage(method: 'WALLET', count: 0))
        .count;

    double walletUsagePercentage =
        totalPaymentCount > 0 ? walletUsageCount / totalPaymentCount : 0;

    _logger.d('Total payment count: $totalPaymentCount');
    _logger.d('Wallet usage count: $walletUsageCount');
    _logger.d('Wallet usage percentage: $walletUsagePercentage');

    setState(() {
      if (walletUsageCount >= 21 && walletUsagePercentage >= 0.8) {
        _currentHeroLevel = HeroicAchievement.master;
        _currentHeroImage = AssetHelper.cashlessMaster;
      } else if (walletUsageCount >= 15 && walletUsagePercentage >= 0.7) {
        _currentHeroLevel = HeroicAchievement.champion;
        _currentHeroImage = AssetHelper.cashlessChampion;
      } else if (walletUsageCount >= 8 && walletUsagePercentage >= 0.6) {
        _currentHeroLevel = HeroicAchievement.adventurer;
        _currentHeroImage = AssetHelper.cashlessAdventurer;
      } else if (walletUsageCount >= 3 && walletUsagePercentage >= 0.5) {
        _currentHeroLevel = HeroicAchievement.explorer;
        _currentHeroImage = AssetHelper.cashlessExplorer;
      } else {
        _currentHeroLevel = HeroicAchievement.starter;
        _currentHeroImage = AssetHelper.cashlessStarter;
      }
    });

    _logger.d('Current hero level: $_currentHeroLevel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Insight',
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const LoadingCircle()
          : RefreshIndicator(
              onRefresh: _fetchStatisticData,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('How did you park this month?'),
                      _buildParkingStats(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      _buildSectionTitle('How did you pay this month?'),
                      _buildPaymentMethodChart(),
                      const SizedBox(height: 20),
                      _buildTipWidget(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      _tooltip(
                        'Your hero level is determined by the number of transactions you made with your wallet. '
                        'The more transactions you make, the higher your hero level will be.',
                        _buildSectionTitle('Heroic Achievements',
                            icon: Icons.info_outline),
                      ),
                      _buildCashlessHero(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 5),
            Icon(
              icon,
              color: Theme.of(context).colorScheme.outline,
              size: 15,
            ),
          ],
        ],
      ),
    );
  }

  Widget _tooltip(String message, Widget child) {
    return Tooltip(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        triggerMode: TooltipTriggerMode.tap,
        waitDuration: const Duration(milliseconds: 1000),
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
        textAlign: TextAlign.justify,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(5),
        ),
        exitDuration: const Duration(milliseconds: 5000),
        verticalOffset: 20,
        message: message,
        child: child);
  }

  Widget _buildParkingStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatContainer(
          'Total parking times',
          _howDidYouParkAndSpend?.totalTimePakedInThisMonth ?? 0,
        ),
        _buildStatContainer(
          'Total spending',
          _howDidYouParkAndSpend?.totalPaymentInThisMonth ?? 0,
          isMoney: true,
        ),
      ],
    );
  }

  Widget _buildStatContainer(String title, int number, {bool isMoney = false}) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.width * 0.2,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                isMoney ? UltilHelper.formatMoney(number) : '$number',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(width: 2),
              Text(
                isMoney ? 'VND' : 'times',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodChart() {
    return ShadowContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          HowDidYouPay(paymentMethodUsageList: _paymentMethodUsageList),
          if (_paymentMethodUsageList.every((usage) => usage.count == 0))
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.outline,
              ),
              child: Text(
                'Don\'t have any data to show yet',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_circle,
            color: Theme.of(context).colorScheme.outline,
            size: 20,
          ),
          Expanded(
            child: Text(
              'Paying by wallet will be faster and more convenient',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashlessHero() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(CashlessHero.routeName),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(
                _currentHeroImage,
                width: 65,
                height: 65,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Your hero level',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              _currentHeroLevel,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pay with ease, park with care, and go greener!',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
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
          ),
        );
      },
    );
  }
}
