import 'package:drug_alarm/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMedicineService with ChangeNotifier {
  AddMedicineService(int updateMedicineId) {
    final isUpdate = updateMedicineId != -1;
    if (isUpdate) {
      final updateAlarms = medicineRepository.medicineBox.values
          .singleWhere((medicine) => medicine.id == updateMedicineId)
          .alarms;

      _alarms.clear();
      _alarms.addAll(updateAlarms);
    }
  }

  final _alarms = <String>[
    '08:00',
    '13:00',
    '19:00',
  ];

  List<String> get alarms => _alarms;

  void addNowAlarm() {
    final now = DateTime.now();
    final nowTime = DateFormat('HH:mm').format(now);
    _alarms.add(nowTime);
    notifyListeners();
  }

  void removeAlarm(String time) {
    _alarms.remove(time);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}) {
    _alarms.remove(prevTime);

    final setTimeString = DateFormat('HH:mm').format(setTime);
    _alarms.add(setTimeString);
    notifyListeners();
  }
}
