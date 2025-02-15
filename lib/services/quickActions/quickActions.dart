import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:to_do_list/services/database/AppData.dart';

class QuickActionsMenu {
  QuickActions quickActionss = const QuickActions();

  init(BuildContext context) async {
    if (!Device.desktopPlatform) {
      quickActionss.initialize(
        (String shortCut) {
          switch (shortCut) {
            case "addTask":
              context.replaceNamed('QuickActionsAdd');

              break;
            default:
          }
        },
      );
      quickActionss.setShortcutItems(
        <ShortcutItem>[
          const ShortcutItem(
            type: 'addTask',
            localizedTitle: 'Add task',
            icon: 'addtask',
          ),
        ],
      );
    }
  }
}
