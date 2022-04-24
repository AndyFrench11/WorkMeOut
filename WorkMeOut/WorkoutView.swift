import SwiftUI
import SwiftUICharts

struct WorkoutView: View {
    
    var workout: Workout
    var workoutId: Int
    @State var isPresentingForm: Bool = false
    @EnvironmentObject var store: Store

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            GroupedVariantTagView(
                focusType: workout.focusType,
                movementType: workout.movementType
            )
                .padding(.leading, 16)

            if !workout.activities.isEmpty {
                LineView(
                    data: workout.getAverageWeight(),
                    legend: "Last exercised: \(workout.getLastWorkoutDateString())"
                )
                    .padding(.horizontal, 16)
            }

            List {
                if workout.activities.isEmpty {
                    Text("There have been no activites yet.")
                }

                ForEach(workout.sortedActivitiesByDate) { activity in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Avg. weight: ")
                            Text("Avg. reps: ")
                        }

                        VStack(alignment: .leading) {
                            Text("\(activity.getAverageWeight(), specifier: "%.2f")kg")
                                .fontWeight(.bold)
                            Text("\(activity.getAverageReps(), specifier: "%.2f")")
                                .fontWeight(.bold)

                        }

                        Spacer()

                        VStack(alignment: .center) {
                            Text("Date")
                            Text(activity.date, format: Date.FormatStyle().month().day())
                                .fontWeight(.bold)
                        }
                    }

                }
                .onDelete { offset in
                    store.removeActivity(workoutId: workoutId, offset: offset)
                }
            }
            .listStyle(.inset)
            .padding(.top, 80)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("\(workout.name)")
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
