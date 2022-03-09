import SwiftUI

@main
struct WorkMeOutApp: App {
    @StateObject var store = Store()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .edgesIgnoringSafeArea([.top, .bottom])
                .environmentObject(store)
                .onAppear {
                    Store.load { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let workouts):
                            store.workouts = workouts
                        }
                    }
                }
        }
    }
}
