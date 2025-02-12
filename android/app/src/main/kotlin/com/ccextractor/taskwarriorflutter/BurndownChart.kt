package com.ccextractor.taskwarriorflutter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetProvider

class BurndownChartProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        // This method is intentionally left blank.
        // Widget updates are handled by WidgetUpdateReceiver.
    }
}