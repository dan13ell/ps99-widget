import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("slot1_type", store: UserDefaults(suiteName: "group.com.ps99.widget")) 
    var slot1Type: String = "clan"
    
    @AppStorage("slot1_name", store: UserDefaults(suiteName: "group.com.ps99.widget")) 
    var slot1Name: String = "INF"

    @AppStorage("slot2_type", store: UserDefaults(suiteName: "group.com.ps99.widget")) 
    var slot2Type: String = "league"
    
    @AppStorage("slot2_name", store: UserDefaults(suiteName: "group.com.ps99.widget")) 
    var slot2Name: String = "TOP1"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("WIDGET 1 (Nalevo / Nahoře)")) {
                    Picker("Typ", selection: $slot1Type) {
                        Text("Clan").tag("clan")
                        Text("League").tag("league")
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Název (např. INF)", text: $slot1Name)
                        .autocapitalization(.allCharacters)
                }

                Section(header: Text("WIDGET 2 (Napravo / Dole)")) {
                    Picker("Typ", selection: $slot2Type) {
                        Text("Clan").tag("clan")
                        Text("League").tag("league")
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Název (např. TOP1)", text: $slot2Name)
                        .autocapitalization(.allCharacters)
                }

                Button(action: {
                    WidgetCenter.shared.reloadAllTimelines()
                }) {
                    HStack {
                        Spacer()
                        Text("ULOŽIT A AKTUALIZOVAT WIDGETY")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .listRowBackground(Color.blue)
            }
            .navigationTitle("PS99 Widget Setup")
        }
    }
}

@main
struct PS99App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
