import UIKit
import Flutter
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register our widget UserDefaults plugin
    let controller = window?.rootViewController as! FlutterViewController
    let widgetChannel = FlutterMethodChannel(
      name: "com.ccextractor.taskwarriorflutter/widget",
      binaryMessenger: controller.binaryMessenger)
    
    widgetChannel.setMethodCallHandler { (call, result) in
      if call.method == "saveToUserDefaults" {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String,
              let groupId = args["groupId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
            return
        }
        
        guard let sharedDefaults = UserDefaults(suiteName: groupId) else {
            result(FlutterError(code: "USERDEFAULTS_ERROR", message: "Could not access shared UserDefaults with groupId: \(groupId)", details: nil))
            return
        }
        
        let isData = args["isData"] as? Bool ?? false
        
        if isData, let value = args["value"] as? FlutterStandardTypedData {
            // Save binary data
            sharedDefaults.set(value.data, forKey: key)
            print("Successfully saved binary data for key: \(key) to group: \(groupId)")
        } else if let value = args["value"] as? String {
            // Save string value
            sharedDefaults.set(value, forKey: key)
            print("Successfully saved string for key: \(key) to group: \(groupId)")
        } else {
            result(FlutterError(code: "INVALID_VALUE", message: "Value must be either String or binary data", details: nil))
            return
        }
        
        // Force synchronize to ensure data is written immediately
        sharedDefaults.synchronize()
        result(true)
      } else if call.method == "updateWidget" {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            // Get the widget name to update
            let args = call.arguments as? [String: Any]
            let widgetName = args?["widgetName"] as? String
            
            // Request widget update
            if widgetName != nil {
              WidgetCenter.shared.reloadTimelines(ofKind: widgetName!)
              print("iOS widget timeline reloaded for: \(widgetName!)")
            } else {
              WidgetCenter.shared.reloadAllTimelines()
              print("iOS widget timelines reloaded")
            }
            result(true)
        } else {
            result(FlutterError(code: "VERSION_ERROR", message: "Widgets are only available on iOS 14.0 and above", details: nil))
        }
        #else
            result(FlutterError(code: "PLATFORM_ERROR", message: "Not available on this platform", details: nil))
        #endif
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
