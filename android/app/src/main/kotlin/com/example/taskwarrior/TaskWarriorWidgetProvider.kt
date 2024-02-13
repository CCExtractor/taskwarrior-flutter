package com.ccextractor.taskwarriorflutter
import android.util.Log
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
import org.json.JSONException
import android.content.Intent
import android.widget.RemoteViewsService
import org.json.JSONObject
import org.json.JSONArray as OrgJSONArray
import com.ccextractor.taskwarriorflutter.MainActivity
import com.ccextractor.taskwarriorflutter.R


class TaskWarriorWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.taskwarrior_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.container_layout, pendingIntent)
			
                // setOnClickPendingIntent(R.id.idTvTitle, backgroundIntent)

				val tasksJsonString = widgetData.getString("tasks", null)

				val intent = Intent(context,ListViewRemoteViewsService::class.java).apply {
					putExtra("tasksJsonString", tasksJsonString)
					data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
				}
				setRemoteAdapter(R.id.list_view, intent)
				val listViewPendingIntentTemplate = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("examplehomewidget://mainactivity"))

                setPendingIntentTemplate(R.id.list_view, listViewPendingIntentTemplate)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
		}
        }
    }
class ListViewRemoteViewsFactory(
    private val context: Context,
    private val tasksJsonString: String? 
) : RemoteViewsService.RemoteViewsFactory {

    private val tasks = mutableListOf<Task>()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        if (tasksJsonString != null) {
            try {
                val jsonArray = OrgJSONArray(tasksJsonString as String)
                for (i in 0 until jsonArray.length()) {
                    tasks.add(Task.fromJson(jsonArray.getJSONObject(i)))
                }
            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int = tasks.size

    override fun getViewAt(position: Int): RemoteViews {
        val task = tasks[position]

        val taskView = RemoteViews(context.packageName, R.layout.listitem_layout)
        taskView.setTextViewText(R.id.title_textview, task.title)
        taskView.setTextViewText(R.id.urgency_textview, task.urgencyLevel)

        return taskView
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
class ListViewRemoteViewsService : RemoteViewsService() {

	override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
		val tasksJsonString = intent.getStringExtra("tasksJsonString")
		return ListViewRemoteViewsFactory(applicationContext, tasksJsonString)
	}
}
data class Task(val title: String, val urgencyLevel: String) {
	companion object {
		fun fromJson(json: JSONObject): Task {
			val title = json.optString("description", "")
			val urgencyLevel = json.optString("urgency", "")
			return Task(title, urgencyLevel)
		}
	}
}