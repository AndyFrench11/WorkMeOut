import SwiftUI

struct HomeView: View {

    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< store.workouts.count) { id in
                    NavigationLink(destination: WorkoutView(workout: store.workouts[id], workoutId: id)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(store.workouts[id].name)
                                    .font(.body)
                                    .fontWeight(.bold)
                                Text("Last exercised: \(store.workouts[id].lastWorkOutDate)")
                                    .font(.subheadline)
                            }

                            Spacer()

                            Text(store.workouts[id].icon)
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Workouts 💪")
            .navigationBarTitleDisplayMode(.large)
        }

    }
}

