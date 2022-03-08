import SwiftUI
import SwiftUICharts

struct WorkoutView: View {
    
    var workout: Workout
    var workoutId: Int
    @State var isPresentingForm: Bool = false
    @EnvironmentObject var store: Store

    var body: some View {
        VStack(alignment: .leading) {

            GroupedVariantTagView(
                bodyPart: workout.bodyPart,
                focusType: workout.focusType,
                movementType: workout.movementType
            )
            .padding(.horizontal, 16)

            LineChartView(
                data: workout.getAverageWeight(),
                title: "Latest Data",
                legend: workout.lastWorkOutDate != nil ? "\(workout.lastWorkOutDate)" : "Not exercised yet",
                form: ChartForm.extraLarge,
                dropShadow: false
            )
            .padding()


            List {
                if workout.activities.isEmpty {
                    Text("There have been no activites yet.")
                }
                ForEach(workout.activities) { activity in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Average weight: ")
                            Text("Average reps: ")
                        }

                        VStack(alignment: .leading) {
                            Text("\(activity.getAverageWeight())kg")
                                .fontWeight(.bold)
                            Text("\(activity.getAverageReps())")
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
            .listStyle(.plain)
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
