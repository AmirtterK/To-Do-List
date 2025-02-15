import 'package:to_do_list/dialogs/NewTaskDialog.dart';
import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:to_do_list/pages/Theme.dart';
import 'package:to_do_list/services/database/AppData.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _didChangeAllarmPermission();
    }
  }

  Future<void> _didChangeAllarmPermission() async {
    var status = await Permission.notification.status;
    setState(() {
      if ((status.isDenied || status.isPermanentlyDenied) &&
          Device.settingsVisited) {
        MainData.isAllarmOn = false;
      } else if (!(status.isDenied || status.isPermanentlyDenied) &&
          Device.settingsVisited) {
        MainData.isAllarmOn = true;
      } else if ((status.isDenied || status.isPermanentlyDenied)) {
        MainData.isAllarmOn = false;
      }

      Device.settingsVisited = false;
    });
    await resetAllarm();

    await sqlDB.update(
        'MainData', {'isAllarmOn': toInt(MainData.isAllarmOn)}, 'id=?', [1]);
  }

  @override
  Widget build(BuildContext context) {
    return (Device.isThemePageDesktop && Device.desktopPlatform)
        ? ThemePage()
        : Scaffold(
            appBar: Device.desktopPlatform ? null : Appbar(title: "Settings"),
            body: Padding(
              padding: EdgeInsets.only(top: Device.pixelRatio * 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Device.pixelRatio * 5,
                        bottom: Device.pixelRatio * 3,
                        top: Device.pixelRatio * 3,
                      ),
                      child: Text(
                        "General",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async => {
                      if (await isAlarmAllowed())
                        {
                          setState(() {
                            MainData.isAllarmOn = !MainData.isAllarmOn;
                          })
                        }
                      else
                        {
                          if (context.mounted)
                            {
                              await allowAlarm(context),
                            }
                        },
                      await sqlDB.update(
                          'MainData',
                          {'isAllarmOn': toInt(MainData.isAllarmOn)},
                          'id=?',
                          [1]),
                      await resetAllarm()
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(left: Device.pixelRatio * 3),
                      child: Transform.scale(
                          scale: 1.137,
                          child: FaIcon(
                            FontAwesomeIcons.bell,
                            color: Theme.of(context).colorScheme.secondaryFixed,
                          )),
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                    trailing: Switch(
                      value: MainData.isAllarmOn,
                      onChanged: (value) async {
                        if (await isAlarmAllowed()) {
                          setState(() {
                            MainData.isAllarmOn = !MainData.isAllarmOn;
                          });
                        } else {
                          if (context.mounted) {
                            await allowAlarm(context);
                          }
                        }
                        await sqlDB.update(
                            'MainData',
                            {'isAllarmOn': toInt(MainData.isAllarmOn)},
                            'id=?',
                            [1]);
                        await resetAllarm();
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () async => {
                      setState(() {
                        MainData.isVibrationOn = !MainData.isVibrationOn;
                      }),
                      await sqlDB.update(
                          'MainData',
                          {'isVibrationOn': toInt(MainData.isVibrationOn)},
                          'id=?',
                          [1])
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(left: Device.pixelRatio * 3),
                      child: Transform.scale(
                          scale: 1.137,
                          child: Icon(
                            Icons.vibration_rounded,
                            color: Theme.of(context).colorScheme.secondaryFixed,
                          )),
                    ),
                    title: Text(
                      "Vibration",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                    trailing: Switch(
                      value: MainData.isVibrationOn,
                      onChanged: (value) async {
                        setState(() {
                          MainData.isVibrationOn = value;
                        });
                        await sqlDB.update(
                            'MainData',
                            {'isVibrationOn': toInt(MainData.isVibrationOn)},
                            'id=?',
                            [1]);
                      },
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 58, 58, 58)
                        : const Color.fromARGB(255, 211, 211, 211),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Device.pixelRatio * 5,
                          bottom: Device.pixelRatio * 3,
                          top: Device.pixelRatio * 3),
                      child: Text(
                        "Personalization",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => {
                      Device.desktopPlatform
                          ? setState(() {
                              Device.isThemePageDesktop = true;
                            })
                          : context.pushNamed("Theme"),
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: Device.pixelRatio * 3,
                      ),
                      child: Transform.scale(
                        scale: 1.137,
                        child: Icon(
                          Icons.palette_outlined,
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                    title: Text(
                      "Theme",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(left: Device.pixelRatio * 2),
                      child: Text(
                        MainData.selectedTheme,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 58, 58, 58)
                        : const Color.fromARGB(255, 211, 211, 211),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Device.pixelRatio * 5,
                          bottom: Device.pixelRatio * 3,
                          top: Device.pixelRatio * 3),
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await aboutAppDialog(context);
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: Device.pixelRatio * 3,
                      ),
                      child: Transform.scale(
                        scale: 1.137,
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                    title: Text(
                      "About",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => {},
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: Device.pixelRatio * 3,
                      ),
                      child: Transform.scale(
                        scale: 1.137,
                        child: Icon(
                          Icons.bolt,
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                    title: Text(
                      "Version",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(left: Device.pixelRatio * 2),
                      child: Text(
                        "1.0",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await ResetDialog(context);
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: Device.pixelRatio * 3,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.arrowRotateRight,
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                    ),
                    title: Text(
                      "Reset Data",
                      style: TextStyle(
                        fontSize: Device.pixelRatio * 6,
                        fontWeight: Device.menuFont,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Future<void> aboutAppDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 17, bottom: 10, left: 20, right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    MainData.about,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 0, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                      ),
                      onPressed: () => {
                        context.pop(),
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(fontSize: Device.pixelRatio * 5),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> ResetDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 300,
          maxWidth: 500,
          maxHeight: 800,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 17,
                bottom: 10,
                left: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Erase all data?",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, right: 5, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                    ),
                    onPressed: () => {
                      context.pop(),
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                    onPressed: () async => {
                      await ResetData(),
                      if (context.mounted) {context.pop()}
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
