import UIKit

@IBDesignable
class DesignableTextField: UITextField {
}

extension UITextField {
    
    @IBInspectable
    var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil
                ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable
    var clearButtonColor: UIColor? {
        get {
            return self.clearButtonColor
        }
        set {
            if let button = self.value(forKey: "_clearButton") as? UIButton {
                button.tintColor = .white
                button.setImage(UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.setImage(UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
                button.setImage(UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
