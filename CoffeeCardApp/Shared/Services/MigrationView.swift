import SwiftUI

struct MigrationView: View {
    @State private var isRunning = false
    @State private var log: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Button(isRunning ? "Migrating..." : "Run menu migration") {
                Task {
                    isRunning = true
                    do {
                        try await MenuMigrationService().migrateMenuItems()
                        log = "Done ✅"
                    } catch {
                        log = "Error: \(error.localizedDescription)"
                    }
                    isRunning = false
                }
            }
            .disabled(isRunning)
            
            Text(log)
                .font(.footnote)
        }
        .padding()
    }
}
