import WidgetKit
import SwiftUI

struct ClanResponse: Codable {
    let status: String
    let data: ClanData?
}

struct ClanData: Codable {
    let Name: String
    let Points: Int64
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let points: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "C:INF", points: "1.25B")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), title: "C:INF", points: "1.25B"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.com.ps99.widget")
        
        // Načte nastavení, které jsi vyklikal v aplikaci
        let type = defaults?.string(forKey: "slot1_type") ?? "clan"
        let name = defaults?.string(forKey: "slot1_name") ?? "INF"

        let endpoint = (type == "league") ? "leagues" : "clan"
        let urlString = "https://rough-pine-d90f.ps99clans.workers.dev/v1/\(endpoint)/\(name)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            var pointsString = "N/A"
            
            if let data = data,
               let decoded = try? JSONDecoder().decode(ClanResponse.self, from: data),
               let clanData = decoded.data {
                
                let points = Double(clanData.Points)
                if points >= 1_000_000_000 {
                    pointsString = String(format: "%.2fB", points / 1_000_000_000)
                } else if points >= 1_000_000 {
                    pointsString = String(format: "%.1fM", points / 1_000_000)
                } else {
                    pointsString = "\(clanData.Points)"
                }
            }

            let tag = (type == "league") ? "L" : "C"
            let entry = SimpleEntry(date: Date(), title: "[\(tag)] \(name.uppercased())", points: pointsString)
            
            // Bude aktualizovat body každých 15 minut
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(15 * 60)))
            completion(timeline)
        }.resume()
    }
}

struct PS99WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.caption)
                .bold()
            Text("✨ \(entry.points)")
                .font(.headline)
        }
    }
}

@main
struct PS99Widget: Widget {
    let kind: String = "PS99Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PS99WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("PS99 Tracker")
        .description("Zobrazuje živé body z PS99.")
        .supportedFamilies([.accessoryRectangular])
    }
}
