import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/secret_key.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherservice = WeatherService(apikey: apiKey);
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get city
    String city = await _weatherservice.getCurrentCity();

    //get weather
    try {
      final weather = await _weatherservice.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/Cloudy.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'thuderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            const Icon(
              Icons.location_on,
              size: 30,
              color: Colors.white,
            ),
            Text(
              _weather?.cityName ?? "Loading City name...",
              style: GoogleFonts.robotoSlab(
                fontStyle: FontStyle.italic,
                fontSize: 35,
                color: Colors.white,
              ),
            ),

            const SizedBox(
              height: 100,
            ),

            //weather main condition
            // Text(_weather?.maincondition ?? ''),

            //animation
            Lottie.asset(
              getWeatherAnimation(_weather?.maincondition),
            ),

            const SizedBox(
              height: 70,
            ),

            //temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: GoogleFonts.robotoSlab(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
