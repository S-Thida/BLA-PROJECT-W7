import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/rides_preferences_provider.dart';

import '../../../model/ride/ride_filter.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';

import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
/// The Ride Selection screen allows users to select a ride after setting their ride preferences.
/// Users can also update preferences and apply filters.
///
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  final RideFilter currentFilter = RideFilter(); 

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(RidePreference newPreference, BuildContext context) {
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
  }

  void onPreferencePressed(RidePreference? currentPreference, BuildContext context) async {
    // Open a modal to edit ride preferences
    
    RidePreference? newPreference = await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference using Provider
      onRidePrefSelected(newPreference, context);
    }
  }

  void onFilterPressed(){}

  @override
  Widget build(BuildContext context) {
    final ridePrefProvider = context.watch<RidesPreferencesProvider>();

    // Handle null preference case
    RidePreference? currentPreference = ridePrefProvider.currentPreference;
    if (currentPreference == null) {
      return const Scaffold(
        body: Center(child: Text("No ride preferences set yet!")),
      );
    }

    List<Ride> matchingRides = RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(currentPreference, context),
              onFilterPressed: onFilterPressed,
            ),

            // Ride list
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
