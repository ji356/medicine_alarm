import 'dart:io';

import 'package:drug_alarm/components/drug_constants.dart';
import 'package:drug_alarm/components/drug_page_route.dart';
import 'package:drug_alarm/main.dart';
import 'package:drug_alarm/models/medicine_alarm.dart';
import 'package:drug_alarm/models/medicine_history.dart';
import 'package:drug_alarm/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import 'today_empty_widget.dart';

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

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (BuildContext context, int index) {
              return MedicineListTile(medicineAlaram: medicineAlarms[index]);
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
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: medicineAlaram.imagePath == null
              ? null
              : () {
                  Navigator.push(
                      context,
                      FadePageRoute(
                          page:
                              ImageDetailPage(medicineAlaram: medicineAlaram)));
                },
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlaram.imagePath == null
                ? null
                : FileImage(File(medicineAlaram.imagePath!)),
          ),
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🕑 ${medicineAlaram.alarmTime}', style: textStyle),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${medicineAlaram.name},', style: textStyle),
                  TileActionButton(onTap: () {}, title: '지금'),
                  Text('|', style: textStyle),
                  TileActionButton(
                      onTap: () {
                        showModalBottomSheet(
                                context: context,
                                builder: ((context) => TimeSettingBottomSheet(
                                    initialTime: medicineAlaram.alarmTime)))
                            .then((takeDateTime) {
                          if (takeDateTime == null ||
                              takeDateTime is! DateTime) {
                            return;
                          }

                          historyRepository.addHistory(MedicineHistory(
                              medicineId: medicineAlaram.id,
                              alarmTime: medicineAlaram.alarmTime,
                              takeTime: takeDateTime));
                        });
                      },
                      title: '아까'),
                  Text('먹었어요!', style: textStyle),
                ],
              )
            ],
          ),
        ),
        CupertinoButton(
          onPressed: () {
            medicineRepository.deleteMedicine(medicineAlaram.key);
          },
          child: const Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton()),
      body: Center(child: Image.file(File(medicineAlaram.imagePath!))),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.w800);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
