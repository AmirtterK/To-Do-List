import 'package:flutter/material.dart';
import 'package:to_do_list/models/classes/customListClass.dart';
import 'package:to_do_list/models/classes/menuClass.dart';
import 'package:to_do_list/models/icons/customIcons.dart';
import 'package:to_do_list/pages/Archive.dart';
import 'package:to_do_list/pages/CustomePage.dart';
import 'package:to_do_list/pages/Pomodoro.dart';
import 'package:to_do_list/pages/Settings.dart';
import 'package:to_do_list/services/database/AppData.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(
      () {},
    );
  }

  int _currentPageIndex = 0;
  bool _trackPageChange = false;
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: NavigationRail(
                  key: Device.rail_key,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryFixed
                      .withValues(alpha: 0.05),
                  extended: _isExpanded,
                  leading: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    constraints: BoxConstraints(
                      maxWidth: 270,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: _isExpanded ? 12 : 0),
                          child: IconButton(
                            onPressed: () => {
                              setState(() {
                                if (!_isExpanded) {
                                  _isExpanded = !_isExpanded;
                                }
                              })
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.person,
                              size: 25,
                              color:
                                  Theme.of(context).colorScheme.secondaryFixed,
                            ),
                          ),
                        ),
                        _isExpanded ? Spacer() : SizedBox(),
                        _isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: IconButton(
                                  onPressed: () async {
                                    Customlist? newList =
                                        await displayNewListDialog(context);
                                    setState(
                                      () {
                                        if (newList != null) {
                                          sqlDB
                                              .createNewTable(newList.ListName);
                                          sqlDB.insert("customeList",
                                              {'title': newList.ListName});
                                          int index = MainData.MenuItems
                                              .indexWhere((item) =>
                                                  item.location == 'Archive');
                                          MainData.MenuItems.insert(
                                            index,
                                            MenuItem(
                                              Text(
                                                newList.ListName.replaceAll(
                                                        '_', ' ')
                                                    .replaceAll('dotmark', '.'),
                                                style: TextStyle(
                                                  fontSize:
                                                      Device.pixelRatio * 6,
                                                  fontWeight: Device.menuFont,
                                                ),
                                              ),
                                              Icon(CustomIcons.list, size: 28),
                                              newList.ListName,
                                            ),
                                          );
                                          MainData.customlist.add(newList);
                                        }
                                      },
                                    );
                                  },
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add_sharp,
                                    size: Device.pixelRatio * 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryFixed,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: IconButton(
                                  onPressed: () => setState(() {
                                    _isExpanded = !_isExpanded;
                                  }),
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: Device.pixelRatio * 8,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryFixed,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  destinations: List.generate(
                    MainData.MenuItems.length,
                    (index) => NavigationRailDestination(
                      icon: IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                        child: MainData.MenuItems[index].icon,
                      ),
                      label: Container(
                        alignment: Alignment.topLeft,
                        constraints: BoxConstraints(maxWidth: 200),
                        child: MainData.MenuItems[index].content,
                      ),
                    ),
                  ),
                  selectedIndex: _currentPageIndex >= MainData.MenuItems.length
                      ? 0
                      : _currentPageIndex,
                  onDestinationSelected: (value) => setState(
                    () {
                      if (value >= MainData.MenuItems.length) {
                        _currentPageIndex = value - 1;
                      } else {
                        _currentPageIndex = value;
                      }

                      _trackPageChange = !_trackPageChange;
                      if (Device.isThemePageDesktop ||
                          Device.isEditPomodoroDesktop) {
                        Device.isThemePageDesktop = false;
                        Device.isEditPomodoroDesktop = false;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            key: ObjectKey(_trackPageChange),
            child: Navigator(
              onGenerateRoute: (settings) {
                final String routeName =
                    '/${MainData.MenuItems[_currentPageIndex].location}';
                WidgetBuilder builder;
                switch (routeName) {
                  case '/Inbox':
                    MainData.selectedList = MainData.inbox_tasks_list;
                    builder = (context) => const Customepage('Inbox');
                    break;
                  case '/Today':
                    MainData.selectedList = MainData.Today_tasks_list;
                    builder = (context) => const Customepage('Today');
                    break;
                  case '/Pomodoro':
                    builder = (context) => const Pomodoro();
                    break;
                  case '/Archive':
                    builder = (context) => const Archive();
                    break;
                  case '/Settings':
                    builder = (context) => const Settings();
                    break;
                  default:
                    builder = (context) {
                      MainData.selectedList = MainData
                          .customlist[MainData.customlist.indexWhere((Clist) =>
                              Clist.ListName ==
                              MainData.MenuItems[_currentPageIndex].location)]
                          .list;
                      return Customepage(
                          MainData.MenuItems[_currentPageIndex].location);
                    };
                    break;
                }
                return MaterialPageRoute(
                  builder: builder,
                  settings: settings,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
