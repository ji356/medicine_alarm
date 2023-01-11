import '../models/medicine_history.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';

class DrugHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());
    await Hive.openBox<Medicine>(DrugHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(DrugHiveBox.medicineHistory);
  }
}

class DrugHiveBox {
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}
