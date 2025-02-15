import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:to_do_list/models/widgets/themeCard.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/theme/Themes.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int _selectedIndex = -1;
  _adjustThemeList(int index) {
    setState(
      () {
        _selectedIndex =
            availableThemes.indexWhere((theme) => theme.selected == true);
        if (_selectedIndex != -1) {
          availableThemes[_selectedIndex].selected = false;
        }
        availableThemes[index].selected = true;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Device.isThemePageDesktop = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Device.desktopPlatform ? null : Appbar(title: "Theme"),
      body: Column(
        children: [
          SizedBox(
            height: Device.pixelRatio * 4,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: availableThemes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: themeCard(
                      theme: availableThemes[index],
                      index: index,
                      themeChanged: () => _adjustThemeList(index),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
