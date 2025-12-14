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
    
    // 1. DATA PARSING
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
    
    // 2. MAIN BODY LAYOUT
    var body: some View {
        ZStack {
            // Background Layer
            (isDarkMode ? Color.black : Color(white: 0.95))
                .ignoresSafeArea()
            
            // Content Layer
            VStack(spacing: 0) {
                
                // --- TOP BAR (Pinned) ---
                headerView
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8) // Slightly tighter to fit content
                
                // --- LIST AREA ---
                if parsedTasks.isEmpty {
                    emptyStateView
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        switch family {
                        case .systemMedium:
                            mediumTaskList
                        case .systemLarge:
                            largeTaskList
                        default:
                            mediumTaskList
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                // --- BOTTOM SPACER ---
                Spacer()
            }
        }
        .colorScheme(isDarkMode ? .dark : .light)
    }
    
    // 3. SUBVIEWS
    
    var headerView: some View {
        HStack {
            HStack(spacing: 6) {
                Image("taskwarrior")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                

            }
            Spacer()
            Text("Taskwarrior")
                .font(.headline)
            Spacer()
            
            // Add Button
            Link(destination: URL(string: "taskwarrior://addclicked")!) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 26))
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.largeTitle)
                .foregroundColor(.secondary.opacity(0.5))
            Text("No tasks pending")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    // -- List Variations --
    
    // MEDIUM: With urgency text removed, we can fit 3 items comfortably
    var mediumTaskList: some View {
        VStack(spacing: 4) { // Compact spacing
            ForEach(Array(sortedTasks.prefix(2))) { task in
                taskRow(task: task)
                    .widgetURL(URL(string: "taskwarrior://cardclicked?uuid=\(task.uuid)"))
            }
            
            if sortedTasks.count > 2 {
                Text("+\(sortedTasks.count - 2) more")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 4)
            }
        }
    }
    
    // LARGE: With urgency text removed, we can fit 6 items
    var largeTaskList: some View {
        VStack(spacing: 7) {
            ForEach(Array(sortedTasks.prefix(6))) { task in
                taskRow(task: task)
                    .widgetURL(URL(string: "taskwarrior://cardclicked?uuid=\(task.uuid)"))
            }
            
            if sortedTasks.count > 6 {
                Text("+\(sortedTasks.count - 6) more tasks")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 2)
            }
        }
    }
    
    // -- Row Designs --
    
    // Unified Row Design (Clean, Single Line)
    func taskRow(task: Task) -> some View {
        HStack(spacing: 10) {
            // Colored Bar
            Capsule()
                .fill(task.priorityColor)
                .frame(width: 10, height: 10) // Smaller height since text is single line
            
            // Description (Single line, centered vertically)
            Text(task.description)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(.primary)
            
            Spacer()
        }
        // Compact Padding to fit more items
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .fixedSize(horizontal: false, vertical: true)
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
        .supportedFamilies([.systemMedium, .systemLarge])
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
}
