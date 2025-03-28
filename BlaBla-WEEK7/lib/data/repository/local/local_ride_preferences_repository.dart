import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_preference_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidePrefsRepository implements RidePreferencesRepository {
  static const String _preferencesKey = "ride_prefernces";

  @override
  Future<void> addPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final List<RidePreference> preferences = await getPastPreferences();
    preferences.add(preference);
    await prefs.setStringList(_preferencesKey,preferences
            .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
            .toList());
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    //Get the SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Get the string list from the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
