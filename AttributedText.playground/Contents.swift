import SwiftUI
import PlaygroundSupport

private struct AttributedTextView: UIViewRepresentable {
    private let attributed: Attributed
    private let model: AttributedTextModel

    init(
        model: AttributedTextModel,
        attributedString: Attributed
    ) {
        self.model = model
        attributed = attributedString
    }

    func makeUIView(context: Context) -> TextView {
        let textView = TextView(frame: .zero)
        textView.attributedText = attributed.nsAttributedString

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        adjustTextViewHeight(textView)

        return textView
    }

    func updateUIView(_ textView: TextView, context: Context) {
        adjustTextViewHeight(textView)
    }

    private func adjustTextViewHeight(_ textView: TextView) {
        let height = textView.sizeThatFits(CGSize(width: model.width, height: CGFloat.greatestFiniteMagnitude)).height

        textView.frame = CGRect(origin: .zero, size: CGSize(width: model.width, height: height))

        model.height = height
    }
}

struct AttributedText: View {
    private var attributedString: Attributed
    @ObservedObject private var model: AttributedTextModel

    init(_ attributedString: Attributed, fixedWidth: CGFloat = 0, height: CGFloat = 0) {
        model = AttributedTextModel(fixedWidth: fixedWidth, height: height)
        self.attributedString = attributedString
    }

    var body: some View {
        AttributedTextView(model: model, attributedString: attributedString)
            .frame(
                idealWidth: model.width,
                idealHeight: model.height
            )
    }

    var asUIView: UIView {
        TextView()
    }
}


// MARK: Testing

PlaygroundPage.current.setLiveView(Preview().frame(width: 250, height: 400))


struct Preview: View {
    var body: some View {
        VStack {
            AttributedText(
                AttributedString {
                    AttributedString(string: "Test 1: size to fit")
                        .font(.boldSystemFont(ofSize: 15))
                        .newline()


                    AttributedString(string: "Fixed Width 150, fixed Size = show all, fit size")
                        .underline()
                        .newline()

                    AttributedString(
                        string: "START - Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.x - END"
                    )
                },
                fixedWidth: 250
            )
            .fixedSize()
            .background(Color.yellow)
        }
    }
}
