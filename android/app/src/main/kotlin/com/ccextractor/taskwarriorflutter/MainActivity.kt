package com.ccextractor.taskwarriorflutter

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.IntentFilter
import android.appwidget.AppWidgetManager
import android.content.ComponentName

class MainActivity: FlutterActivity() {
    private val channel = "com.example.taskwarrior/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->
            if (call.method == "updateWidget") {
                updateWidget()
                result.success("Widget updated")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget() {
        val intent = Intent(this, WidgetUpdateReceiver::class.java).apply {
            action = "UPDATE_WIDGET"
        }
        sendBroadcast(intent)
    }
}