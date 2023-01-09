import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';

class DrugHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Medicine>(MedicineAdapter());
    await Hive.openBox<Medicine>(DrugHiveBox.medicine);
  }
}

class DrugHiveBox {
  static const String medicine = 'medicine';
}
