package com.example.taskwarrior

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

import com.example.taskwarrior.MainActivity
import com.example.taskwarrior.R


class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.cardItem, pendingIntent)

                // Swap Title Text by calling Dart Code in the Background
                setTextViewText(R.id.idTvTitle, widgetData.getString("title1", null)
                        ?: "No Data")
				setTextViewText(R.id.idTvDate, widgetData.getString("subtitle1", null)
                        ?: "No Data")
						setTextViewText(R.id.idTvTitle2, widgetData.getString("title2", null)
                        ?: "No Data")
				setTextViewText(R.id.idTvDate2, widgetData.getString("subtitle2", null)
                        ?: "No Data")
						setTextViewText(R.id.idTvTitle3, widgetData.getString("title3", null)
                        ?: "No Data")
				setTextViewText(R.id.idTvDate3, widgetData.getString("subtitle3", null)
                        ?: "No Data")
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetExample://titleClicked")
                )
                setOnClickPendingIntent(R.id.idTvTitle, backgroundIntent)

                // val message = widgetData.getString("message", null)
                // setTextViewText(R.id.widget_message, message
                //         ?: "No Message Set")
                // // Show Images saved with `renderFlutterWidget`
                // val image = widgetData.getString("dashIcon", null)
                // if (image != null) {
                //  setImageViewBitmap(R.id.widget_img, BitmapFactory.decodeFile(image))
                //  setViewVisibility(R.id.widget_img, View.VISIBLE)
                // } else {
                //     setViewVisibility(R.id.widget_img, View.GONE)
                // }

                // // Detect App opened via Click inside Flutter
                // val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                //         context,
                //         MainActivity::class.java,
                //         Uri.parse("homeWidgetExample://message?message=$message"))
                // setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}