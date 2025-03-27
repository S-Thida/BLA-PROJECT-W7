import 'package:week_3_blabla_project/data/dto/location_dto.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class RidePreferenceDto {
  static Map<String, dynamic> toJson(RidePreference model) {
    return {
      'arrival': LocationDto.toJson(model.arrival),
      'departure': LocationDto.toJson(model.departure),
      'departureDate': model.departureDate.toIso8601String(),
      'requestedSeats': model.requestedSeats
    };
  }

  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
        arrival: LocationDto.fromJson(json['arrival']),
        departure: LocationDto.fromJson(json['departure']),
        departureDate: DateTime.parse(json['departureDate']),
        requestedSeats: json['requestedSeats']);
  }
}
