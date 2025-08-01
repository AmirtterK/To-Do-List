import 'package:to_do_list/models/widgets/NavigationMenu.dart';
import 'package:to_do_list/pages/CustomePage.dart';
import 'package:to_do_list/pages/EditPomodoro.dart';
import 'package:to_do_list/pages/QuickActionAdd.dart';
import 'package:to_do_list/pages/Settings.dart';
import 'package:to_do_list/pages/Theme.dart';
import 'package:to_do_list/services/animations/HomeAnimations.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import 'package:to_do_list/services/notifications/notifications.dart';
import 'package:to_do_list/services/notifications/workmanager.dart';
import 'package:to_do_list/services/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io'; 

import 'package:to_do_list/pages/OnBoard.dart';
import 'package:to_do_list/pages/Archive.dart';
import 'package:to_do_list/pages/HomeMenu.dart';
import 'package:to_do_list/pages/Pomodoro.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    Device.desktopPlatform = true;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    Device.menuFont = FontWeight.w300;
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await fetchMainData(
    'MainData',
  );
  await fetchData('TodayTodos', MainData.Today_tasks_list);
  await fetchData('InboxTodos', MainData.inbox_tasks_list);
  await fetchData('ArchivedTodos', MainData.archived_tasks_list);
  await fetchLists();
  await fetchPomodoroData(
    'PomodoroData',
  );
  MainData.selectedList = MainData.inbox_tasks_list;
  await notificationsService.init();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        key: ValueKey(Device.changed),
        builder: (context) => MyApp(),
      ),
    ),
  );
}

Future<void> setAllarm() async {
  var status = await Permission.notification.status;
  if ((status.isDenied || status.isPermanentlyDenied)) {
    MainData.isAllarmOn = false;
  }
  await sqlDB.update(
      'MainData', {'isAllarmOn': toInt(MainData.isAllarmOn)}, 'id=?', [1]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeServices();
  }

  Future<void> initializeServices() async {
    if (!Device.desktopPlatform) {
      await WorkManagerService().init();
    }
    await setAllarm();
  }

  @override
  Widget build(BuildContext context) {
    Device.screenHeight = MediaQuery.of(context).size.height;
    Device.screenWidth = MediaQuery.of(context).size.width;
    Device.pixelRatio = MediaQuery.of(context).devicePixelRatio.floor();

    if (Device.desktopPlatform) {
      Device.screenWidth = 400;
      Device.pixelRatio *= 3;
      Device.pixelRatio = Device.pixelRatio.floor();
    }

    return MaterialApp.router(
      restorationScopeId: "app-release",
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

final _router = GoRouter(
  initialLocation: MainData.startOnBoard
      ? '/OnBoard'
      : Device.desktopPlatform
          ? '/NavigationMenu'
          : '/HomeMenu',
  routes: <RouteBase>[
    GoRoute(
      name: 'OnBoard',
      path: '/OnBoard',
      builder: (context, state) => const OnBoard(),
    ),
    GoRoute(
      name: 'HomeMenu',
      path: '/HomeMenu',
      builder: (context, state) => const HomeMenu(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const HomeMenu(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'NavigationMenu',
      path: '/NavigationMenu',
      builder: (context, state) => const NavigationMenu(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const NavigationMenu(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Inbox',
      path: '/Inbox',
      builder: (context, state) => const Customepage('Inbox'),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const Customepage('Inbox'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Today',
      path: '/Today',
      builder: (context, state) => const Customepage('Today'),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const Customepage('Today'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Pomodoro',
      path: '/Pomodoro',
      builder: (context, state) => const Pomodoro(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const Pomodoro(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Editpomodoro',
      path: '/Editpomodoro',
      builder: (context, state) => const Editpomodoro(),
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          key: state.pageKey,
          child: const Editpomodoro(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      name: 'Archive',
      path: '/Archive',
      builder: (context, state) => const Archive(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const Archive(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Theme',
      path: '/Theme',
      builder: (context, state) => const ThemePage(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const ThemePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Settings',
      path: '/Settings',
      builder: (context, state) => const Settings(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const Settings(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Custome',
      path: '/Custome',
      builder: (context, state) {
        String? pagetitle = state.uri.queryParameters['pagetitle'];
        return Customepage(pagetitle!);
      },
      pageBuilder: (context, state) {
        String? pagetitle = state.uri.queryParameters['pagetitle'];
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: Customepage(pagetitle!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'QuickActionsAdd',
      path: '/QuickActionsAdd',
      builder: (context, state) => const QuickActionsAdd(),
    ),
  ],
);
