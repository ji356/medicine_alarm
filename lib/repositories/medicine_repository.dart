import 'dart:developer';

import 'drug_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    _medicineBox ??= Hive.box<Medicine>(DrugHiveBox.medicine);
    return _medicineBox!;
  }

  void addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('[deleteMedicine] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({required int key, required Medicine medicine}) async {
    await medicineBox.put(key, medicine);

    log('[updateMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
