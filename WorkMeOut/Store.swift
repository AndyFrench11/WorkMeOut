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
        Store.save(workouts: workouts) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
     }

     func removeActivity(workoutId: Int, offset: IndexSet) {
        workouts[workoutId].activities.remove(atOffsets: offset)
        Store.save(workouts: workouts) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
     }

     func removeWorkout(offset: IndexSet) {
        workouts.remove(atOffsets: offset)
        Store.save(workouts: workouts) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
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
        Store.save(workouts: workouts) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
     }

     private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("workouts.data")
     }

    static func load(completion: @escaping (Result<[Workout], Error>) -> Void) {
         DispatchQueue.global(qos: .background).async {
             do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let workouts = try JSONDecoder().decode([Workout].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(workouts))
                }
             } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
             }
         }
     }

     static func save(workouts: [Workout], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(workouts)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(workouts.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
     }

}

var workoutData: [Workout] = [
    .init(
        name: "Chest Press",
        bodyPart: .chest,
        focusType: .compound,
        movementType: .push,
        activities: [
            .init(
                sets: [
                    .init(weight: 5, reps: 12),
                    .init(weight: 5, reps: 12),
                    .init(weight: 5, reps: 12),
                    .init(weight: 5, reps: 12),
                ],
                date: Date.now
            ),
            .init(
                sets: [
                    .init(weight: 10, reps: 12),
                    .init(weight: 12, reps: 12),
                    .init(weight: 8, reps: 12),
                    .init(weight: 9, reps: 12),
                ],
                date: Date.now
            )
        ]
    ),
    .init(name: "Squats",         bodyPart: .legs,      focusType: .compound,       movementType: .push),
    .init(name: "Bicep Curls",    bodyPart: .arms,      focusType: .isolation,      movementType: .pull),
    .init(name: "Military Press", bodyPart: .shoulders, focusType: .compound,       movementType: .push)
]


enum BodyPart: CaseIterable, Codable {
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

enum FocusType: CaseIterable, Codable {
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

enum MovementType: CaseIterable, Codable {
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

struct Activity: Identifiable, Hashable, Codable {
    var id = UUID()
    var sets: [ActivitySet] = []
    var date: Date

    struct ActivitySet: Identifiable, Hashable, Codable {
        var id = UUID()
        var weight: Int
        var reps: Int
    }

    func getAverageWeight() -> Double {
        let sum = sets.reduce(0) { partialResult, activitySet in
            partialResult + activitySet.weight
        }
        return Double(sum / sets.count)
    }

    func getAverageReps() -> Double {
        let sum = sets.reduce(0) { partialResult, activitySet in
            partialResult + activitySet.reps
        }
        return Double(sum / sets.count)
    }
}

struct Workout: Identifiable, Hashable, Codable {
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

    func getAverageWeight() -> [Double] {
        return activities.map { activity in
            activity.getAverageWeight()
        }
    }

    func getLastWorkoutDateString() -> String {
        if let lastWorkOutDate = lastWorkOutDate {
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"

            // Convert Date to String
            return dateFormatter.string(from: lastWorkOutDate)
        } else {
            return "Not exercised yet"
        }
    }
}
