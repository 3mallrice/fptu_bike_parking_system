import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart'
    show ImageSlideshow;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';
import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, Position;
import 'package:intl/intl.dart' show DateFormat;
import 'package:logger/logger.dart' show Logger;

import '../api/model/weather/weather.dart' show WeatherData;
import '../api/service/weather/open_weather_api.dart' show OpenWeatherApi;
import '../component/shadow_container.dart' show ShadowContainer;
import '../core/helper/asset_helper.dart' show AssetHelper;
import 'fundin_screen.dart' show FundinScreen;

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  static String routeName = '/home_screen';

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  var log = Logger();

  //default location: FPT University HCM Hi-tech park Campus
  double lat = 10.8411276;
  double lon = 106.809883;
  WeatherData? weatherData;
  String visibility = "null";
  String aqi = "null";

  Future getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    log.i('Latitude: $lat/nLongitude: $lon');
  }

  //get data from API
  void getWeather() async {
    await getLocation();
    weatherData = await OpenWeatherApi.fetchWeather(lat, lon);
    visibility = (weatherData!.visibility / 1000).toStringAsFixed(2);
    aqi = await OpenWeatherApi.fetchAirQuality(lat, lon);
    setState(() {
      weatherData = weatherData;
      visibility = visibility;
      aqi = aqi;
      log.i('Visibility: $visibility km');
    });
    log.i('Weather: ${weatherData!.weather[0].main}');
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 130),
                  child: ImageSlideshow(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    indicatorBottomPadding: 45,
                    indicatorRadius: 4,
                    indicatorBackgroundColor:
                        Theme.of(context).colorScheme.primary,
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
                ),
                ShadowContainer(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Image(
                            image: AssetImage(AssetHelper.bic),
                            fit: BoxFit.fitWidth,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              '45.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          homeMainItem(
                              context,
                              () => Navigator.of(context)
                                  .pushNamed(FundinScreen.routeName),
                              Icons.input_rounded,
                              'Fund-in'),
                          homeMainItem(
                              context,
                              () => Navigator.of(context)
                                  .pushNamed(MyWallet.routeName),
                              Icons.wallet,
                              'Wallet'),
                          homeMainItem(context, () {},
                              Icons.insert_chart_outlined_rounded, 'Insights'),
                          homeMainItem(
                              context, () {}, Icons.motorcycle_rounded, 'Bais'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //Weather
            ShadowContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outside weather',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          Text(
                              '${weatherData?.name}, ${weatherData?.sys.country}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 12,
                                  )),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              '${weatherData?.main.temp}°C',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Real feel: ${weatherData?.main.feelsLike}°C',
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData?.main.temp}°C',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${weatherData?.clouds.all}%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData?.wind.speed} m/s',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${weatherData?.main.humidity}%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$visibility km',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    aqi,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                          .bodyMedium!
                          .copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),

            //Bai Parking
            ShadowContainer(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AssetHelper.imgLogo),
                          fit: BoxFit.contain,
                          width: 60,
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
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
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
          color: Theme.of(context).colorScheme.background,
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
          fit: BoxFit.cover,
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
