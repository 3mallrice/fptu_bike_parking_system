import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart'
    show ImageSlideshow;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:bai_system/api/model/bai_model/wallet_model.dart';
import 'package:bai_system/api/service/bai_be/wallet_service.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/representation/insight.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:bai_system/representation/wallet_extra_screen.dart';
import 'package:bai_system/representation/wallet_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:logger/logger.dart' show Logger;

import '../api/model/bai_model/api_response.dart';
import '../api/model/weather/weather.dart' show WeatherData;
import '../api/service/weather/open_weather_api.dart' show OpenWeatherApi;
import '../component/shadow_container.dart' show ShadowContainer;
import '../core/const/frondend/message.dart';
import '../core/helper/asset_helper.dart' show AssetHelper;
import '../core/helper/local_storage_helper.dart';
import '../core/helper/return_login_dialog.dart';
import 'fundin_screen.dart' show FundinScreen;

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  static String routeName = '/home_screen';

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  bool _hideBalance = false;
  var log = Logger();
  bool isAllowLocation = false;
  bool isReloading = false;

  Future<void> _loadHideBalance() async {
    bool? hideBalance =
        await LocalStorageHelper.getValue(LocalStorageKey.isHiddenBalance);
    // log.i('Hide balance: $hideBalance');
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  //default location: FPT University HCM Hi-tech park Campus
  double lat = 10.8411276;
  double lon = 106.809883;
  WeatherData? weatherData;
  String visibility = "...";
  String aqi = "...";

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

    log.i('Latitude: $lat/nLongitude: $lon');
  }

  void getWeather() async {
    setState(() {
      isReloading = true;
    });

    await getLocation();
    if (!isAllowLocation) {
      setState(() {
        isReloading = false;
      });
      return;
    }

    weatherData = await OpenWeatherApi.fetchWeather(lat, lon);
    aqi = await OpenWeatherApi.fetchAirQuality(lat, lon);
    visibility = (weatherData!.visibility / 1000).toStringAsFixed(2);

    if (mounted) {
      setState(() {
        log.i('Visibility: $visibility km');
        log.i('Weather: ${weatherData!.weather[0].main}');
      });
    }

    setState(() {
      isReloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
    _loadHideBalance();
    getBalance();
    getExtraBalance();

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      getBalance();
      getExtraBalance();
    }
  }

  final CallWalletApi _walletApi = CallWalletApi();
  late int balance = 0;
  late int extraBalance = 0;
  late FocusNode _focusNode;

  Future<void> getBalance() async {
    try {
      final APIResponse<int> result = await _walletApi.getMainWalletBalance();

      if (result.isTokenValid == false &&
          result.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      setState(() {
        balance = result.data ?? 0;
        log.i('Main wallet balance: $balance');
      });
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
  }

  Future<void> getExtraBalance() async {
    try {
      APIResponse<ExtraBalanceModel> extraBalanceModel =
          await _walletApi.getExtraWalletBalance();

      if (extraBalanceModel.isTokenValid == false &&
          extraBalanceModel.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (extraBalanceModel.data != null) {
        setState(() {
          extraBalance = extraBalanceModel.data!.balance;
        });
      }
    } catch (e) {
      log.e('Error during get extra balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            getWeather();
            getBalance();
            getExtraBalance();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      //Banner
                      _showBanner(),

                      //Main items
                      _mainItems(),
                    ],
                  ),

                  //Weather
                  ShadowContainer(
                    margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Weather',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                isAllowLocation
                                    ? Text(
                                        isReloading
                                            ? 'Loading...'
                                            : '${weatherData?.name ?? '...'}, ${weatherData?.sys.country ?? '...'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                            ),
                                      )
                                    : Text(
                                        'Enable location permission',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                            ),
                                      ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () => getWeather(),
                                  child: isReloading
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          Icons.refresh_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 18,
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        (isAllowLocation == false)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.remove_circle_rounded,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      Message.enableLocationService,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  //weather data
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            (weatherData?.weather[0].icon ==
                                                    null)
                                                ? const Icon(
                                                    Icons.hourglass_top_rounded)
                                                : Image.network(
                                                    'http://openweathermap.org/img/wn/${weatherData?.weather[0].icon}.png',
                                                    alignment: Alignment.center,
                                                    fit: BoxFit.contain,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Text(
                                              'Real feel: ${weatherData?.main.feelsLike ?? '...'}°C',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        // Temperature and cloud
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .temperatureHalf,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Icon(
                                                    FontAwesomeIcons.cloud,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.6),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${weatherData?.main.temp ?? '...'}°C',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    '${weatherData?.clouds.all ?? '...'}%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        // Wind speed and humidity
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.wind,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Icon(
                                                    FontAwesomeIcons.droplet,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.6),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${weatherData?.wind.speed ?? '...'} m/s',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    '${weatherData?.main.humidity ?? '...'}%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        // Wind speed and humidity
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.visibility_rounded,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.6),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'AQI',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.6),
                                                        ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$visibility km',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    aqi,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Last updated: ${weatherData == null ? 'loading...' : getLastUpdated(weatherData!)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),

                  //Bai Parking
                  ShadowContainer(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
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
                            image: AssetImage(AssetHelper.bai),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showBanner() {
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
          bannerSliderItem(context, AssetHelper.banner1),
          bannerSliderItem(context, AssetHelper.banner2),
          bannerSliderItem(context, AssetHelper.banner3),
          bannerSliderItem(context, AssetHelper.banner4),
          bannerSliderItem(context, AssetHelper.banner5),
        ],
      ),
    );
  }

  Widget _mainItems() {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(MyWallet.routeName),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage(AssetHelper.bic),
                        fit: BoxFit.fitWidth,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _hideBalance
                            ? '******'
                            : UltilHelper.formatMoney(balance),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(WalletExtraScreen.routeName),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Extra: ',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                      ),
                      Text(
                        _hideBalance
                            ? '******'
                            : UltilHelper.formatMoney(extraBalance),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              homeMainItem(
                context,
                () => Navigator.of(context).pushNamed(FundinScreen.routeName),
                Icons.input_rounded,
                'Fund-in',
              ),
              homeMainItem(
                context,
                () => Navigator.of(context).pushNamed(MyWallet.routeName),
                Icons.wallet,
                'Wallet',
              ),
              homeMainItem(
                context,
                () => Navigator.of(context).pushNamed(InsightScreen.routeName),
                Icons.insert_chart_outlined_rounded,
                'Insights',
              ),
              homeMainItem(
                context,
                () => Navigator.of(context).pushNamed(
                  MyNavigationBar.routeName,
                  arguments: 1, // MainNavigator.Bai,
                ),
                Icons.motorcycle_rounded,
                'Bai',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getLastUpdated(WeatherData weatherData) {
    String lastUpdated = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(weatherData.dt * 1000));

    String timezone = weatherData.timezone ~/ 3600 >= 0
        ? 'GMT+${weatherData.timezone ~/ 3600}'
        : 'GMT${weatherData.timezone ~/ 3600}';

    String returnString = '$lastUpdated $timezone';

    return returnString;
  }

  GestureDetector homeMainItem(
      BuildContext context, Function()? onTap, IconData icon, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
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
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector bannerSliderItem(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FullScreenImageDialog(
              imagePath: imagePath,
            );
          },
        );
      },
      child: ClipRRect(
        child: Image(
          width: double.infinity,
          image: AssetImage(
            imagePath,
          ),
          fit: BoxFit.fitWidth,
        ),
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
