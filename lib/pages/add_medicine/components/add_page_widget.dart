import 'package:drug_alarm/components/drug_constants.dart';
import 'package:flutter/material.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() {
          FocusScope.of(context).unfocus();
        }),
        child: Padding(
            padding: pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )));
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton(
      {super.key, required this.onPressed, required this.text});

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: submitButtonBoxPadding,
            child: SizedBox(
              height: submitButtonHeight,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1),
                child: Text(text),
              ),
            )));
  }
}
