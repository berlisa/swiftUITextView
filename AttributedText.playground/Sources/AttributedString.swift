import Foundation
import UIKit

public protocol Attributed {
    var nsAttributedString: NSMutableAttributedString { get }

    init(string: String)
    init(attributedString: Attributed)
    init(@AttributedStringBuilder _ builder: () -> Attributed?)

    @discardableResult func append(_ attrString: Attributed) -> Self
    @discardableResult func appending(_ attrString: Attributed) -> Self
    @discardableResult func space() -> Self
    @discardableResult func newline() -> Self
    
    @discardableResult func font(_ font: UIFont) -> Self
    @discardableResult func foregroundColor(_ color: UIColor) -> Self
    @discardableResult func kerning(_ kerning: CGFloat) -> Self
    @discardableResult func underline(style: NSUnderlineStyle, color: UIColor?) -> Self
    @discardableResult func stroke(color: UIColor, width: CGFloat) -> Self
    @discardableResult func lineSpacing(_ lineSpacing: CGFloat) -> Self
    @discardableResult func lineHeightMultiple(_ multiple: CGFloat) -> Self
    @discardableResult func lineBreak(_ mode: NSLineBreakMode) -> Self
    @discardableResult func alignment(_ alignment: NSTextAlignment) -> Self
}

public func + (lhs: Attributed, rhs: Attributed) -> Attributed {
    lhs.appending(rhs)
}

@_functionBuilder
public class AttributedStringBuilder {
    public static func buildBlock(_ attributedStrings: Attributed...) -> Attributed? {
        attributedStrings.dropFirst().reduce(into: attributedStrings.first) { result, current in
            result?.append(current)
        }
    }
}

public struct AttributedString: Attributed {
    public var nsAttributedString: NSMutableAttributedString

    public init(string: String = "") {
        nsAttributedString = NSMutableAttributedString(string: string)
    }

    init(attributedString: NSAttributedString) {
        nsAttributedString = NSMutableAttributedString(attributedString: attributedString)
    }

    public init(attributedString: Attributed) {
        nsAttributedString = attributedString.nsAttributedString
    }

    public init(@AttributedStringBuilder _ builder: () -> Attributed?) {
        if let attributedString = builder() {
            self.init(attributedString: attributedString)
        } else {
            self.init()
        }
    }

    @discardableResult
    public func appending(_ attrString: Attributed) -> Self {
        let sum = AttributedString(attributedString: self)
        sum.append(attrString)
        return sum
    }

    @discardableResult
    public func append(_ attrString: Attributed) -> Self {
        nsAttributedString.append(attrString.nsAttributedString as NSAttributedString)
        return self
    }

    @discardableResult
    public func space() -> Self {
        append(NSAttributedString(string: "\u{20}"))
    }
    
    @discardableResult
    public func newline() -> Self {
        append(NSAttributedString(string: "\n"))
    }

    @discardableResult
    public func font(_ font: UIFont) -> Self {
        apply([.font: font])
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        apply([.foregroundColor: color])
    }

    @discardableResult
    public func kerning(_ kerning: CGFloat) -> Self {
        apply([.kern: kerning])
    }

    @discardableResult
    public func underline(style: NSUnderlineStyle = .single, color: UIColor? = nil) -> Self {
        apply([.underlineStyle: style.rawValue])
        if let color = color {
            apply([.underlineColor: color])
        }
        return self
    }

    @discardableResult
    public func stroke(color: UIColor, width: CGFloat) -> Self {
        apply([
            .strokeColor: color,
            .strokeWidth: width
        ])
    }

    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        let paragraph = paragraphStyle
        paragraph.lineSpacing = lineSpacing
        return apply([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineHeightMultiple(_ multiple: CGFloat) -> Self {
        let paragraph = paragraphStyle
        paragraph.lineHeightMultiple = multiple
        return apply([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineBreak(_ mode: NSLineBreakMode) -> Self {
        let paragraphStyle = self.paragraphStyle
        paragraphStyle.lineBreakMode = mode
        return apply([.paragraphStyle: paragraphStyle])
    }

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        let paragraphStyle = self.paragraphStyle
        paragraphStyle.alignment = alignment
        return apply([.paragraphStyle: paragraphStyle])
    }

    private var range: NSRange {
        NSRange(location: 0, length: nsAttributedString.length)
    }

    private var paragraphStyle: NSMutableParagraphStyle {
        nsAttributedString.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
    }

    @discardableResult
    private func apply(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        nsAttributedString.addAttributes(attributes, range: range)
        return self
    }

    private func append(_ attrString: NSAttributedString) -> Self {
        nsAttributedString.append(attrString)
        return self
    }
}
