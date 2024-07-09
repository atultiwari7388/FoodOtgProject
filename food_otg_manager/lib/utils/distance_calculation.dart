// Function to calculate distance between two geographical points using Haversine formula
import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * (pi / 180)) *
          cos(lat2 * (pi / 180)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance;
}

// Function to check if the user is within 5 km range of the restaurant
bool isWithin5KmRange(
    double userLat, double userLong, double restLat, double restLong) {
  double distance = calculateDistance(userLat, userLong, restLat, restLong);
  print("Total distance: " + distance.toString() + "km");
  return distance <= 5;
}
