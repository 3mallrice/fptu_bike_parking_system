import 'package:bai_system/component/how_did_you_pay.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
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

      if (parkResponse.isTokenValid && payResponse.isTokenValid) {
        setState(() {
          _howDidYouParkAndSpend = parkResponse.data;
          _paymentMethodUsageList = payResponse.data ?? _paymentMethodUsageList;
        });
        _logger.i('HowDidYouPay response: ${payResponse.data}');
      } else {
        _logger.e('Token is invalid');
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
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
                borderRadius: BorderRadius.circular(10),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(10),
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
              AssetHelper.cashlessExplorer,
              width: 65,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            'Be a Cashless Hero',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(
            'Pay with ease, park with care, and go greener!',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
        ],
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
