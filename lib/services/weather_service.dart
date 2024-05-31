import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apikey;
  WeatherService({required this.apikey});

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl?q=$cityName&appid=$apikey&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
// location permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

// fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

// convert the location into list of placemark objects
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
// get the city from 1st placemark

    String? city = placemark[0].locality;

    return city ?? '';
  }
}
