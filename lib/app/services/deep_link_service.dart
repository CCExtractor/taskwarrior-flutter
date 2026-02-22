import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet_new.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';

class DeepLinkService extends GetxService {
  late AppLinks _appLinks;
  Uri? _queuedUri;

  @override
  void onReady() {
    super.onReady();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('🔗 LINK RECEIVED: $uri');
      _handleWidgetUri(uri);
    });

    _loadInitialLink();
  }

  Future<void> _loadInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('🔗 INITIAL LINK: $initialUri');
        _handleWidgetUri(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }
  }

  void _handleWidgetUri(Uri uri) {
    if (Get.isRegistered<HomeController>()) {
      _executeAction(uri, Get.find<HomeController>());
    } else {
      debugPrint("⏳ HomeController not ready. Queuing action.");
      _queuedUri = uri;
    }
  }

  void consumePendingActions(HomeController controller) {
    if (_queuedUri != null) {
      debugPrint("🚀 Executing queued action...");
      _executeAction(_queuedUri!, controller);
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
        Get.toNamed(Routes.DETAIL_ROUTE, arguments: ["uuid", uuid]);
      }
    } else if (uri.host == "addclicked") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context == null) return;
        Get.dialog(
          Material(
            child: AddTaskBottomSheet(
              homeController: controller,
              forTaskC: isTaskChampion,
              forReplica: isReplica,
            ),
          ),
        );
      });
    }
  }
}
