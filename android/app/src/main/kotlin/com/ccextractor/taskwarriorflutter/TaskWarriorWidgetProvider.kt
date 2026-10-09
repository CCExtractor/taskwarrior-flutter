package com.ccextractor.taskwarriorflutter

import android.annotation.TargetApi
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.BroadcastReceiver
import android.content.ComponentName
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

/**
 * Home-screen widget storage keys and the fixed set of status tabs the widget
 * can show. These mirror `Query.status*` on the Flutter side
 * (lib/app/utils/taskfunctions/query.dart).
 */
const val WIDGET_STATUS_PENDING = "pending"
const val WIDGET_STATUS_COMPLETED = "completed"
const val WIDGET_STATUS_DELETED = "deleted"
const val WIDGET_STATUS_RECURRING = "recurring"

val WIDGET_STATUSES =
        listOf(
                WIDGET_STATUS_PENDING,
                WIDGET_STATUS_COMPLETED,
                WIDGET_STATUS_DELETED,
                WIDGET_STATUS_RECURRING
        )

const val WIDGET_STATUS_PREFS_KEY = "widgetStatus"
const val WIDGET_STATUS_ACTION = "com.ccextractor.taskwarriorflutter.action.SET_WIDGET_STATUS"
const val WIDGET_STATUS_EXTRA = "widget_status"

/** Tab view ids keyed by status, in display order. */
private val WIDGET_TAB_IDS =
        linkedMapOf(
                WIDGET_STATUS_PENDING to R.id.tab_pending,
                WIDGET_STATUS_COMPLETED to R.id.tab_completed,
                WIDGET_STATUS_DELETED to R.id.tab_deleted,
                WIDGET_STATUS_RECURRING to R.id.tab_recurring
        )

/** The status the widget is currently filtered to, defaulting to pending. */
fun getWidgetStatus(context: Context): String {
    val saved = HomeWidgetPlugin.getData(context).getString(WIDGET_STATUS_PREFS_KEY, null)
    return if (saved != null && WIDGET_STATUSES.contains(saved)) saved else WIDGET_STATUS_PENDING
}

/** Empty-state message for a status tab, e.g. "No deleted tasks". */
fun widgetEmptyMessage(context: Context, status: String): String =
        context.getString(
                when (status) {
                    WIDGET_STATUS_COMPLETED -> R.string.empty_completed
                    WIDGET_STATUS_DELETED -> R.string.empty_deleted
                    WIDGET_STATUS_RECURRING -> R.string.empty_recurring
                    else -> R.string.empty_pending
                }
        )

/**
 * Builds and pushes the RemoteViews for a single widget instance, wiring the
 * logo/add/list and the status tabs. Shared by [TaskWarriorWidgetProvider]
 * (periodic refresh / widget added) and [WidgetStatusReceiver] (tab tapped
 * while the app is closed).
 */
fun updateTaskWarriorWidget(context: Context, appWidgetManager: AppWidgetManager, widgetId: Int) {
    val sharedPrefs = HomeWidgetPlugin.getData(context)
    val isDark = sharedPrefs.getString("themeMode", "") == "dark"
    val layoutId = if (isDark) R.layout.taskwarrior_layout_dark else R.layout.taskwarrior_layout

    // Include the widgetId in the data URI so each widget gets its own adapter
    // and the OS does not reuse a stale RemoteViewsFactory.
    //
    // Do NOT put the task JSON in this Intent: the factory reads it from
    // shared prefs in onDataSetChanged(). Parcelling the full list here blows
    // past the ~1 MB Binder limit (TransactionTooLargeException) once the
    // payload carries every status, which silently breaks every widget update.
    val adapterIntent =
            Intent(context, ListViewRemoteViewsService::class.java).apply {
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME) + widgetId)
            }

    val views =
            RemoteViews(context.packageName, layoutId).apply {
                // Logo click opens the app.
                val pendingIntent: PendingIntent =
                        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.logo, pendingIntent)

                // Add button jumps straight to the add-task flow.
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
                                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                        )
                setOnClickPendingIntent(R.id.add_btn, pendingIntentAdd)

                setRemoteAdapter(R.id.list_view, adapterIntent)

                // Status tabs: highlight the active one and route each tap to
                // the receiver, which persists the choice and re-renders.
                val selected = getWidgetStatus(context)
                val unselectedBg = R.drawable.widget_tab_unselected
                val selectedBg =
                        if (isDark) R.drawable.widget_tab_selected_dark
                        else R.drawable.widget_tab_selected
                val unselectedColor = context.getColor(if (isDark) R.color.fg_dark else R.color.fg)
                val selectedColor = context.getColor(R.color.widget_tab_selected_fg)
                for ((status, viewId) in WIDGET_TAB_IDS) {
                    val isSelected = status == selected
                    setInt(
                            viewId,
                            "setBackgroundResource",
                            if (isSelected) selectedBg else unselectedBg
                    )
                    setTextColor(viewId, if (isSelected) selectedColor else unselectedColor)
                    setOnClickPendingIntent(
                            viewId,
                            widgetStatusPendingIntent(context, widgetId, status)
                    )
                }
            }

    // Click template so tapping a task row deep-links into the app.
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

    // Notify first so the factory re-reads the (possibly new) status, then push
    // the tab highlight.
    appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.list_view)
    appWidgetManager.updateAppWidget(widgetId, views)
}

