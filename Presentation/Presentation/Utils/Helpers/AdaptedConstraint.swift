//
//  AdaptedConstraint.swift
//  Presentation
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit

public class AdaptedConstraint: NSLayoutConstraint {
    
    // MARK: - Properties
    public var initialConstant: CGFloat?
    public var adaptedConstant: CGFloat?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        saveConstant()
        adaptConstant()
    }
    
    public var isAdapted: Bool {
        return adaptedConstant == constant
    }
    
    // MARK: - Adapt constant
    public func adaptConstant() {
        if //let dimension = getDimension(from: firstAttribute),
            let initialConstant = initialConstant {
            adaptedConstant = adapted(dimensionSize: initialConstant, to: getDimension())
            self.constant = adaptedConstant!
        }
    }
    
    public func getDimension() -> Dimension {
        /// For now the only supported dimention is Portait => .width.
        /// UIDevice.current.orientation.isPortrait ? .width : .height
        
        return Dimension.width
    }
    
    // MARK: - Reset constant
    public func saveConstant() {
        initialConstant = self.constant
    }
    
    public func resetConstant() {
        if let initialConstant = initialConstant {
            self.constant = initialConstant
        }
    }
}

// MARK: UIView Scaling Extensions.

import Foundation

public enum Dimension {
    case width
    case height
    
    public func getReferenceDimension() -> CGFloat {
        switch self {
        case .width:
            return 411
        case .height:
            return 732 // height based on aspec retion. (UIScreen.main.bounds.height / UIScreen.main.bounds.width) * 411
        }
    }
}

public func resized(size: CGSize, basedOn dimension: Dimension) -> CGSize {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio  = size.height / size.width
        width  = screenWidth * (size.width / dimension.getReferenceDimension())
        height = width * ratio
    case .height:
        ratio  = size.width / size.height
        height = screenHeight * (size.height / dimension.getReferenceDimension())
        width  = height * ratio
    }
    
    return CGSize(width: width, height: height)
}

public func resized(rect: CGRect, basedOn dimension: Dimension) -> CGRect {
    return CGRect(origin: rect.origin, size: resized(size: rect.size, basedOn: dimension))
}

public func adapted(dimensionSize: CGFloat, to dimension: Dimension) -> CGFloat {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var resultDimensionSize: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio = dimensionSize / dimension.getReferenceDimension()
        resultDimensionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / dimension.getReferenceDimension()
        resultDimensionSize = screenHeight * ratio
    }
    
    return resultDimensionSize
}

///# Helper class in order to create vars on extensions.
public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

public extension CGFloat {
    func adaptedCGFloat() -> Self {
        /// For now the only supported dimention is Portait => .width.
        let dimension: Dimension = Dimension.width
        return adapted(dimensionSize: self, to: dimension)
    }
}

public extension NSLayoutConstraint {
    var scaleFactorX: CGFloat {
        return UIScreen.main.bounds.width / Dimension.width.getReferenceDimension()
    }
    
    var scaleFactorY: CGFloat {
        return UIScreen.main.bounds.height / Dimension.height.getReferenceDimension()
    }
    
    var dimention: Dimension {
        /// For now the only supported dimention is Portait => .width.
        return Dimension.width
    }
    
    @IBInspectable var scaleConstant: Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                self.constant *= dimention == .width ? scaleFactorX : scaleFactorY
            }
        }
    }
}

public extension UIStackView {
    @IBInspectable var adaptedSpacing: CGFloat {
        get {
            return 0
        }
        set {
            self.spacing = newValue.adaptedCGFloat()
        }
    }
}

public extension CGRect {
    func resize(dimention: Dimension = .width) -> Self {
        return resized(rect: self, basedOn: dimention)
    }
}

public extension CGSize {
    func resize(dimention: Dimension = .width) -> Self {
        return resized(size: self, basedOn: dimention)
    }
}

public extension Int {
    func adapted() -> CGFloat {
        return CGFloat(self).adaptedCGFloat()
    }
}
