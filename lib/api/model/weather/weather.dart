class WeatherData {
  final List<Weather> weather;
  final Main main;
  final Wind wind;
  final int visibility;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final String name;
  final int cod;

  WeatherData({
    required this.weather,
    required this.main,
    required this.wind,
    required this.visibility,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.name,
    required this.cod,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      weather:
          List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      visibility: json['visibility'],
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      timezone: json['timezone'],
      name: json['name'],
      cod: json['cod'],
    );
  }
}

class Weather {
  final String main;
  final String icon;

  Weather({
    required this.main,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'],
      icon: json['icon'],
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'],
      feelsLike: json['feels_like'],
      humidity: json['humidity'],
    );
  }
}

class Wind {
  final double speed;

  Wind({
    required this.speed,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'],
    );
  }
}

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}

class Sys {
  final String country;

  Sys({
    required this.country,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'],
    );
  }
}
