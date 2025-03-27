import '../location/locations.dart';

///
/// This model describes a ride preference.
/// A ride preference consists of the selection of a departure + arrival + a date and a number of passenger
///
class RidePreference {
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;

  const RidePreference(
      {required this.departure,
      required this.departureDate,
      required this.arrival,
      required this.requestedSeats});

  // operator ==

  @override
bool operator ==(Object other) {
  return other is RidePreference &&
      departure == other.departure &&
      arrival == other.arrival &&
      departureDate.isAtSameMomentAs(other.departureDate) &&
      requestedSeats == other.requestedSeats;
}

  // hash code 
  @override
   int get hashCode {
    return Object.hash(
      departure.hashCode,
      departureDate.millisecondsSinceEpoch, // Important for DateTime
      arrival.hashCode,
      requestedSeats,
    );
  }

  @override
  String toString() {
    return 'RidePref(departure: ${departure.name}, '
        'departureDate: ${departureDate.toIso8601String()}, '
        'arrival: ${arrival.name}, '
        'requestedSeats: $requestedSeats)';
  }
}
