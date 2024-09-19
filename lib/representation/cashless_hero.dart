import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../api/model/bai_model/statistic.dart';
import '../api/service/bai_be/statistic_service.dart';
import '../component/dialog.dart';
import '../component/internet_connection_wrapper.dart';
import '../core/const/frontend/heroic_achivement.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/asset_helper.dart';

class CashlessHero extends StatefulWidget {
  const CashlessHero({super.key});

  static const String routeName = '/cashless_hero';

  @override
  State<CashlessHero> createState() => _CashlessHeroState();
}

class _CashlessHeroState extends State<CashlessHero> with ApiResponseHandler {
  final _statisticApi = StatisticApi();
  final log = Logger();
  int _walletUsageCount = 0;
  int _cashUsageCount = 0;
  String _currentHeroLevel = 'Cashless Starter';
  int _transactionsToNextLevel = 0;
  String _currentHeroImage = AssetHelper.cashlessStarter;
  int _initialPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      final payResponse = await _statisticApi.getHowDidYouPay();
      log.d('Pay response: $payResponse');

      if (!mounted) return;
      final isPayResValid = await handleApiResponse(
        context: context,
        response: payResponse,
        showErrorDialog: _showErrorDialog,
      );

      if (!isPayResValid) return;

      if (payResponse.data != null) {
        int walletUsageCount = 0;
        int cashUsageCount = 0;

        for (PaymentMethodUsage payment in payResponse.data!) {
          if (payment.method == 'WALLET') {
            walletUsageCount = payment.count;
          } else {
            cashUsageCount = payment.count;
          }
        }

        setState(() {
          _walletUsageCount = walletUsageCount;
          _cashUsageCount = cashUsageCount;
        });
      }
      _calculateHeroLevel();
    } catch (e) {
      log.e(e);
    }
  }

  void _calculateHeroLevel() {
    int totalTransactions = _walletUsageCount + _cashUsageCount;
    double walletRatio =
        totalTransactions > 0 ? _walletUsageCount / totalTransactions : 0;

    setState(() {
      if (_walletUsageCount >= 21 && walletRatio >= 0.8) {
        _currentHeroLevel = HeroicAchievement.master;
        _transactionsToNextLevel = 0;
        _currentHeroImage = AssetHelper.cashlessMaster;
        _initialPage = 4;
      } else if (_walletUsageCount >= 15 && walletRatio >= 0.7) {
        _currentHeroLevel = HeroicAchievement.champion;
        _transactionsToNextLevel = 21 - _walletUsageCount;
        _currentHeroImage = AssetHelper.cashlessChampion;
        _initialPage = 3;
      } else if (_walletUsageCount >= 8 && walletRatio >= 0.6) {
        _currentHeroLevel = HeroicAchievement.adventurer;
        _transactionsToNextLevel = 15 - _walletUsageCount;
        _currentHeroImage = AssetHelper.cashlessAdventurer;
        _initialPage = 2;
      } else if (_walletUsageCount >= 3 && walletRatio >= 0.5) {
        _currentHeroLevel = HeroicAchievement.explorer;
        _transactionsToNextLevel = 8 - _walletUsageCount;
        _currentHeroImage = AssetHelper.cashlessExplorer;
        _initialPage = 1;
      } else {
        _currentHeroLevel = HeroicAchievement.starter;
        _transactionsToNextLevel = 3 - _walletUsageCount;
        _currentHeroImage = AssetHelper.cashlessStarter;
        _initialPage = 0;
      }

      isLoading = false;
      log.d('Hero level: $_currentHeroLevel');
    });
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          automaticallyImplyLeading: true,
          title: 'Heroic Achievements',
        ),
        body: isLoading
            ? const LoadingCircle()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCashlessHero(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDayProgressBar(),
                          const SizedBox(height: 20),
                          _buildHeroCard(),
                          const SizedBox(height: 20),
                          _whatIsThis(),
                          const SizedBox(height: 10),
                          _heroLevels(),
                          const SizedBox(height: 10),
                          _tipsToAdvance(),
                          const SizedBox(height: 10),
                          _rewards(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDayProgressBar() {
    int daysLeft = _ProgressHelper()._daysLeftInMonth();
    int daysPassed = _ProgressHelper()._daysPassedInMonth();
    int totalDays = _ProgressHelper()._daysInMonth(DateTime.now());
    double progress = _ProgressHelper()._getProgress();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day $daysPassed/$totalDays',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$daysLeft days left',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Top up your wallet and skip the cash for a smoother parking experience—help protect the planet!',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCashlessHero() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20,
        bottom: 10,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      color: Theme.of(context).colorScheme.onBackground,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 2,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  _currentHeroImage,
                  width: 65,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text(
                _currentHeroLevel,
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
              const SizedBox(height: 10),
              const Divider(),
              (_currentHeroLevel == HeroicAchievement.master)
                  ? Text(
                      'You are truly a Cashless Master! Keep it up!',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 10),
                    )
                  : Text(
                      'You need $_transactionsToNextLevel more transactions to reach the next level.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 10),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Be a Cashless Hero',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 5),
        _heroCardSlider(),
      ],
    );
  }

  Widget _heroCard(
      {required String heroLevel,
      required String heroBadge,
      required String description}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      color: Theme.of(context).colorScheme.onBackground,
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: Column(
        children: [
          // Hero Badge (image)
          Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              heroBadge,
              width: 60,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Hero Level
          Text(
            heroLevel,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
          ),
          const Divider(),
          const SizedBox(height: 5),
          // Hero Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _heroCardSlider() {
    final List<Map<String, String>> heroLevels = [
      {
        'level': 'Cashless Starter',
        'badge': AssetHelper.cashlessStarter,
        'description': 'Default for all users when they start.'
      },
      {
        'level': 'Cashless Explorer',
        'badge': AssetHelper.cashlessExplorer,
        'description': 'A beginner on the journey of digital payments.'
      },
      {
        'level': 'Cashless Adventurer',
        'badge': AssetHelper.cashlessAdventurer,
        'description': 'Regularly uses the e-wallet for convenience.'
      },
      {
        'level': 'Cashless Champion',
        'badge': AssetHelper.cashlessChampion,
        'description': 'Prioritizes digital payments, rarely uses cash.'
      },
      {
        'level': 'Cashless Master',
        'badge': AssetHelper.cashlessMaster,
        'description': 'A master of cashless payments, almost fully cashless.'
      },
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: heroLevels.length,
          itemBuilder: (context, index, realIndex) {
            final hero = heroLevels[index];
            return _heroCard(
              heroLevel: hero['level']!,
              heroBadge: hero['badge']!,
              description: hero['description']!,
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: false,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            initialPage: _initialPage,
            onPageChanged: (index, reason) {
              setState(() {
                _initialPage = index;
              });
            },
          ),
        ),
        SmoothPageIndicator(
          controller: PageController(initialPage: _initialPage),
          count: heroLevels.length,
          effect: WormEffect(
            dotWidth: 5,
            dotHeight: 5,
            spacing: 5,
            dotColor: Theme.of(context).colorScheme.onSurface,
            activeDotColor: Theme.of(context).colorScheme.onTertiary,
            type: WormType.thinUnderground,
          ),
        ),
      ],
    );
  }

  //What is this?
  Widget _whatIsThis() {
    return _expansionTile('What is this?', [
      'The Cashless Hero program is a fun way to encourage you to use e-wallets for your parking transactions. The more you use e-wallets, the higher your hero level and the smoother your parking experience!',
    ]);
  }

  //How to level up?
  Widget _heroLevels() {
    return _expansionTile('How to Level Up?', [
      'We monitor your monthly e-wallet transactions and cashless payment ratio to determine your hero level.\n',
      'Hero Levels:',
      '\u2022 Starter: Default level for all new users.',
      '\u2022 Explorer: 3-7 e-wallet transactions, 50% cashless.',
      '\u2022 Adventurer: 8-14 e-wallet transactions, 60% cashless.',
      '\u2022 Champion: 15-20 e-wallet transactions, 70% cashless.',
      '\u2022 Master: 21+ e-wallet transactions, 80% cashless.',
    ]);
  }

  Widget _tipsToAdvance() {
    return _expansionTile('Tips to Advance', [
      '\u2022 Top up your e-wallet and use it for all your parking transactions.',
      '\u2022 Minimize cash transactions to increase your cashless ratio.',
      '\u2022 Keep track of your transactions and aim to level up each month.',
    ]);
  }

  //Rewards
  Widget _rewards() {
    return _expansionTile('Rewards', [
      'Earn badges and recognition as you move up the hero levels. Keep aiming higher and enjoy a smoother parking experience!',
    ]);
  }

  Widget _expansionTile(String title, List<String> content) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        tilePadding: EdgeInsets.zero,
        iconColor: Theme.of(context).colorScheme.onTertiary,
        visualDensity: VisualDensity.compact,
        dense: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((text) => _text(text)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
      textAlign: TextAlign.left,
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
}

class _ProgressHelper {
  int _daysInMonth(DateTime date) {
    int month = date.month;
    int year = date.year;

    if (month == 2) {
      return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 29 : 28;
    }

    List<int> month30 = [4, 6, 9, 11];
    return month30.contains(month) ? 30 : 31;
  }

  int _daysPassedInMonth() {
    DateTime now = DateTime.now();
    return now.day;
  }

  int _daysLeftInMonth() {
    int totalDays = _daysInMonth(DateTime.now());
    return totalDays - _daysPassedInMonth();
  }

  double _getProgress() {
    int totalDays = _daysInMonth(DateTime.now());
    int passedDays = _daysPassedInMonth();
    return passedDays / totalDays;
  }
}
