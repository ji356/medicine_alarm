import 'package:drug_alarm/models/medicine_history.dart';
import 'package:intl/intl.dart';

import '../../components/drug_constants.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import 'today_empty_widget.dart';
import 'today_take_tile.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "오늘 복용할 약은?",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regularSpace),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(MedicineAlarm(medicine.id, medicine.name,
            medicine.imagePath, alarm, medicine.key));
      }
    }

    medicineAlarms.sort((a, b) => DateFormat('HH:mm')
        .parse(a.alarmTime)
        .compareTo(DateFormat('HH:mm').parse(b.alarmTime)));

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListTile(medicineAlarms[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: regularSpace,
              );
            },
          ),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }

  Widget _buildListTile(MedicineAlarm medicineAlaram) {
    return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if (historyBox.values.isEmpty) {
          return BeforeTakeTile(medicineAlaram: medicineAlaram);
        }

        final todayTakeHistory = historyBox.values.singleWhere(
          (history) =>
              history.medicineId == medicineAlaram.id &&
              history.medicineKey == medicineAlaram.key &&
              history.alarmTime == medicineAlaram.alarmTime &&
              isToday(history.takeTime, DateTime.now()),
          orElse: () => MedicineHistory(
            medicineId: -1,
            alarmTime: '',
            takeTime: DateTime.now(),
            medicineKey: -1,
            name: '',
            imagePath: null,
          ),
        );

        if (todayTakeHistory.medicineId == -1 &&
            todayTakeHistory.alarmTime == '') {
          return BeforeTakeTile(medicineAlaram: medicineAlaram);
        }

        return AfterTakeTile(
          medicineAlaram: medicineAlaram,
          history: todayTakeHistory,
        );
      },
    );
  }
}

bool isToday(DateTime source, DateTime destiantion) {
  return source.year == destiantion.year &&
      source.month == destiantion.month &&
      source.day == destiantion.day;
}
