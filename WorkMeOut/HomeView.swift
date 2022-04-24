import SwiftUI

struct HomeView: View {

    @EnvironmentObject var store: Store
    @State var isPresentingForm: Bool = false
    @State var searchText: String = ""

    func filterList(with text: String, workouts: [Workout]) -> [Workout] {
        if text.isEmpty {
            return workouts
        } else {
            return workouts.filter( { $0.name.localizedStandardContains(text) } )
        }
    }

    func generateSections() -> [BodyPart: [Workout]] {
        var sections = [BodyPart: [Workout]]()
        for workout in store.workouts {
            if sections[workout.bodyPart] != nil {
                sections[workout.bodyPart]!.append(workout)
            } else {
                sections[workout.bodyPart] = [workout]
            }

        }

        return sections
    }

    var body: some View {
        let sections = generateSections()

        NavigationView {
            ZStack(alignment: .topLeading) {
                List {
                    ForEach(BodyPart.allCases, id: \.self) { bodyPart in
                        if bodyPart != .none {
                            Section(header: Text("\(bodyPart.stringRepresentation) \(bodyPart.emojiRepresentation)")) {
                                ForEach(filterList(with: searchText, workouts: sections[bodyPart] ?? [])) { workout in
                                    NavigationLink(
                                        destination:
                                            WorkoutView(
                                                workout: workout,
                                                workoutId: store.workouts.firstIndex(of: workout)!
                                            )
                                    ) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(workout.name)
                                                    .font(.body)
                                                    .fontWeight(.bold)

                                                GroupedVariantTagView(
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
                        }

                    }

                }
                .headerProminence(.increased)
                .searchable(text: $searchText, placement: .toolbar, prompt: "What ya lookin' for...")
                
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

