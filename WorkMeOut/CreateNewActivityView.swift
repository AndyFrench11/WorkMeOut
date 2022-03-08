import SwiftUI

struct CreateNewActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var sets: [(String, String)] = []
    @EnvironmentObject var store: Store
    var workoutId: Int


    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }

    // TODO: Extend to check if numeric all strings aren't empty and valid
    func checkIsDisabled() -> Bool {
        return sets.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    ForEach(0 ..< sets.count, id: \.self) { setNumber in
                        Section(header: Text("Set \(setNumber + 1)")) {
                            TextField("Enter a weight...", text: $sets[setNumber].0)
                            TextField("Enter a number of reps...", text: $sets[setNumber].1)
                            
                            Button("Remove set") {
                                sets.remove(at: setNumber)
                            }
                            .foregroundColor(.red)
                        }
                        .keyboardType(.numberPad)
                    }
                    

                    Button("Add new set") {
                        sets.append(("", ""))
                    }
                }

                Button("Create Activity") {
                    store.createNewActivity(
                        workoutId: workoutId,
                        sets: sets.map({ (weight, reps) in
                            .init(weight: Int(weight)!, reps: Int(reps)!)
                        })
                    )
                    dismissModal()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(checkIsDisabled() ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .disabled(checkIsDisabled())

            }
            .navigationTitle("New Activity ✏️")
        }
    }
}
