import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import '/model/ride/ride_pref.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;
  RidesPreferencesProvider({required this.repository}){
     
    pastPreferences = AsyncValue.loading(); // Initialize here
    fetchPastPreferences();
  
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference == pref) return; // Avoid duplicate selections
    _currentPreference = pref;
    addPreference(pref);
    notifyListeners();
  }

  Future<void> addPreference(RidePreference preference) async {
    try {
      // 1. Add to the Repository

      await repository.addPreference(preference);

      // 2. Refetch data again

      await fetchPastPreferences();
    } catch (e) {
      pastPreferences = AsyncValue.error(e);
    }

    notifyListeners();
  }

// History is returned from newest to oldest preference
  // List<RidePreference> get preferencesHistory =>
  //     _pastPreferences.reversed.toList();

// fetch the past preference
  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
// 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
// 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
// 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }
}
