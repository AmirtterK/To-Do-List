import 'dart:ui';

import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/models/classes/themeClass.dart';
import 'package:to_do_list/services/theme/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class themeCard extends StatefulWidget {
  final themeDetails theme;
  final int index;
  final VoidCallback themeChanged;
  const themeCard(
      {required this.theme,
      super.key,
      required this.index,
      required this.themeChanged});
  @override
  State<themeCard> createState() => _themeCardState();
}

class _themeCardState extends State<themeCard> {
  get async => null;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(14),
        side: BorderSide(
          color: Colors.transparent,
        ),
      ),
      color: widget.theme.background,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async => {
          Provider.of<ThemeProvider>(context, listen: false)
              .toggleTheme(widget.theme.themeData),
          widget.themeChanged(),
          setState(
            () {
              MainData.selectedTheme = widget.theme.themename;
            },
          ),
          await Future.delayed(
            const Duration(milliseconds: 200),
            () {
              sqlDB.update('MainData',
                  {'selectedTheme': widget.theme.themename}, 'id=?', [1]);
            },
          )
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    height: 30,
                    width: 30,
                    child: Checkbox(
                      side: BorderSide(
                        color: Colors.grey.shade500.withValues(
                          alpha: 0.95,
                        ),
                        width: 2,
                      ),
                      fillColor: WidgetStateProperty.resolveWith(
                          (_) => Colors.transparent),
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 17),
                    width: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 5),
                          child: Container(
                            height: 8,
                            color: Colors.grey.shade400.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Text(
                      widget.theme.themename,
                      style: TextStyle(
                          color: widget.theme.ButtonBack,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Switch(
                      value: widget.theme.selected,
                      key: UniqueKey(),
                      onChanged: (value) async {
                        if (value != false) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(widget.theme.themeData);
                          widget.themeChanged();
                          setState(
                            () {
                              widget.theme.selected = value;
                              MainData.selectedTheme = widget.theme.themename;
                            },
                          );
                          await Future.delayed(
                            const Duration(milliseconds: 200),
                            () {
                              sqlDB.update(
                                  'MainData',
                                  {'selectedTheme': widget.theme.themename},
                                  'id=?',
                                  [1]);
                            },
                          );
                        }
                      },
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
}
