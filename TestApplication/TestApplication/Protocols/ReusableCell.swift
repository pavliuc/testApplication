import UIKit
import Foundation

protocol ReusableCell: class {
    static var identifier: String { get }
}

extension ReusableCell where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
