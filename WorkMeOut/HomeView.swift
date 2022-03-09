import SwiftUI

struct HomeView: View {

    @EnvironmentObject var store: Store
    @State var isPresentingForm: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {



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

                                    Text("Last exercised: \(workout.getLastWorkoutDateString())")
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
                
                if store.workouts.isEmpty {
                    Text("You have not added any workouts yet. Add one via the 'plus' button above.")
                        .padding()
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

