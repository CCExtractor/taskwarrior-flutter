import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet_new.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DeepLinkService extends GetxService {
  late AppLinks _appLinks;
  String? _queuedUri;
  String? get queuedUri => _queuedUri;
  StreamSubscription<Uri>? _linkSubscription;
  final QuickActions _quickActions = const QuickActions();

  Future<void> init() async {
    _appLinks = AppLinks();

    if (Platform.isAndroid || Platform.isIOS) {
      await _initQuickActions();
    }

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _queuedUri = initialUri.toString();
        debugPrint('🔗 INITIAL LINK QUEUED: $_queuedUri');
      }
    } catch (e) {
      debugPrint('Deep link init error: $e');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('🔗 LINK RECEIVED: $uri');
      _handleWidgetUri(uri);
    }, onError: (err) {
      debugPrint('🔗 LINK STREAM ERROR: $err');
    });
  }

  Future<void> _initQuickActions() async {
    await _quickActions.initialize((String shortcutType) {
      debugPrint("⚡ SHORTCUT RECEIVED: $shortcutType");
      if (shortcutType == 'shortcut_add_task') {
        _handleWidgetUri(Uri.parse('taskwarrior://shortcut_add'));
      } else if (shortcutType == 'shortcut_reports') {
        _handleWidgetUri(Uri.parse('taskwarrior://reports'));
      }
    });

    await _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'shortcut_add_task',
        localizedTitle: 'Add Task',
        icon: 'ic_shortcut_add', // We will provide these via Material HD assets
      ),
      const ShortcutItem(
        type: 'shortcut_reports',
        localizedTitle: 'Reports',
        icon:
            'ic_shortcut_reports', // We will provide these via Material HD assets
      ),
    ]);
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void _handleWidgetUri(Uri uri) {
    if (Get.isRegistered<HomeController>() && Get.context != null) {
      _executeAction(uri, Get.find<HomeController>());
    } else {
      debugPrint("⏳ HomeController or UI not ready. Queuing action.");
      _queuedUri = uri.toString();
    }
  }

  void consumePendingActions(HomeController controller) {
    if (_queuedUri != null) {
      debugPrint("🚀 Executing queued action...");
      try {
        _executeAction(Uri.parse(_queuedUri!), controller);
      } catch (e) {
        debugPrint("🔗 FAILED TO PARSE URI: $_queuedUri - Error: $e");
      }
      _queuedUri = null;
    }
  }

  void _executeAction(Uri uri, HomeController controller) {
    final bool isTaskChampion = controller.taskchampion.value;
    final bool isReplica = controller.taskReplica.value;

    if (uri.host == "cardclicked") {
      if (uri.queryParameters["uuid"] != null &&
          uri.queryParameters["uuid"] != "NO_TASK" &&
          !isTaskChampion &&
          !isReplica) {
        String uuid = uri.queryParameters["uuid"] as String;
        
        // Android Deep Links must cleanly present the new intent data.
        // Forcibly clear the previous task controller from GetX singleton memory
        // so that the new route triggers onInit() and loads the new task's UUID.
        if (Get.isRegistered<DetailRouteController>()) {
          Get.delete<DetailRouteController>(force: true);
        }

        // Pop all active pages, dialogs, and sheets until we hit the persistent Home route,
        // then push the new task route. This guarantees a clean hierarchy and a fresh UI rebuild.
        Get.offNamedUntil(
          Routes.DETAIL_ROUTE,
          (route) => route.settings.name == Routes.HOME,
          arguments: ["uuid", uuid],
        );
      }
    } else if (uri.host == "addclicked" || uri.host == "shortcut_add") {
      if (Get.context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // If the bottom sheet is already open, doing nothing prevents async stacking issues!
          // Get.back() animating at the exact same time as a new Get.bottomSheet() causes
          // Get.isBottomSheetOpen to desync inside GetX state management on the third instance.
          if (Get.isBottomSheetOpen ?? false) {
            return;
          }

          TaskwarriorColorTheme tColors =
              Theme.of(Get.context!).extension<TaskwarriorColorTheme>()!;

          Get.bottomSheet(
            AddTaskBottomSheet(
              homeController: controller,
              forTaskC: isTaskChampion,
              forReplica: isReplica,
            ),
            backgroundColor: tColors.dialogBackgroundColor,
            isScrollControlled: true,
            ignoreSafeArea: true, // TRUE allows MediaQuery.viewInsets (software keyboard) to reach inner Padding
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
          ).then((value) {
            if (controller.isSyncNeeded.value && value != "cancel") {
              controller.isNeededtoSyncOnStart(Get.context!);
            }
          });
        });
      }
    } else if (uri.host == "reports") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(Routes.REPORTS);
      });
    }
  }
}
