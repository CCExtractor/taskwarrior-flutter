import WidgetKit
import SwiftUI
import os.log

// Timeline entry
struct TaskWidgetEntry: TimelineEntry {
    let date: Date
    let tasks: String
    let themeMode: String
    let configuration: ConfigurationAppIntent
}

// Task model
struct Task: Identifiable {
    let id = UUID()
    let description: String
    let urgency: String
    let uuid: String
    let priority: String
    
    var priorityColor: Color {
        switch priority {
        case "H": return .red
        case "M": return .orange
        case "L": return .green
        default: return .gray
        }
    }
}

struct TaskProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TaskWidgetEntry {
        TaskWidgetEntry(
            date: Date(),
            tasks: "[{\"description\":\"Sample Task\",\"urgency\":\"urgency: 5.8\",\"uuid\":\"123\",\"priority\":\"H\"}]",
            themeMode: "light",
            configuration: ConfigurationAppIntent()
        )
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TaskWidgetEntry {
        TaskWidgetEntry(
            date: Date(),
            tasks: "[{\"description\":\"Sample Task\",\"urgency\":\"urgency: 5.8\",\"uuid\":\"123\",\"priority\":\"H\"}]",
            themeMode: "light",
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TaskWidgetEntry> {
        var entries: [TaskWidgetEntry] = []
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        
        if let sharedDefaults = sharedDefaults {
            let allKeys = sharedDefaults.dictionaryRepresentation().keys
            os_log("TaskWidget - Available UserDefaults keys: %@", log: .default, type: .debug, allKeys.joined(separator: ", "))
        }
        
        let tasks = sharedDefaults?.string(forKey: "tasks") ?? "[]"
        let themeMode = sharedDefaults?.string(forKey: "themeMode") ?? "light"
        
        os_log("TaskWidget - Retrieved tasks: %d bytes", log: .default, type: .debug, tasks.count)
        os_log("TaskWidget - Theme: %@", log: .default, type: .debug, themeMode)
        
        let entry = TaskWidgetEntry(
            date: Date(),
            tasks: tasks,
            themeMode: themeMode,
            configuration: configuration
        )
        entries.append(entry)
        return Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 15 * 60)))
    }
}

struct TaskWidgetEntryView: View {
    var entry: TaskProvider.Entry
    @Environment(\.widgetFamily) var family

