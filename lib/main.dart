import 'package:drug_alarm/components/drug_themes.dart';
import 'package:drug_alarm/pages/home_page.dart';
import 'package:drug_alarm/repositories/drug_hive.dart';
import 'package:drug_alarm/repositories/medicine_repository.dart';
import 'package:drug_alarm/services/drug_notification_service.dart';
import 'package:flutter/material.dart';

final notification = DrugNotificationService();
final hive = DrugHive();
final medicineRepository = MedicineRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await notification.initializeTimeZone();
  await notification.initializeNotification();

  await hive.initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DrugThemes.lightTheme,
      home: const HomePage(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      ),
    );
  }
}
