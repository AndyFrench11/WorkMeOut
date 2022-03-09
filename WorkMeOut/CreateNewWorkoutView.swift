import SwiftUI

struct CreateNewWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var nameTextField: String = ""
    @State var bodyPartSelection: BodyPart = .none
    @State var focusTypeSelection: FocusType = .none
    @State var movementTypeSelection: MovementType = .none
    @EnvironmentObject var store: Store

    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }

    func checkIsDisabled() -> Bool {
        return
            nameTextField.isEmpty ||
            bodyPartSelection.stringRepresentation.isEmpty ||
            focusTypeSelection.stringRepresentation.isEmpty ||
            movementTypeSelection.stringRepresentation.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Details")) {
                        TextField("Enter a workout name...", text: $nameTextField)
                        Picker("Enter a body part...", selection: $bodyPartSelection) {
                            ForEach(BodyPart.allCases, id: \.self) { bodyPart in
                                if bodyPart != .none {
                                    HStack {
                                        Text("\(bodyPart.stringRepresentation)")
                                        Text("\(bodyPart.emojiRepresentation)")
                                    }
                                    .tag(bodyPart)
                                }
                            }

                        }

                        Picker("Enter a focus type...", selection: $focusTypeSelection) {
                            ForEach(FocusType.allCases, id: \.self) { focusType in
                                if focusType != .none {
                                    HStack {
                                        Text("\(focusType.stringRepresentation)")
                                        Text("\(focusType.emojiRepresentation)")
                                    }
                                    .tag(focusType)
                                }
                            }

                        }

                        Picker("Enter a movement type...", selection: $movementTypeSelection) {
                            ForEach(MovementType.allCases, id: \.self) { movementType in
                                if movementType != .none {
                                    HStack {
                                        Text("\(movementType.stringRepresentation)")
                                        Text("\(movementType.emojiRepresentation)")
                                    }
                                    .tag(movementType)
                                }
                            }
                        }
                    }
                }

                Button("Create Activity") {
                    store.createNewWorkout(
                        name: nameTextField,
                        bodyPart: bodyPartSelection,
                        focusType: focusTypeSelection,
                        movementType: movementTypeSelection
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
