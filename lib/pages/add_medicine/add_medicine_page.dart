import 'dart:io';

import 'package:drug_alarm/components/drug_constants.dart';
import 'package:drug_alarm/components/drug_page_route.dart';
import 'package:drug_alarm/components/drug_widgets.dart';
import 'package:drug_alarm/pages/add_medicine/add_alarm_page.dart';
import 'package:drug_alarm/pages/add_medicine/components/add_page_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../bottomsheet/pick_image_bottomsheet.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: AddPageBody(children: [
          const SizedBox(
            height: largeSpace,
          ),
          Text(
            '어떤 약이예요?',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Center(
            child: _MedicineImageButton(
              changeImageFile: ((File? value) {
                _medicineImage = value;
              }),
            ),
          ),
          const SizedBox(
            height: largeSpace + regularSpace,
          ),
          Text(
            '약 이름',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TextFormField(
            controller: _nameController,
            maxLength: 20,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              hintText: '복용할 약 이름을 입력하세요.',
              hintStyle: Theme.of(context).textTheme.bodyText2,
              contentPadding: textFieldContentPadding,
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ]),
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
        text: '다음',
      ),
    );
  }

  void _onAddAlarmPage() {
    Navigator.push(
        context,
        FadePageRoute(
            page: AddAlarmPage(
                medicineImage: _medicineImage,
                medicineName: _nameController.text)));
  }
}

class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({required this.changeImageFile});

  final ValueChanged<File?> changeImageFile;

  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 40,
        child: CupertinoButton(
          padding: _pickedImage == null ? null : EdgeInsets.zero,
          onPressed: _showBottomSheet,
          child: _pickedImage == null
              ? const Icon(
                  CupertinoIcons.photo_camera_solid,
                  size: 30,
                  color: Colors.white,
                )
              : CircleAvatar(
                  radius: 40,
                  foregroundImage: FileImage(_pickedImage!),
                ),
        ));
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
              onPressedCamera: () => _onPressed(ImageSource.camera),
              onPressedGallery: () => _onPressed(ImageSource.gallery));
        });
  }

  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
        });
      }
      Navigator.maybePop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}
