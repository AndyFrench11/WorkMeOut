import SwiftUI

struct HomeView: View {

    @EnvironmentObject var store: Store
    @State var isPresentingForm: Bool = false

    func getLastWorkoutDate(_ workout: Workout) -> Text {
        if let lastWorkoutDate = workout.lastWorkOutDate {
            return Text(lastWorkoutDate, format: Date.FormatStyle().month().day())
        } else {
            return Text("Not exercised yet")
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(store.workouts) { workout in
                    NavigationLink(destination: WorkoutView(workout: workout, workoutId: store.workouts.firstIndex(of: workout)!)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(workout.name)
                                    .font(.body)
                                    .fontWeight(.bold)

                               GroupedVariantTagView(
                                    bodyPart: workout.bodyPart,
                                    focusType: workout.focusType,
                                    movementType: workout.movementType
                                )
                                
                                Text("Last exercised: \(getLastWorkoutDate(workout))")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete { offset in
                    store.removeWorkout(offset: offset)
                }
            }
            .navigationTitle("Workouts 💪")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    Button {
                        isPresentingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(
                isPresented: $isPresentingForm,
                onDismiss: { }
            ) {
                CreateNewWorkoutView()
            }
        }

    }
}

