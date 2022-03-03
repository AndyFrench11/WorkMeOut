import Foundation

class Store: ObservableObject {

    @Published var workouts: [Workout] = workoutData

    func createNewActivity(
        workoutId: Int,
        weight: Int,
        reps: Int
     ) {
        workouts[workoutId].activities.append(
            Activity(
                weight: weight,
                reps: reps,
                date: Date.now
            )
        )
     }

}

var workoutData: [Workout] = [
    .init(
        name: "Chest Press",
        lastWorkOutDate: "12/15/21",
        workoutType: .chest,
        activities: [
            .init(
                weight: 50,
                reps: 8,
                date: Date.now
            ),
            .init(
                weight: 60,
                reps: 6,
                date: Date.now
            ),
            .init(
                weight: 70,
                reps: 4,
                date: Date.now
            ),
        ]
    ),
    .init(name: "Squats",         lastWorkOutDate: "11/01/22", workoutType: .legs),
    .init(name: "Bicep Curls",    lastWorkOutDate: "12/02/22", workoutType: .arms),
    .init(name: "Military Press", lastWorkOutDate: "25/01/21", workoutType: .shoulders),

]


enum WorkoutType {
    case arms
    case legs
    case shoulders
    case chest
}

struct Activity: Identifiable, Hashable {
    var id = UUID()
    var weight: Int
    var reps: Int
    var date: Date
}

struct Workout: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var lastWorkOutDate: String
    var workoutType: WorkoutType
    var activities: [Activity] = []

    var icon: String {
        switch workoutType {
        case .arms:
            return "🦾"
        case .legs:
            return "🍗"
        case .shoulders:
            return "🙆"
        case .chest:
            return "🫁"
        }
    }
}
