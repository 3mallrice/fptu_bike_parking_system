import 'dart:async';

import 'package:bai_system/api/model/bai_model/wallet_model.dart';
import 'package:bai_system/api/service/bai_be/wallet_service.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/representation/insight.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:bai_system/representation/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/weather/weather.dart';
import '../api/service/weather/open_weather_api.dart';
import '../component/dialog.dart';
import '../component/shadow_container.dart';
import '../component/snackbar.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/local_storage_helper.dart';
import 'fundin_screen.dart';
import 'login.dart';

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  static String routeName = '/home_screen';

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> with ApiResponseHandler {
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
  bool _hideBalance = false;
  bool isAllowLocation = false;
  bool isReloading = false;
  WeatherData? weatherData;
  String visibility = "...";
  String aqi = "...";
  int balance = 0;
  int extraBalance = 0;
  var log = Logger();
  late FocusNode _focusNode;

  // Default location: FPT University HCM Hi-tech park Campus
  double lat = 10.8411276;
  double lon = 106.809883;

  final CallWalletApi _walletApi = CallWalletApi();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _initialize() async {
    _focusNode = FocusNode()..addListener(_onFocusChange);
    await _loadHideBalance();
    await _fetchData();
  }

  Future<void> _fetchData() async {
    Set<String> errorMessages = {};

    setState(() => isReloading = true);

    await Future.wait([
      getWeather(errors: errorMessages, isAlone: false),
      getBalance(errors: errorMessages, isAlone: false),
      getExtraBalance(errors: errorMessages, isAlone: false),
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

    if (!mounted) return;
    setState(() => isReloading = false);
  }

  Future<void> _loadHideBalance() async {
    bool? hideBalance = await LocalStorageHelper.getValue(
        LocalStorageKey.isHiddenBalance, _currentEmail);
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  Future<void> getLocation() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    setState(() {
      isAllowLocation = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    });

    if (!isAllowLocation) return;

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    if (mounted) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
    }
  }

  Future<void> getWeather({Set<String>? errors, bool isAlone = false}) async {
    try {
      await getLocation();
      if (!isAllowLocation) return;

      weatherData = await OpenWeatherApi.fetchWeather(lat, lon);
      aqi = await OpenWeatherApi.fetchAirQuality(lat, lon);
      visibility = (weatherData!.visibility / 1000).toStringAsFixed(2);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log.e('Error during get weather: $e');
      errors?.add('Error during get weather');
      if (isAlone) {
        _showErrorDialog(
            'Error during get weather: ${ErrorMessage.somethingWentWrong}');
      }
    }
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
          balance = result.data ?? 0;
        });
      }
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
      errors?.add('Load Main Balance: ${ErrorMessage.somethingWentWrong}');
      if (isAlone) {
        _showErrorDialog(
            'Load Main Balance: ${ErrorMessage.somethingWentWrong}');
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
          extraBalance = extraBalanceModel.data!.balance;
        });
      }
    } catch (e) {
      log.e('Error during get extra balance: $e');
      errors?.add('Load Extra Balance: ${ErrorMessage.somethingWentWrong}');
      if (isAlone) {
        _showErrorDialog(
            'Load Extra Balance: ${ErrorMessage.somethingWentWrong}');
      }
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Set<String> errorMessages = {};

      getBalance(errors: errorMessages, isAlone: false);
      getExtraBalance(errors: errorMessages, isAlone: false);

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
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchData,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBannerAndMainItems(),
                  _buildWeatherWidget(),
                  _buildBaiParkingWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerAndMainItems() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildBanner(),
        _buildMainItems(),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.only(bottom: 130),
      child: ImageSlideshow(
        indicatorColor: Theme.of(context).colorScheme.secondary,
        indicatorBottomPadding: 45,
        indicatorRadius: 4,
        indicatorBackgroundColor: Theme.of(context).colorScheme.primary,
        initialPage: 0,
        indicatorPadding: 5,
        autoPlayInterval: 5000,
        isLoop: true,
        height: MediaQuery.of(context).size.height * 0.27,
        children: [
          AssetHelper.banner1,
          AssetHelper.banner2,
          AssetHelper.banner3,
          AssetHelper.banner4,
          AssetHelper.banner5,
        ].map((banner) => _bannerSliderItem(context, banner)).toList(),
      ),
    );
  }

  Widget _buildMainItems() {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          _buildBalanceRow(),
          _buildQuickAccessButtons(),
        ],
      ),
    );
  }

  Widget _buildBalanceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(WalletScreen.routeName),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage(AssetHelper.bic),
                  fit: BoxFit.fitWidth,
                  width: 30,
                ),
                const SizedBox(width: 5),
                Text(
                  _hideBalance ? '******' : UltilHelper.formatMoney(balance),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(WalletScreen.routeName, arguments: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Extra: ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
                Text(
                  _hideBalance
                      ? '******'
                      : UltilHelper.formatMoney(extraBalance),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessButtons() {
    final quickAccessItems = [
      QuickAccessItem(
        icon: Icons.input_rounded,
        title: 'Fund-in',
        onTap: () => Navigator.of(context).pushNamed(FundinScreen.routeName),
      ),
      QuickAccessItem(
        icon: Icons.wallet,
        title: 'Wallet',
        onTap: () => Navigator.of(context).pushNamed(WalletScreen.routeName),
      ),
      QuickAccessItem(
        icon: Icons.insert_chart_outlined_rounded,
        title: 'Insights',
        onTap: () => Navigator.of(context).pushNamed(InsightScreen.routeName),
      ),
      QuickAccessItem(
        icon: Icons.motorcycle_rounded,
        title: 'Bai',
        onTap: () => Navigator.of(context).pushNamed(
          MyNavigationBar.routeName,
          arguments: 1, // MainNavigator.Bai,
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: quickAccessItems
          .map((item) => _buildQuickAccessButton(item))
          .toList(),
    );
  }

  Widget _buildQuickAccessButton(QuickAccessItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.title,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return ShadowContainer(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          _buildWeatherHeader(),
          const SizedBox(height: 13),
          isAllowLocation
              ? _buildWeatherContent()
              : _buildLocationPermissionMessage(),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Weather',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (!isAllowLocation) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmDialog(
                          title: 'Enable location service',
                          content: Text(
                            'Please enable location service to get weather information. After enabling, please refresh the page.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          positiveLabel: 'Open settings',
                          onConfirm: () {
                            Geolocator.openAppSettings();

                            Navigator.of(context).pop();
                          },
                        );
                      });
                }

                log.d('is Clicked!: $isAllowLocation');
              },
              child: Text(
                isAllowLocation
                    ? (isReloading
                        ? 'Loading...'
                        : '${weatherData?.name ?? '...'}, ${weatherData?.sys.country ?? '...'}')
                    : 'Enable location permission',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
            const SizedBox(width: 5),
            if (isAllowLocation)
              GestureDetector(
                onTap: getWeather,
                child: isReloading
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.refresh_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherContent() {
    return Column(
      children: [
        _buildWeatherOverview(),
        const SizedBox(height: 10),
        _buildWeatherDetails(),
        _buildLastUpdated(),
      ],
    );
  }

  Widget _buildWeatherOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (weatherData?.weather[0].icon == null)
                  ? const Icon(Icons.hourglass_top_rounded)
                  : Image.network(
                      'http://openweathermap.org/img/wn/${weatherData?.weather[0].icon}.png',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(
                '${weatherData?.main.temp ?? '...'}°C',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Real feel: ${weatherData?.main.feelsLike ?? '...'}°C',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWeatherDetailColumn(
          [
            WeatherDetailItem(
              icon: FontAwesomeIcons.temperatureHalf,
              value: '${weatherData?.main.temp ?? '...'}°C',
            ),
            WeatherDetailItem(
              icon: FontAwesomeIcons.cloud,
              value: '${weatherData?.clouds.all ?? '...'}%',
            ),
          ],
        ),
        _buildWeatherDetailColumn(
          [
            WeatherDetailItem(
              icon: FontAwesomeIcons.wind,
              value: '${weatherData?.wind.speed ?? '...'} m/s',
            ),
            WeatherDetailItem(
              icon: FontAwesomeIcons.droplet,
              value: '${weatherData?.main.humidity ?? '...'}%',
            ),
          ],
        ),
        _buildWeatherDetailColumn(
          [
            WeatherDetailItem(
              icon: Icons.visibility_rounded,
              value: '$visibility km',
            ),
            WeatherDetailItem(
              icon: Icons.air,
              value: aqi,
              isCustomIcon: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetailColumn(List<WeatherDetailItem> items) {
    return Expanded(
      flex: 1,
      child: Column(
        children: items.map((item) => _buildWeatherDetailRow(item)).toList(),
      ),
    );
  }

  Widget _buildWeatherDetailRow(WeatherDetailItem item) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: item.isCustomIcon
              ? Text(
                  'AQI',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6),
                      ),
                )
              : Icon(
                  item.icon,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 5,
          child: Text(
            item.value,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        'Last updated: ${weatherData == null ? 'loading...' : _getLastUpdated(weatherData!)}',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
      ),
    );
  }

  Widget _buildLocationPermissionMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Icon(
            Icons.remove_circle_rounded,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            Message.enableLocationService,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBaiParkingWidget() {
    return ShadowContainer(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(AssetHelper.imgLogo),
                  fit: BoxFit.fitHeight,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Bai Parking',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Image(
              image: AssetImage(AssetHelper.poster),
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerSliderItem(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FullScreenImageDialog(imagePath: imagePath);
          },
        );
      },
      child: ClipRRect(
        child: Image(
          width: double.infinity,
          image: AssetImage(imagePath),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  String _getLastUpdated(WeatherData weatherData) {
    String lastUpdated = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(weatherData.dt * 1000));

    String timezone = weatherData.timezone ~/ 3600 >= 0
        ? 'GMT+${weatherData.timezone ~/ 3600}'
        : 'GMT${weatherData.timezone ~/ 3600}';

    return '$lastUpdated $timezone';
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

class FullScreenImageDialog extends StatelessWidget {
  final String imagePath;

  const FullScreenImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class QuickAccessItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  QuickAccessItem(
      {required this.icon, required this.title, required this.onTap});
}

class WeatherDetailItem {
  final IconData icon;
  final String value;
  final bool isCustomIcon;

  WeatherDetailItem(
      {required this.icon, required this.value, this.isCustomIcon = false});
}
