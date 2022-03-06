import Foundation

class Store: ObservableObject {

    @Published var workouts: [Workout] = workoutData

    func createNewActivity(
        workoutId: Int,
        sets: [Activity.ActivitySet]
     ) {
        workouts[workoutId].activities.append(
            Activity(
                sets: sets,
                date: Date.now
            )
        )
     }

     func removeActivity(workoutId: Int, offset: IndexSet) {
        workouts[workoutId].activities.remove(atOffsets: offset)
     }

     func removeWorkout(offset: IndexSet) {
        workouts.remove(atOffsets: offset)
     }

     func createNewWorkout(
        name: String,
        bodyPart: BodyPart,
        focusType: FocusType,
        movementType: MovementType
    ) {
        workouts.append(
            Workout(
                name: name,
                bodyPart: bodyPart,
                focusType: focusType,
                movementType: movementType
            )
        )
     }

}

var workoutData: [Workout] = [
    .init(
        name: "Chest Press",
        bodyPart: .chest,
        focusType: .compound,
        movementType: .push
    ),
    .init(name: "Squats",         bodyPart: .legs,      focusType: .compound,       movementType: .push),
    .init(name: "Bicep Curls",    bodyPart: .arms,      focusType: .isolation,      movementType: .pull),
    .init(name: "Military Press", bodyPart: .shoulders, focusType: .compound,       movementType: .push)
]


enum BodyPart: CaseIterable {
    case arms
    case legs
    case shoulders
    case chest
    case none

    var stringRepresentation: String {
        switch self {
        case .arms:
            return "Arms"
        case .legs:
            return "Legs"
        case .shoulders:
            return "Shoulders"
        case .chest:
            return "Chest"
        default:
            return ""
        }

    }

    var emojiRepresentation: String {
       switch self {
        case .arms:
            return "🦾"
        case .legs:
            return "🍗"
        case .shoulders:
            return "🙆"
        case .chest:
            return "🫁"
        default:
            return ""
        }
    }
}

enum FocusType: CaseIterable {
    case compound
    case isolation
    case none

    var stringRepresentation: String {
        switch self {
        case .compound:
            return "Compound"
        case .isolation:
            return "Isolation"
        case .none:
            return ""
        }
    }

    var emojiRepresentation: String {
        switch self {
        case .compound:
            return "🔳"
        case .isolation:
            return "▫️"
        case .none:
            return ""
        }
    }
}

enum MovementType: CaseIterable {
    case push
    case pull
    case none

    var stringRepresentation: String {
        switch self {
        case .push:
            return "Push"
        case .pull:
            return "Pull"
        case .none:
            return ""
        }
    }

    var emojiRepresentation: String {
        switch self {
        case .push:
            return "➡️"
        case .pull:
            return "⬅️"
        case .none:
            return ""
        }
    }
}

struct Activity: Identifiable, Hashable {
    var id = UUID()
    var sets: [ActivitySet] = []
    var date: Date

    struct ActivitySet: Identifiable, Hashable {
        var id = UUID()
        var weight: Int
        var reps: Int
    }
}

struct Workout: Identifiable, Hashable {
    var id = UUID()
    var name: String

    var lastWorkOutDate: Date? {
        activities.isEmpty
        ? nil
        : activities.first?.date
    }

    var bodyPart: BodyPart
    var focusType: FocusType
    var movementType: MovementType
    var activities: [Activity] = []
}
