import SwiftUI
import SwiftUICharts

struct WorkoutView: View {
    
    var workout: Workout
    var workoutId: Int
    @State var isPresentingForm: Bool = false
    @EnvironmentObject var store: Store
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]

    var body: some View {
        VStack(alignment: .leading) {

            GroupedVariantTagView(
                bodyPart: workout.bodyPart,
                focusType: workout.focusType,
                movementType: workout.movementType
            )

            LineChartView(
                data: [8,23,54,32,12,37,7,23,43],
                title: "Latest Data",
                legend: "INSERT LAST UPDATED",
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
                            // TODO Get average from sets
                            Text("INSERT AVERAGEkg")
                                .fontWeight(.bold)
                            Text("INSERT AVERAGE")
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
