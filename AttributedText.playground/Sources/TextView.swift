import UIKit

final public class TextView: UITextView {

    override public init(frame: CGRect = .zero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        alwaysBounceVertical = false
        textContainerInset = .zero
        isScrollEnabled = false
        backgroundColor = .clear
        
        textContainer?.lineFragmentPadding = 0
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
