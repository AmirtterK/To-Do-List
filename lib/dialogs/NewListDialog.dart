
import 'package:to_do_list/models/classes/customListClass.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewlistDialog extends StatefulWidget {
  const NewlistDialog({super.key});

  @override
  State<NewlistDialog> createState() => _NewlistDialogState();
}

class _NewlistDialogState extends State<NewlistDialog> {
  late TextEditingController _title_controller;
  String? title;

  @override
  void initState() {
    super.initState();
    _title_controller = TextEditingController();
  }

  @override
  void dispose() {
    _title_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 140),
      child: Container(
        constraints: BoxConstraints(
          minWidth: 300,
          minHeight: 100,
          maxWidth: 400,
          maxHeight: 800,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: Device.pixelRatio*1, top: Device.pixelRatio*1),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => {
                          context.pop(),
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: (value) => setState(
                  () {
                    title = value;
                  },
                ),
                controller: _title_controller,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 21,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 23,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 20, bottom: 3, top: 0, right: Device.pixelRatio * 7),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12, right: 12, top: 20),
                    child: SizedBox(
                      height: 25,
                      width: 60,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                        ),
                        onPressed: (title != null && title!.trim().isNotEmpty)
                            ? SaveList
                            : null,
                        child:  Text(
                          'Save',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SaveList() {
    context.pop(Customlist(_title_controller.text.replaceAll('\n', '').replaceAll(' ','_').replaceAll('.', 'dotmark'), []));
    MainData.saved = false;
  }
}
