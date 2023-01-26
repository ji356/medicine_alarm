import 'dart:io';

import '../../components/drug_constants.dart';
import '../../main.dart';
import '../../models/medicine.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'components/add_page_widget.dart';
import '../../services/add_medicine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/drug_widgets.dart';
import '../../services/drug_file_service.dart';

// ignore: must_be_immutable
class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {super.key,
      required this.medicineImage,
      required this.medicineName,
      required this.updateMedicineId}) {
    service = AddMedicineService(updateMedicineId);
  }

  final int updateMedicineId;
  final File? medicineImage;
  final String medicineName;

  late AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(children: [
        Text(
          '매일 복약 잊지 말아요!',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: largeSpace),
        Expanded(
            child: AnimatedBuilder(
          builder: (context, _) {
            return ListView(
              children: alarmWidgets,
            );
          },
          animation: service,
        )),
      ]),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          var result = false;

          for (var alarm in service.alarms) {
            result = await notification.addNotification(
              alarmTimeStr: alarm,
              body: '$alarm 약 먹을 시간이예요!',
              title: '$medicineName 복약했다고 알려주세요!',
              medicineId: medicineRepository.newId,
            );

            if (!result) break;
          }
          if (!result) {
            // ignore: use_build_context_synchronously
            return showPermissionDenied(context, permission: '알람');
          }

          String? imageFilePath;
          if (medicineImage != null) {
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }

          final medicine = Medicine(
              id: medicineRepository.newId,
              name: medicineName,
              imagePath: imageFilePath,
              alarms: service.alarms);

          medicineRepository.addMedicine(medicine);

          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(service.alarms.map((time) => AlarmBox(
          time: time,
          service: service,
        )));
    children.add(AddAlarmButton(
      service: service,
    ));

    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.time,
    required this.service,
  }) : super(key: key);

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                service.removeAlarm(time);
              },
              icon: const Icon(CupertinoIcons.minus_circle)),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle2),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return TimeSettingBottomSheet(
                        initialTime: time,
                      );
                    }).then((value) {
                  if (value == null || value is! DateTime) return;
                  service.setAlarm(prevTime: time, setTime: value);
                });
              },
              child: Text(time)),
        )
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key,
    required this.service,
  }) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circle_fill)),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          )
        ],
      ),
    );
  }
}
