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
import es.antonborri.home_widget.HomeWidgetPlugin
import android.content.BroadcastReceiver
import org.json.JSONException
import android.content.Intent
import android.widget.RemoteViewsService
import org.json.JSONObject
import org.json.JSONArray as OrgJSONArray
import com.ccextractor.taskwarriorflutter.MainActivity
import com.ccextractor.taskwarriorflutter.R
import android.os.Bundle
import android.app.PendingIntent
import android.appwidget.AppWidgetProvider


class TaskWarriorWidgetProvider : AppWidgetProvider() {
	
	override fun onReceive(context: Context, intent: Intent) {
		// val myaction = intent.action
		if (intent.action == "TASK_ACTION") {
				val extras = intent.extras
				if(extras!=null){
					val uuid = extras.getString("uuid")?:""
					val launchIntent = Intent(context, MainActivity::class.java).apply {
						action = context.getString(R.string.app_widget_launch_action)
						data = Uri.parse("${context.getString(R.string.app_widget_card_clicked_uri)}?uuid=$uuid")
						flags = Intent.	FLAG_ACTIVITY_NEW_TASK
                		context?.startActivity(this)
					}
					HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("TaskWarrior://taskView?taskId=$uuid"))
				}
		}
		super.onReceive(context, intent)
	}
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { widgetId ->
			val sharedPrefs = HomeWidgetPlugin.getData(context)
        	val tasks = sharedPrefs.getString("tasks", "")
				val intent = Intent(context,ListViewRemoteViewsService::class.java).apply {
					putExtra("tasksJsonString", tasks)
					data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
				}
            val views = RemoteViews(context.packageName, R.layout.taskwarrior_layout).apply {
            
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java)
				setOnClickPendingIntent(R.id.container_layout, pendingIntent)
				setRemoteAdapter(R.id.list_view, intent)
		
            }
			
				val clickPendingIntent: PendingIntent = Intent(
					context,
					TaskWarriorWidgetProvider::class.java).run {
						setAction("TASK_ACTION")
						setIdentifier("uuid")
					 data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
					 
					 PendingIntent.getBroadcast(context,0,this,PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT or Intent.FILL_IN_COMPONENT )
					}
					views.setPendingIntentTemplate(R.id.list_view,clickPendingIntent)
            appWidgetManager.updateAppWidget(widgetId, views)
		}
		super.onUpdate(context, appWidgetManager, appWidgetIds)
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
		return RemoteViews(context.packageName, R.layout.listitem_layout).apply {
        	setTextViewText(R.id.title_textview, task.title)
        	setTextViewText(R.id.urgency_textview, task.urgencyLevel)
			val a = Intent().apply {

				Bundle().also { extras ->
					extras.putString("uuid", "${tasks[position].uuid}")
					putExtras(extras)
				}
				
			}
			setOnClickFillInIntent(R.id.list_item_container,a)
			
		}
		
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
data class Task(val title: String, val urgencyLevel: String,val uuid:String) {
	companion object {
		fun fromJson(json: JSONObject): Task {
			val title = json.optString("description", "")
			val urgencyLevel = json.optString("urgency", "")
			val uuid = json.optString("uuid","")
			return Task(title, urgencyLevel,uuid)
		}
	}
}