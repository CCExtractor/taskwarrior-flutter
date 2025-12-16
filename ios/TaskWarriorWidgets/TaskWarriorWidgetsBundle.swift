import WidgetKit
import SwiftUI


// App group identifier for shared UserDefaults
let appGroupIdentifier = "group.taskwarrior"

@main
struct TaskWarriorWidgetsBundle: WidgetBundle {
    var body: some Widget {
        TasksWidget()
    }
}