//
//  UIView_Ext.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit

// MARK: - UIView Ext
extension UIView {
    public func addShadow(
        cornerRadius: CGFloat,
        shadowRadius: CGFloat,
        shadowHeight: CGFloat = 2
    ) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: 0, height: shadowHeight)
        self.layer.shadowOpacity = 1
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    public func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = { (_: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    public func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = { (_: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
    
    // MARK: - Automatically add constraints
    public func addExclusiveConstraints(
        superview: UIView,
        top: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)? = nil,
        bottom: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)? = nil,
        left: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
        right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        if let top = top {
            self.topAnchor.constraint(equalTo: top.anchor, constant: top.constant).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom.anchor, constant: -bottom.constant).isActive = true
        }
        if let left = left {
            self.leadingAnchor.constraint(equalTo: left.anchor, constant: left.constant).isActive = true
        }
        if let right = right {
            self.trailingAnchor.constraint(equalTo: right.anchor, constant: -right.constant).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

// MARK: - Add Tap Gesture With Action
extension UIView {
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "DynamicGestureAssociatedObjectKey_dynamicGesture"
        static var longPressGestureRecognizer = "DynamicGestureAssociatedObjectKey_longPress_dynamicGesture"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    fileprivate var longPressGestureRecognizerAction: Action? {
        get {
            let gestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.longPressGestureRecognizer) as? Action
            return gestureRecognizerActionInstance
        }
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.longPressGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addLongPressGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.longPressGestureRecognizerAction = action
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    // Every time the user longPress on the UIView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        if let action = self.longPressGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
