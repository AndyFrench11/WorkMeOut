import SwiftUI

struct TagView: View {

    var text: String
    var emoji: String

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
            Text(emoji)
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.all, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.secondary.opacity(0.6))
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

