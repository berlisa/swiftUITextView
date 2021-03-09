import Combine
import Foundation
import UIKit

public class AttributedTextModel: ObservableObject {
    @Published public var height: CGFloat
    @Published public var width: CGFloat

    public init(fixedWidth: CGFloat, height: CGFloat = 0) {
        width = fixedWidth
        self.height = height
    }
}
