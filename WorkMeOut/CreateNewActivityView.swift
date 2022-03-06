import SwiftUI

struct CreateNewActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var weightTextField: String = ""
    @State var repsTextField: String = ""
    @EnvironmentObject var store: Store
    var workoutId: Int


    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }

    func checkIsDisabled() -> Bool {
        return weightTextField.isEmpty || repsTextField.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    // TODO - Repeat group for number of sets
                    Section(header: Text("Details")) {
                        TextField("Enter a weight...", text: $weightTextField)
                        TextField("Enter a number of reps...", text: $repsTextField)
                    }
                    .keyboardType(.numberPad)
                }

                Button("Create Activity") {
                    store.createNewActivity(
                        workoutId: workoutId,
                        sets: []
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
