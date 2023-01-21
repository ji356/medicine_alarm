import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/drug_constants.dart';
import '../../components/drug_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        MedicineImageButton(imagePath: medicineAlaram.imagePath),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlaram: medicineAlaram),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text('🕑 ${medicineAlaram.alarmTime}', style: textStyle),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlaram.name},', style: textStyle),
          TileActionButton(
              onTap: () {
                historyRepository.addHistory(MedicineHistory(
                  medicineId: medicineAlaram.id,
                  alarmTime: medicineAlaram.alarmTime,
                  takeTime: DateTime.now(),
                  medicineKey: medicineAlaram.key,
                  name: medicineAlaram.name,
                  imagePath: medicineAlaram.imagePath,
                ));
              },
              title: '지금'),
          Text('|', style: textStyle),
          TileActionButton(onTap: () => _onPreviousTake(context), title: '아까'),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
            context: context,
            builder: ((context) =>
                TimeSettingBottomSheet(initialTime: medicineAlaram.alarmTime)))
        .then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.addHistory(MedicineHistory(
        medicineId: medicineAlaram.id,
        alarmTime: medicineAlaram.alarmTime,
        takeTime: takeDateTime,
        medicineKey: medicineAlaram.key,
        name: medicineAlaram.name,
        imagePath: medicineAlaram.imagePath,
      ));
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlaram,
    required this.history,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;
  final MedicineHistory history;

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        Stack(
          children: [
            MedicineImageButton(imagePath: medicineAlaram.imagePath),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.withOpacity(0.2),
              child: const Icon(color: Colors.white, CupertinoIcons.check_mark),
            )
          ],
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlaram: medicineAlaram),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text.rich(
        TextSpan(
          text: '✅ ${medicineAlaram.alarmTime} → ',
          style: textStyle,
          children: [
            TextSpan(
                text: takeTimeStr,
                style: textStyle?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlaram.name},', style: textStyle),
          TileActionButton(
              onTap: () => _onTap(context),
              title: DateFormat('HH시 mm분에').format(history.takeTime)),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  void _onTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: ((context) => TimeSettingBottomSheet(
              initialTime: takeTimeStr,
              submitTitle: '수정',
              bottomWidget: TextButton(
                onPressed: () {
                  historyRepository.deleteHistory(history.key);
                  Navigator.pop(context);
                },
                child: Text('복약 시간을 지우고 싶어요.',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ))).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.updateHistory(
          key: history.key,
          history: MedicineHistory(
            medicineId: medicineAlaram.id,
            alarmTime: medicineAlaram.alarmTime,
            takeTime: takeDateTime,
            medicineKey: medicineAlaram.key,
            name: medicineAlaram.name,
            imagePath: medicineAlaram.imagePath,
          ));
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        medicineRepository.deleteMedicine(medicineAlaram.key);
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
    );
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(context,
                  FadePageRoute(page: ImageDetailPage(imagePath: imagePath!)));
            },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
      ),
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
