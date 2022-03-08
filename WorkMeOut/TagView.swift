import SwiftUI

struct TagView: View {

    var text: String
    var emoji: String

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
            Text(emoji)
        }
        .font(.caption)
        .foregroundColor(.primary)
        .padding(.all, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.4))
        )
    }
}

struct GroupedVariantTagView: View {
    var bodyPart: BodyPart
    var focusType: FocusType
    var movementType: MovementType

    var body: some View {
        HStack(spacing: 4) {
            TagView(
                text: bodyPart.stringRepresentation,
                emoji: bodyPart.emojiRepresentation
            )
            TagView(
                text: focusType.stringRepresentation,
                emoji: focusType.emojiRepresentation
            )
            TagView(
                text: movementType.stringRepresentation,
                emoji: movementType.emojiRepresentation
            )
        }
    }
}

