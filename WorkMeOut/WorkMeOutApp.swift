import SwiftUI

@main
struct WorkMeOutApp: App {
    @StateObject var store = Store()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .edgesIgnoringSafeArea([.top, .bottom])
                .environmentObject(store)
        }
    }
}