private fun widgetStatusPendingIntent(context: Context, widgetId: Int, status: String): PendingIntent {
    val intent =
            Intent(context, WidgetStatusReceiver::class.java).apply {
                action = WIDGET_STATUS_ACTION
                putExtra(WIDGET_STATUS_EXTRA, status)
                // Unique data per tab+widget so the PendingIntents do not collide.
                data = Uri.parse("taskwarriorwidget://status/$status/$widgetId")
            }
    return PendingIntent.getBroadcast(
            context,
            widgetId * 10 + WIDGET_STATUSES.indexOf(status),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
    )
}

/**
 * Handles taps on the widget's status tabs. Widgets cannot run Flutter, so this
 * persists the selected status natively and repaints every widget instance.
 */
class WidgetStatusReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val status = intent.getStringExtra(WIDGET_STATUS_EXTRA) ?: return
        if (!WIDGET_STATUSES.contains(status)) return

        HomeWidgetPlugin.getData(context)
                .edit()
                .putString(WIDGET_STATUS_PREFS_KEY, status)
                .apply()

        val manager = AppWidgetManager.getInstance(context)
        val ids =
                manager.getAppWidgetIds(
                        ComponentName(context, TaskWarriorWidgetProvider::class.java)
                )
        ids.forEach { widgetId -> updateTaskWarriorWidget(context, manager, widgetId) }
    }
}

@TargetApi(Build.VERSION_CODES.CUPCAKE)
class TaskWarriorWidgetProvider : AppWidgetProvider() {
    @TargetApi(Build.VERSION_CODES.DONUT)
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            updateTaskWarriorWidget(context, appWidgetManager, widgetId)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}

class ListViewRemoteViewsFactory(private val context: Context) :
        RemoteViewsService.RemoteViewsFactory {

    private val tasks = mutableListOf<Task>()

    override fun onCreate() = Unit

    override fun onDataSetChanged() {
        val sharedPrefs = HomeWidgetPlugin.getData(context)
        val latestTasksJson = sharedPrefs.getString("tasks", "")
        val status = getWidgetStatus(context)

        val newTasks = mutableListOf<Task>()
        if (!latestTasksJson.isNullOrEmpty()) {
            try {
                val jsonArray = OrgJSONArray(latestTasksJson)
                for (i in 0 until jsonArray.length()) {
                    val task = Task.fromJson(jsonArray.getJSONObject(i))
                    // The payload carries every status; show only the tab's.
                    if (task.uuid == "NO_TASK") continue
                    if (task.status == status) newTasks.add(task)
                }
            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
        // Atomic swap
        tasks.clear()
        tasks.addAll(newTasks)
        if (tasks.isEmpty()) {
            tasks.add(
                    Task(
                            title = widgetEmptyMessage(context, status),
                            urgencyLevel = "urgencyLevel : 0",
                            uuid = "NO_TASK",
                            priority = "1",
                            status = status
                    )
            )
        }
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
                    setTextViewText(R.id.tv, task.title)
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
        return ListViewRemoteViewsFactory(applicationContext)
    }
}

data class Task(
        val title: String,
        val urgencyLevel: String,
        val uuid: String,
        val priority: String,
        val status: String
) {
    companion object {
        fun fromJson(json: JSONObject): Task {
            val title = json.optString("description", "")
            val urgencyLevel = json.optString("urgency", "")
            val uuid = json.optString("uuid", "")
            val priority = json.optString("priority", "")
            val status = json.optString("status", WIDGET_STATUS_PENDING)
            return Task(title, urgencyLevel, uuid, priority, status)
        }
    }
}
