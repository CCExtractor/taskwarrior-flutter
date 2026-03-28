package com.ccextractor.taskwarriorflutter

import android.annotation.TargetApi
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray as OrgJSONArray
import org.json.JSONException
import org.json.JSONObject

@TargetApi(Build.VERSION_CODES.CUPCAKE)
class TaskWarriorWidgetProvider : AppWidgetProvider() {

    fun getLayoutId(context: Context): Int {
        val sharedPrefs = HomeWidgetPlugin.getData(context)
        val theme = sharedPrefs.getString("themeMode", "")
        val layoutId =
                if (theme.equals("dark")) {
                    R.layout.taskwarrior_layout_dark // Define a dark mode layout in your resources
                } else {
                    R.layout.taskwarrior_layout
                }
        return layoutId
    }
    @TargetApi(Build.VERSION_CODES.DONUT)
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            // 1. Get the latest data from HomeWidget/SharedPrefs
            val sharedPrefs = HomeWidgetPlugin.getData(context)
            val tasks = sharedPrefs.getString("tasks", "")

            // 2. Create the Intent for the ListView service
            // We add the widgetId to the data URI to make it unique, preventing caching issues
            val intent =
                    Intent(context, ListViewRemoteViewsService::class.java).apply {
                        putExtra("tasksJsonString", tasks)
                        data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME) + widgetId)
                    }

            // 3. Initialize RemoteViews with the THEMED layout (getLayoutId handles dark/light
            // logic)
            val views =
                    RemoteViews(context.packageName, getLayoutId(context)).apply {

                        // Set up the Logo click (Open App)
                        val pendingIntent: PendingIntent =
                                HomeWidgetLaunchIntent.getActivity(
                                        context,
                                        MainActivity::class.java
                                )
                        setOnClickPendingIntent(R.id.logo, pendingIntent)

                        // Set up the Add Button click (Direct to MainActivity)
                        val intentForAdd =
                                Intent(context, MainActivity::class.java).apply {
                                    action = Intent.ACTION_VIEW
                                    data = Uri.parse("taskwarrior://addclicked")
                                    flags =
                                            Intent.FLAG_ACTIVITY_NEW_TASK or
                                                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                                                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                                }

                        val pendingIntentAdd: PendingIntent =
                                PendingIntent.getActivity(
                                        context,
                                        widgetId,
                                        intentForAdd,
                                        PendingIntent.FLAG_IMMUTABLE or
                                                PendingIntent.FLAG_UPDATE_CURRENT
                                )
                        setOnClickPendingIntent(R.id.add_btn, pendingIntentAdd)

                        // Attach the adapter to the ListView
                        setRemoteAdapter(R.id.list_view, intent)
                    }

            // 4. Set up the Click Template for List Items (Deep Linking)
            val clickIntentTemplate =
                    Intent(context, MainActivity::class.java).apply {
                        action = Intent.ACTION_VIEW
                        flags =
                                Intent.FLAG_ACTIVITY_NEW_TASK or
                                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                                        Intent.FLAG_ACTIVITY_SINGLE_TOP
                    }
            val clickPendingIntentTemplate: PendingIntent =
                    PendingIntent.getActivity(
                            context,
                            widgetId,
                            clickIntentTemplate,
                            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                    )
            views.setPendingIntentTemplate(R.id.list_view, clickPendingIntentTemplate)

            // 5. THE THEME FIX: Notify the manager that the list data/layout needs a refresh
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.list_view)

            // 6. Push the update to the widget
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

    override fun onCreate() = Unit

    override fun onDataSetChanged() {
        val newTasks = mutableListOf<Task>()
        val sharedPrefs = HomeWidgetPlugin.getData(context)
        val latestTasksJson = sharedPrefs.getString("tasks", "")

        if (!latestTasksJson.isNullOrEmpty()) {
            try {
                val jsonArray = OrgJSONArray(latestTasksJson)
                for (i in 0 until jsonArray.length()) {
                    newTasks.add(Task.fromJson(jsonArray.getJSONObject(i)))
                }
            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
        // Atomic swap
        tasks.clear()
        tasks.addAll(newTasks)
    }

    override fun onDestroy() = Unit

    override fun getCount(): Int = tasks.size

    fun getListItemLayoutId(): Int {
        val sharedPrefs = HomeWidgetPlugin.getData(context)
        val theme = sharedPrefs.getString("themeMode", "")
        val layoutId =
                if (theme.equals("dark")) {
                    R.layout.listitem_layout_dark // Define a dark mode layout in your resources
                } else {
                    R.layout.listitem_layout
                }
        return layoutId
    }
    fun getListItemLayoutIdForR1(): Int {
        val sharedPrefs = HomeWidgetPlugin.getData(context)
        val theme = sharedPrefs.getString("themeMode", "")
        val layoutId =
                if (theme.equals("dark")) {
                    R.layout.no_tasks_found_li_dark // Define a dark mode layout in your resources
                } else {
                    R.layout.no_tasks_found_li
                }
        return layoutId
    }
    fun getDotIdByPriority(p: String): Int {
        if (p.equals("L")) return R.drawable.low_priority_dot
        if (p.equals("M")) return R.drawable.mid_priority_dot
        if (p.equals("H")) return R.drawable.high_priority_dot
        return R.drawable.no_priority_dot
    }

    override fun getViewAt(position: Int): RemoteViews {
        // Safe guard against Android out-of-bounds scrolling crashes
        if (position !in tasks.indices) {
            return RemoteViews(context.packageName, getListItemLayoutIdForR1()).apply {
                setTextViewText(R.id.tv, "Loading...")
            }
        }
        
        val task = tasks[position]
        if (task.uuid.equals("NO_TASK"))
                return RemoteViews(context.packageName, getListItemLayoutIdForR1()).apply {
                    if (task.priority.equals("1")) setTextViewText(R.id.tv, "No tasks added yet")
                    if (task.priority.equals("2"))
                            setTextViewText(R.id.tv, "Filters applied are hiding all tasks")
                }
        return RemoteViews(context.packageName, getListItemLayoutId()).apply {
            setTextViewText(R.id.todo__title, task.title)
            setImageViewResource(R.id.dot, getDotIdByPriority(task.priority))
            val fillInIntent =
                    Intent().apply {
                        data = Uri.parse("taskwarrior://cardclicked?uuid=${task.uuid}")
                    }
            setOnClickFillInIntent(R.id.list_item_container, fillInIntent)
        }
    }
    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 2

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}

class ListViewRemoteViewsService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        val tasksJsonString = intent.getStringExtra("tasksJsonString")
        return ListViewRemoteViewsFactory(applicationContext, tasksJsonString)
    }
}

data class Task(
        val title: String,
        val urgencyLevel: String,
        val uuid: String,
        val priority: String
) {
    companion object {
        fun fromJson(json: JSONObject): Task {
            val title = json.optString("description", "")
            val urgencyLevel = json.optString("urgency", "")
            val uuid = json.optString("uuid", "")
            val priority = json.optString("priority", "")
            return Task(title, urgencyLevel, uuid, priority)
        }
    }
}
