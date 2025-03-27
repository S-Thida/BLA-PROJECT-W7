import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import '/model/ride/ride_pref.dart';

class RidesPreferencesProvider extends ChangeNotifier {
RidePreference? _currentPreference;
List<RidePreference> _pastPreferences = [];
final RidePreferencesRepository repository;
RidesPreferencesProvider({required this.repository}) ;


RidePreference? get currentPreference => _currentPreference;
void setCurrentPreference(RidePreference pref) {
if (_currentPreference == pref) return; // Avoid duplicate selections
    _currentPreference = pref;
    _addPreference(pref);
    notifyListeners();
}

void _addPreference(RidePreference preference) {
  debugPrint('Adding preference: ${preference.departure.name} → ${preference.arrival.name}');
  if (!_pastPreferences.contains(preference)) {
    _pastPreferences.add(preference);
    repository.addPreference(preference);
    debugPrint('History count: ${_pastPreferences.length}');
  }
}
// History is returned from newest to oldest preference
List<RidePreference> get preferencesHistory =>
_pastPreferences.reversed.toList();

}