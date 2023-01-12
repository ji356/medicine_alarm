import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        _MedicineImageButton(medicineAlaram: medicineAlaram),
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
          TileActionButton(onTap: () {}, title: '지금'),
          Text('|', style: textStyle),
          TileActionButton(
              onTap: () {
                showModalBottomSheet(
                        context: context,
                        builder: ((context) => TimeSettingBottomSheet(
                            initialTime: medicineAlaram.alarmTime)))
                    .then((takeDateTime) {
                  if (takeDateTime == null || takeDateTime is! DateTime) {
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
    ];
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        Stack(
          children: [
            _MedicineImageButton(medicineAlaram: medicineAlaram),
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
                text: '20:19',
                style: textStyle?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlaram.name},', style: textStyle),
          TileActionButton(onTap: () {}, title: '20시 19분에'),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
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

class _MedicineImageButton extends StatelessWidget {
  const _MedicineImageButton({
    Key? key,
    required this.medicineAlaram,
  }) : super(key: key);

  final MedicineAlarm medicineAlaram;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: medicineAlaram.imagePath == null
          ? null
          : () {
              Navigator.push(
                  context,
                  FadePageRoute(
                      page: ImageDetailPage(medicineAlaram: medicineAlaram)));
            },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: medicineAlaram.imagePath == null
            ? null
            : FileImage(File(medicineAlaram.imagePath!)),
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
