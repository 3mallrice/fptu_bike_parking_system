import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart'
    show ImageSlideshow;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:fptu_bike_parking_system/api/model/bai_model/wallet_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/wallet_service.dart';
import 'package:fptu_bike_parking_system/core/helper/util_helper.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:fptu_bike_parking_system/representation/wallet_extra_screen.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';
import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, Position;
import 'package:intl/intl.dart' show DateFormat;
import 'package:logger/logger.dart' show Logger;

import '../api/model/weather/weather.dart' show WeatherData;
import '../api/service/weather/open_weather_api.dart' show OpenWeatherApi;
import '../component/shadow_container.dart' show ShadowContainer;
import '../core/helper/asset_helper.dart' show AssetHelper;
import '../core/helper/local_storage_helper.dart';
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

  Future getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    if (mounted) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
    }

    log.i('Latitude: $lat/nLongitude: $lon');
  }

  //get data from API
  void getWeather() async {
    await getLocation();
    weatherData = await OpenWeatherApi.fetchWeather(lat, lon);
    visibility = (weatherData!.visibility / 1000).toStringAsFixed(2);
    aqi = await OpenWeatherApi.fetchAirQuality(lat, lon);
    if (mounted) {
      setState(() {
        weatherData = weatherData;
        visibility = visibility;
        aqi = aqi;
        log.i('Visibility: $visibility km');
      });
    }
    log.i('Weather: ${weatherData!.weather[0].main}');
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

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      getBalance();
      getExtraBalance();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  CallWalletApi callWalletApi = CallWalletApi();
  late int balance = 0;
  late int extraBalance = 0;
  late FocusNode _focusNode;

  Future<void> getBalance() async {
    try {
      final int? result = await callWalletApi.getMainWalletBalance();
      setState(() {
        balance = result ?? 0;
        log.i('Main wallet balance: $balance');
      });
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
  }

  Future<void> getExtraBalance() async {
    try {
      ExtraBalanceModel? extraBalanceModel =
          await callWalletApi.getExtraWalletBalance();
      if (extraBalanceModel != null) {
        setState(() {
          extraBalance = extraBalanceModel.balance;
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
        body: SafeArea(
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
                              Text(
                                '${weatherData?.name ?? '...'}, ${weatherData?.sys.country ?? '...'}',
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
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      //weather data
                      Row(
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Real feel: ${weatherData?.main.feelsLike ?? '...'}°C',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                                        FontAwesomeIcons.temperatureHalf,
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
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
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
                                        overflow: TextOverflow.ellipsis,
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
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
                            : UltilHelper.formatNumber(balance),
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
                            : UltilHelper.formatNumber(extraBalance),
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
                () {
                  //TODO: Do something here
                },
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
