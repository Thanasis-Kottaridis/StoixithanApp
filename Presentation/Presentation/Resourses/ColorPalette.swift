//
//  ColorPalette.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import UIKit

public indirect enum ColorPalette {
    case DarkBlue
    case RegularBlue
    case LightBlue
    case Black
    case White
    case DarkGray
    case Gray
    case Green
    case Red
    case CustomAlpha(color: ColorPalette ,alpha: Double)
    
    public func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

public extension ColorPalette {
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .DarkBlue:
            instanceColor = UIColor(hexString:"#00265E")
        case .RegularBlue:
            instanceColor = UIColor(hexString: "#003476")
        case .LightBlue:
            instanceColor = UIColor(hexString: "#00AEEF")
        case .Black:
            instanceColor = UIColor(hexString: "#212529")
        case .White:
            instanceColor = UIColor(hexString: "#FFFFFF")
        case .Gray:
            instanceColor = UIColor(hexString: "#F4F4F4")
        case .DarkGray:
            instanceColor = UIColor(hexString: "#2C2C2E")
        case .Green:
            instanceColor = UIColor(hexString: "#80C479")
        case .Red:
            instanceColor = UIColor(hexString: "#C4324A")
        case .CustomAlpha(let color, let alpha):
            instanceColor = color.withAlpha(alpha)
        }
        
        return instanceColor

    }
}
