package com.ccextractor.taskwarriorflutter

import android.appwidget.AppWidgetManager
import android.view.View
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.util.Log
import android.widget.RemoteViews
import java.io.File
import com.ccextractor.taskwarriorflutter.R
import es.antonborri.home_widget.HomeWidgetPlugin

class WidgetUpdateReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "UPDATE_WIDGET") {
            Log.d("WidgetUpdateReceiver", "Received UPDATE_WIDGET broadcast")

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, BurndownChartProvider::class.java))

            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
		Log.d("WidgetUpdateReceiver", "Updating widget $appWidgetId")
	
		val views = RemoteViews(context.packageName, R.layout.report_layout)
	
		// Retrieve the chart image path from HomeWidget
		val chartImage = HomeWidgetPlugin.getData(context).getString("chart_image", null)
	
		if (chartImage != null) {
			Log.d("WidgetUpdateReceiver", "Chart image path: $chartImage")
			val file = File(chartImage)
			if (file.exists()) {
				Log.d("WidgetUpdateReceiver", "File exists!")
				val b = BitmapFactory.decodeFile(file.absolutePath)
				if (b != null) {
					Log.d("WidgetUpdateReceiver", "Bitmap decoded successfully!")
					views.setImageViewBitmap(R.id.widget_image, b)
					views.setViewVisibility(R.id.widget_image, View.VISIBLE)
					views.setViewVisibility(R.id.no_image_text, View.GONE)
				} else {
					Log.e("WidgetUpdateReceiver", "Bitmap decoding failed!")
					views.setViewVisibility(R.id.widget_image, View.GONE)
					views.setViewVisibility(R.id.no_image_text, View.VISIBLE)
				}
			} else {
				Log.e("WidgetUpdateReceiver", "File does not exist: $chartImage")
				views.setViewVisibility(R.id.widget_image, View.GONE)
				views.setViewVisibility(R.id.no_image_text, View.VISIBLE)
			}
		} else {
			Log.d("WidgetUpdateReceiver", "No chart image saved yet")
			views.setViewVisibility(R.id.widget_image, View.GONE)
			views.setViewVisibility(R.id.no_image_text, View.VISIBLE)
		}
	
		appWidgetManager.updateAppWidget(appWidgetId, views)
	}
}