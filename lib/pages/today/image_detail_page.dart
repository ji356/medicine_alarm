import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/medicine_alarm.dart';

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