    // Parse tasks from JSON
    var parsedTasks: [Task] {
        guard let data = entry.tasks.data(using: .utf8) else { return [] }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                return jsonArray.compactMap { taskDict in
                    guard let description = taskDict["description"] as? String,
                          let urgency = taskDict["urgency"] as? String,
                          let uuid = taskDict["uuid"] as? String,
                          let priority = taskDict["priority"] as? String
                    else { return nil }
                    return Task(description: description, urgency: urgency, uuid: uuid, priority: priority)
                }
            }
        } catch {
            print("Error parsing task JSON: \(error)")
        }
        return []
    }
    
    // Sort tasks by priority: H > M > L > None
    var sortedTasks: [Task] {
        return parsedTasks.sorted { task1, task2 in
            let priorityOrder = ["H": 0, "M": 1, "L": 2, "N": 3]
            let priority1 = priorityOrder[task1.priority] ?? 3
            let priority2 = priorityOrder[task2.priority] ?? 3
            return priority1 < priority2
        }
    }
    
    var isDarkMode: Bool {
        entry.themeMode == "dark"
    }
    
    var body: some View {
        ZStack {
            (isDarkMode ? Color.black : Color(white: 0.95))
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 8) {
                headerView
                
                if parsedTasks.isEmpty {
                    emptyStateView
                } else {
                    switch family {
                    case .systemSmall:
                        smallTaskList
                    case .systemMedium:
                        mediumTaskList
                    case .systemLarge:
                        largeTaskList
                    default:
                        mediumTaskList
                    }
                }
            }
            .padding(family == .systemLarge ? 12 : 10)
        }
        .colorScheme(isDarkMode ? .dark : .light)
    }
    
    var headerView: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .imageScale(family == .systemSmall ? .small : .medium)
                Text("Taskwarrior")
                    .font(family == .systemSmall ? .caption.bold() : .headline)
            }
            Spacer()
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
                .imageScale(family == .systemSmall ? .medium : .large)
                .widgetURL(URL(string: "taskwarrior://addClicked"))
        }
        .padding(.bottom, 8)
    }
    
    var emptyStateView: some View {
        VStack(spacing: 4) {
            Image(systemName: "checkmark.circle")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("No tasks available")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Small widget list with deeplinks (shows 3 tasks)
    var smallTaskList: some View {
        VStack(spacing: 4) {
            ForEach(Array(sortedTasks.prefix(3))) { task in
                smallTaskRow(task: task)
                    .widgetURL(URL(string: "taskwarrior://cardClicked?uuid=\(task.uuid)"))
            }
            if sortedTasks.count > 3 {
                Text("+\(sortedTasks.count - 3) more")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    // Medium widget
    var mediumTaskList: some View {
        VStack(spacing: 4) {
            ForEach(Array(sortedTasks.prefix(3))) { task in
                mediumTaskRow(task: task)
                    .widgetURL(URL(string: "taskwarrior://cardClicked?uuid=\(task.uuid)"))
            }
            
            if sortedTasks.count > 3 {
                Text("+\(sortedTasks.count - 3) more tasks")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 2)
            }
        }
    }
    
    // Large widget
    var largeTaskList: some View {
        VStack(spacing: 6) {
            // Display only top 4 tasks by priority
            ForEach(Array(sortedTasks.prefix(4))) { task in
                largeTaskRow(task: task)
                    .widgetURL(URL(string: "taskwarrior://cardClicked?uuid=\(task.uuid)"))
            }
            
            if sortedTasks.count > 4 {
                Text("+\(sortedTasks.count - 4) more tasks")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
        }
    }
    
    func smallTaskRow(task: Task) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(task.priorityColor)
                .frame(width: 8, height: 8)
            Text(task.description)
                .font(.caption2)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    func mediumTaskRow(task: Task) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(task.priorityColor)
                .frame(width: 8, height: 8)
            Text(task.description)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    func largeTaskRow(task: Task) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(task.priorityColor)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading, spacing: 2) {
                Text(task.description)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(task.urgency)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .widgetURL(URL(string: "taskwarrior://cardClicked?uuid=\(task.uuid)"))
    }
}

struct TasksWidget: Widget {
    let kind: String = "TaskWarriorWidgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: TaskProvider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("Shows your pending tasks")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemLarge) {
    TasksWidget()
} timeline: {
    TaskWidgetEntry(
        date: .now,
        tasks: "[{\"description\":\"High priority task\",\"urgency\":\"urgency: 5.8\",\"uuid\":\"123\",\"priority\":\"H\"}, {\"description\":\"Medium task\",\"urgency\":\"urgency: 3.2\",\"uuid\":\"456\",\"priority\":\"M\"}, {\"description\":\"Low priority task\",\"urgency\":\"urgency: 1.5\",\"uuid\":\"789\",\"priority\":\"L\"}, {\"description\":\"Another high priority\",\"urgency\":\"urgency: 5.9\",\"uuid\":\"124\",\"priority\":\"H\"}, {\"description\":\"Second medium task\",\"urgency\":\"urgency: 3.1\",\"uuid\":\"457\",\"priority\":\"M\"}, {\"description\":\"No priority task\",\"urgency\":\"urgency: 1.0\",\"uuid\":\"790\",\"priority\":\"N\"}]",
        themeMode: "light",
        configuration: ConfigurationAppIntent()
    )
    TaskWidgetEntry(
        date: .now,
        tasks: "[{\"description\":\"Critical bug fix\",\"urgency\":\"urgency: 6.5\",\"uuid\":\"abc\",\"priority\":\"H\"}, {\"description\":\"Update docs\",\"urgency\":\"urgency: 2.8\",\"uuid\":\"def\",\"priority\":\"M\"}, {\"description\":\"Review PR\",\"urgency\":\"urgency: 4.5\",\"uuid\":\"ghi\",\"priority\":\"H\"}, {\"description\":\"Fix typos\",\"urgency\":\"urgency: 1.2\",\"uuid\":\"jkl\",\"priority\":\"L\"}, {\"description\":\"Add tests\",\"urgency\":\"urgency: 3.8\",\"uuid\":\"mno\",\"priority\":\"M\"}, {\"description\":\"Refactor code\",\"urgency\":\"urgency: 2.5\",\"uuid\":\"pqr\",\"priority\":\"N\"}]",
        themeMode: "dark",
        configuration: ConfigurationAppIntent()
    )
}
