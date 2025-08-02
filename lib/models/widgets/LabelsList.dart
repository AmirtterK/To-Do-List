import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Labelslist extends StatefulWidget {
  final VoidCallback updateUI;
  const Labelslist({super.key, required this.updateUI});

  @override
  State<Labelslist> createState() => _LabelslistState();
}

class _LabelslistState extends State<Labelslist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          MainData.labels.length,
          (index) => InkWell(
                onTap: () {
                  setState(() {
                    MainData.labelChanged = true;
                    MainData.flag = MainData.labels[index];
                  });
                  widget.updateUI();
                  context.pop();
                },
                child: Container(
                  width: (Device.screenWidth / 5.5).round() * 1,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    MainData.labels[index],
                    style: TextStyle(fontWeight: Device.menuFont),
                  ),
                ),
              )),
    );
  }
}
