import SwiftUI

struct CreateNewActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var sets: [(String, String)] = []
    @EnvironmentObject var store: Store
    var workoutId: Int


    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }

    func checkAllInputFieldsAreEmpty() -> Bool {
        for item in sets {
            if item.0.isEmpty || item.1.isEmpty {
                return true
            }
        }
        return false
    }

    func checkIsDisabled() -> Bool {
        return sets.isEmpty || checkAllInputFieldsAreEmpty()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    ForEach(0 ..< sets.count, id: \.self) { setNumber in
                        Section(header: Text("Set \(setNumber + 1)")) {
                            TextField("Enter a weight (kg)...", text: $sets[setNumber].0)
                                .keyboardType(.decimalPad)
                            TextField("Enter a number of reps...", text: $sets[setNumber].1)
                                .keyboardType(.numberPad)
                            
                            Button("Remove set") {
                                sets.remove(at: setNumber)
                            }
                            .foregroundColor(.red)
                        }

                    }
                    

                    Button("Add new set") {
                        sets.append(("", ""))
                    }
                }

                Button("Create Activity") {
                    store.createNewActivity(
                        workoutId: workoutId,
                        sets: sets.map({ (weight, reps) in
                            .init(weight: Double(weight)!, reps: Int(reps)!)
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
