import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BirthdayAnniversaryScreen extends StatelessWidget {
  static const String id = "anniversary_birthday";

  const BirthdayAnniversaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final usersDocs = snapshot.data!.docs;
            return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Drivers').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> driverSnapshot) {
                if (driverSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (driverSnapshot.hasError) {
                  return Center(child: Text('Error: ${driverSnapshot.error}'));
                }
                final driversDocs = driverSnapshot.data!.docs;

                final today = DateTime.now();
                final List<Map<String, dynamic>> birthdaysAnniversaries = [];

                // Check users' birthdays and anniversaries
                for (final userDoc in usersDocs) {
                  final user = userDoc.data() as Map<String, dynamic>;

                  // Check if dob and anniversary are not empty before parsing
                  if (user['dob'] != null &&
                      user['dob'] != "" &&
                      user['anniversary'] != null &&
                      user['anniversary'] != "") {
                    final userDob = _parseDate(user['dob']);
                    final userAnniversary = _parseDate(user['anniversary']);

                    // Check if it's today's birthday or anniversary
                    if (userDob.month == today.month &&
                        userDob.day == today.day) {
                      birthdaysAnniversaries
                          .add({'name': user['userName'], 'type': 'Birthday'});
                    }
                    if (userAnniversary.month == today.month &&
                        userAnniversary.day == today.day) {
                      birthdaysAnniversaries.add(
                          {'name': user['userName'], 'type': 'Anniversary'});
                    }
                  }
                }

                // Check drivers' birthdays and anniversaries
                for (final driverDoc in driversDocs) {
                  final driver = driverDoc.data() as Map<String, dynamic>;

                  // Check if dob and anniversary are not empty before parsing
                  if (driver['dob'] != null &&
                      driver['dob'] != "" &&
                      driver['anniversary'] != null &&
                      driver['anniversary'] != "") {
                    final driverDob = _parseDate(driver['dob']);
                    final driverAnniversary = _parseDate(driver['anniversary']);

                    // Check if it's today's birthday or anniversary
                    if (driverDob.month == today.month &&
                        driverDob.day == today.day) {
                      birthdaysAnniversaries.add(
                          {'name': driver['userName'], 'type': 'Birthday'});
                    }
                    if (driverAnniversary.month == today.month &&
                        driverAnniversary.day == today.day) {
                      birthdaysAnniversaries.add(
                          {'name': driver['userName'], 'type': 'Anniversary'});
                    }
                  }
                }

                if (birthdaysAnniversaries.isEmpty) {
                  return const Center(
                      child: Text('No birthdays or anniversaries today.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: birthdaysAnniversaries.length,
                  itemBuilder: (context, index) {
                    final entry = birthdaysAnniversaries[index];
                    return ListTile(
                      title: Text('${entry['name']}\'s ${entry['type']}'),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Birthday And Anniversary ")),
        body: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final usersDocs = snapshot.data!.docs;
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Drivers')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> driverSnapshot) {
                  if (driverSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (driverSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${driverSnapshot.error}'));
                  }
                  final driversDocs = driverSnapshot.data!.docs;

                  final today = DateTime.now();
                  final List<Map<String, dynamic>> birthdaysAnniversaries = [];

                  // Check users' birthdays and anniversaries
                  for (final userDoc in usersDocs) {
                    final user = userDoc.data() as Map<String, dynamic>;

                    // Check if dob and anniversary are not empty before parsing
                    if (user['dob'] != null &&
                        user['dob'] != "" &&
                        user['anniversary'] != null &&
                        user['anniversary'] != "") {
                      final userDob = _parseDate(user['dob']);
                      final userAnniversary = _parseDate(user['anniversary']);

                      // Check if it's today's birthday or anniversary
                      if (userDob.month == today.month &&
                          userDob.day == today.day) {
                        birthdaysAnniversaries.add(
                            {'name': user['userName'], 'type': 'Birthday'});
                      }
                      if (userAnniversary.month == today.month &&
                          userAnniversary.day == today.day) {
                        birthdaysAnniversaries.add(
                            {'name': user['userName'], 'type': 'Anniversary'});
                      }
                    }
                  }

                  // Check drivers' birthdays and anniversaries
                  for (final driverDoc in driversDocs) {
                    final driver = driverDoc.data() as Map<String, dynamic>;

                    // Check if dob and anniversary are not empty before parsing
                    if (driver['dob'] != null &&
                        driver['dob'] != "" &&
                        driver['anniversary'] != null &&
                        driver['anniversary'] != "") {
                      final driverDob = _parseDate(driver['dob']);
                      final driverAnniversary =
                          _parseDate(driver['anniversary']);

                      // Check if it's today's birthday or anniversary
                      if (driverDob.month == today.month &&
                          driverDob.day == today.day) {
                        birthdaysAnniversaries.add(
                            {'name': driver['userName'], 'type': 'Birthday'});
                      }
                      if (driverAnniversary.month == today.month &&
                          driverAnniversary.day == today.day) {
                        birthdaysAnniversaries.add({
                          'name': driver['userName'],
                          'type': 'Anniversary'
                        });
                      }
                    }
                  }

                  if (birthdaysAnniversaries.isEmpty) {
                    return const Center(
                        child: Text('No birthdays or anniversaries today.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: birthdaysAnniversaries.length,
                    itemBuilder: (context, index) {
                      final entry = birthdaysAnniversaries[index];
                      return ListTile(
                        title: Text('${entry['name']}\'s ${entry['type']}'),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      );
    }
  }

// Function to parse date string or timestamp
  DateTime _parseDate(dynamic dateValue) {
    if (dateValue is String) {
      if (dateValue.isEmpty) {
        return DateTime(1970); // Return a default date if the string is empty
      } else {
        // Try parsing the date string in the format "15 February 2024 at 00:00:00 UTC+5:30"
        try {
          final parts = dateValue.split(" ");
          final day = int.parse(parts[0]);
          final monthString = parts[1];
          final year = int.parse(parts[2]);
          final month = _parseMonth(monthString);
          return DateTime(year, month, day);
        } catch (e) {
          print("Error parsing date: $e");
          return DateTime(1970); // Return a default date if parsing fails
        }
      }
    } else if (dateValue is Timestamp) {
      // Handle timestamp
      return dateValue.toDate();
    } else {
      // Handle other cases
      return DateTime(1970); // Return a default date
    }
  }

  // Function to parse month string
  int _parseMonth(String monthString) {
    switch (monthString) {
      case "January":
        return DateTime.january;
      case "February":
        return DateTime.february;
      case "March":
        return DateTime.march;
      case "April":
        return DateTime.april;
      case "May":
        return DateTime.may;
      case "June":
        return DateTime.june;
      case "July":
        return DateTime.july;
      case "August":
        return DateTime.august;
      case "September":
        return DateTime.september;
      case "October":
        return DateTime.october;
      case "November":
        return DateTime.november;
      case "December":
        return DateTime.december;
      default:
        return 1; // Return January as default
    }
  }
}
