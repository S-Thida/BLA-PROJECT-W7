import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import 'package:week_3_blabla_project/ui/providers/rides_preferences_provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  onRidePrefSelected(RidePreference newPreference, BuildContext context) async {
    // 1 - Update the current preference
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ridesPrefProvider = context.watch<RidesPreferencesProvider>();
    RidePreference? currentRidePreference = ridesPrefProvider.currentPreference;

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPreference) {
                        onRidePrefSelected(newPreference, context);
                      }),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                      height: 200, // Set a fixed height

                      child: _buildPastRidePrefListView(ridesPrefProvider, context)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPastRidePrefListView(
      RidesPreferencesProvider provider, BuildContext context) {
    final ridePrefValue = provider.pastPreferences;

    switch (ridePrefValue.state) {
      case AsyncValueState.loading:
        return const Center(
        child: SizedBox(
          width: 30,  // Controls the size of the spinner
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,  // Makes the line thinner
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue,  // Use your theme's primary color
            ),
          ),
        ),
      );

      case AsyncValueState.error:
        return Text('Error: ${ridePrefValue.error}');

      case AsyncValueState.success:
      final reversedList = ridePrefValue.data!.reversed.toList(); // Create reversed copy
  return ListView.builder(
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: reversedList.length,
    itemBuilder: (ctx, index) => RidePrefHistoryTile(
      ridePref: reversedList[index], // Use reversed list
      onPressed: () => onRidePrefSelected(reversedList[index], context),
    ),
  );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
