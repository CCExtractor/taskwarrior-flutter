import WidgetKit
import SwiftUI
import os.log

struct ChartWidgetEntry: TimelineEntry {
    let date: Date
    let themeMode: String
    let chart_image: String
    let configuration: ConfigurationAppIntent
}

struct ChartProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ChartWidgetEntry {
        ChartWidgetEntry(
            date: Date(), 
            themeMode: "light", 
            chart_image: "default_chart", 
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ChartWidgetEntry {
        ChartWidgetEntry(
            date: Date(), 
            themeMode: "light", 
            chart_image: "default_chart", 
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ChartWidgetEntry> {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        
        let themeMode = sharedDefaults?.string(forKey: "themeMode") ?? "light"
        let chartImage = sharedDefaults?.string(forKey: "chart_image") ?? "default_chart"
        
        os_log("ChartWidget - Theme Mode: %@", log: .default, type: .debug, themeMode)
        os_log("ChartWidget - Chart Image Path: %@", log: .default, type: .debug, chartImage)
        
        let entry = ChartWidgetEntry(
            date: Date(),
            themeMode: themeMode,
            chart_image: chartImage,
            configuration: configuration
        )

        // Refresh every 30 minutes
        return Timeline(entries: [entry], policy: .after(Date(timeIntervalSinceNow: 30 * 60)))
    }
}

struct ChartWidgetEntryView: View {
    var entry: ChartProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var isDarkMode: Bool {
        return entry.themeMode == "dark"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                (isDarkMode ? Color.black : Color(white: 0.95))
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    header
                    
                    if family == .systemSmall {
                        smallChartContent
                    } else {
                        chartContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(family == .systemSmall ? 8 : 10)
            }
            .colorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    var header: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(.blue)
                    .imageScale(family == .systemSmall ? .small : .medium)
                
                Text("Task Burndown")
                    .font(family == .systemSmall ? .caption.bold() : .headline)
                    .foregroundColor(isDarkMode ? .white : .black)
            }
            
            Spacer()
        }
        .padding(.bottom, family == .systemSmall ? 4 : 8)
    }
    
    var chartContent: some View {
        Group {
            if let uiImage = loadImageFromPath(entry.chart_image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isDarkMode ? Color(white: 0.15) : .white)
                    )
                    .cornerRadius(8)
                    .padding(4)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 40))
                        .foregroundColor(isDarkMode ? Color(white: 0.3) : Color(white: 0.7))
                        
                    Text("No chart data available")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? .gray : .secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    var smallChartContent: some View {
        Group {
            if let uiImage = loadImageFromPath(entry.chart_image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isDarkMode ? Color(white: 0.15) : .white)
                    )
                    .cornerRadius(6)
                    .padding(2)
            } else {
                VStack(spacing: 4) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 20))
                        .foregroundColor(isDarkMode ? Color(white: 0.3) : Color(white: 0.7))
                    
                    Text("No chart")
                        .font(.caption2)
                        .foregroundColor(isDarkMode ? .gray : .secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .widgetURL(URL(string: "taskwarrior://openChartView"))
    }
    
    func loadImageFromPath(_ path: String) -> UIImage? {
        // First try to load from shared UserDefaults
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        if let imageData = sharedDefaults?.data(forKey: "widget_image_data") {
            os_log("ChartWidget - Loading image from UserDefaults", type: .debug)
            return UIImage(data: imageData)
        }
        
        // Then try to load from file path
        if FileManager.default.fileExists(atPath: path) {
            os_log("ChartWidget - Loading image from file: %@", type: .debug, path)
            return UIImage(contentsOfFile: path)
        }
        
        os_log("ChartWidget - No image found", type: .debug)
        return nil
    }
}

struct ChartWidget: Widget {
    let kind: String = "ChartWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ChartProvider()) { entry in
            ChartWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Burndown Chart")
        .description("Shows your task burndown chart")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    ChartWidget()
} timeline: {
    ChartWidgetEntry(date: .now, themeMode: "light", chart_image: "default_chart", configuration: ConfigurationAppIntent())
    ChartWidgetEntry(date: .now, themeMode: "dark", chart_image: "default_chart", configuration: ConfigurationAppIntent())
}

#Preview(as: .systemMedium) {
    ChartWidget()
} timeline: {
    ChartWidgetEntry(date: .now, themeMode: "light", chart_image: "default_chart", configuration: ConfigurationAppIntent())
    ChartWidgetEntry(date: .now, themeMode: "dark", chart_image: "default_chart", configuration: ConfigurationAppIntent())
}