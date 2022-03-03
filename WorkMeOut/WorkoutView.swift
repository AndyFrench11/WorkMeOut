import SwiftUI



struct WorkoutView: View {
    
    var workout: Workout
    var workoutId: Int
    @State var isPresentingForm: Bool = false

    var body: some View {
        List {
            ForEach(workout.activities) { activity in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Weight: ")
                        Text("Reps: ")
                    }

                    VStack(alignment: .leading) {

                        Text("\(activity.weight)kg")
                            .fontWeight(.bold)
                        Text("\(activity.reps)")
                            .fontWeight(.bold)

                    }

                    Spacer()

                    VStack(alignment: .center) {
                        Text("Date")
                        Text("\(activity.date.ISO8601Format())")
                            .fontWeight(.bold)
                    }
                }
            }
            .onDelete { source in
                //store.schwifties.remove(atOffsets: source)
                // Get on delete working
                print(source)
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(workout.name) \(workout.icon)")
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
            CreateNewActivityView(workoutId: workoutId)
        }
    }
}
