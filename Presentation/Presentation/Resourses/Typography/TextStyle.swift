//
//  TextStyle.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation
import BonMot

public struct TextStyle {
    public enum StyleWeight {
        case BLACK
        case BOLD
        case EXTRA_BOLD
        case EXTRA_LIGHT
        case LIGHT
        case REGULAR
        case SEMIBOLD
            
        func returnFont() -> Font {
            switch self {
            case .BLACK:
                return Font.MulishBlack
            case .BOLD:
                return Font.MulishBlack
            case .EXTRA_BOLD:
                return Font.MulishExtraBold
            case .EXTRA_LIGHT:
                return Font.MulishExtraLight
            case .LIGHT:
                return Font.MulishLight
            case .REGULAR:
                return Font.MulishMedium
            case .SEMIBOLD:
                return Font.MulishSemiBold
            }
        }
    }
    
    public enum Style {
        // MARK: - Figma
        case style_64_80(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_48_56(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_40_48(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_32_40(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_28_32(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_24_32(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_20_28(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_18_24(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_16_24(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_16_20(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_14_18(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_14_24(weight: StyleWeight, color: ColorPalette? = .Black)
        case style_12_16(weight: StyleWeight, color: ColorPalette? = .Black)
        case custom(
            weight: StyleWeight,
            size: Int,
            ColorPalette: CGFloat,
            lineHeight: CGFloat,
            color: ColorPalette = .Black
        )
        
        public func stringStyle() -> BonMot.StringStyle {
            switch self {
            case .style_64_80(let weight, let color):
                return getStyle(weight: weight,
                                size: 64,
                                letterSpacing: 0.02,
                                lineHeight: 80.0,
                                color: color
                        )
            case .style_48_56(let weight, let color):
                return getStyle(weight: weight, size: 48,
                                letterSpacing: 0,
                                lineHeight: 56.0,
                                color: color
                        )
            case .style_40_48(let weight, let color):
                return getStyle(weight: weight, size: 40,
                                letterSpacing: 0,
                                lineHeight: 48.0,
                                color: color
                        )
            case .style_32_40(let weight, let color):
                return getStyle(weight: weight, size: 32,
                                letterSpacing: 0.02,
                                lineHeight: 40.0,
                                color: color
                        )
            case .style_28_32(let weight, let color):
                return getStyle(weight: weight, size: 28,
                                letterSpacing: 0.02,
                                lineHeight: 32.0,
                                color: color
                        )
            case .style_24_32(let weight, let color):
                return getStyle(weight: weight, size: 24,
                                letterSpacing: 0.02,
                                lineHeight: 32.0,
                                color: color
                        )
            case .style_20_28(let weight, let color):
                return getStyle(weight: weight, size: 20,
                                letterSpacing: 0.02,
                                lineHeight: 28.0,
                                color: color
                        )
            case .style_18_24(let weight, let color):
                return getStyle(weight: weight, size: 18,
                                letterSpacing: 0,
                                lineHeight: 24.0,
                                color: color
                        )
            case .style_16_24(let weight, let color):
                return getStyle(weight: weight, size: 16,
                                letterSpacing: 0.01,
                                lineHeight: 24.0,
                                color: color
                        )
            case .style_16_20(let weight, let color):
                return getStyle(weight: weight, size: 16,
                                letterSpacing: 0.01,
                                lineHeight: 20.0,
                                color: color
                        )
            case .style_14_18(let weight, let color):
                return getStyle(weight: weight, size: 14,
                                letterSpacing: 0.02,
                                lineHeight: 18.0,
                                color: color
                        )
            case .style_14_24(let weight, let color):
                return getStyle(weight: weight, size: 14,
                                letterSpacing: 0,
                                lineHeight: 24.0,
                                color: color
                
                        )
            case .style_12_16(let weight, let color):
                return getStyle(weight: weight, size: 12,
                                letterSpacing: 0.01,
                                lineHeight: 16.0,
                                color: color
                        )
            case .custom(let weight, let size, let letterSpacing, let lineHeight, let color):
                return getStyle(weight: weight, size: size,
                                letterSpacing: letterSpacing,
                                lineHeight: lineHeight,
                                color: color
                        )
            }
        }

    }
    
    public static func getStyle(
        weight: StyleWeight, size: Int,
        letterSpacing: CGFloat,
        lineHeight: CGFloat,
        color: ColorPalette? = .Black
    ) -> BonMot.StringStyle {
        if let color = color {
            return StringStyle(
                .color(color.value),
                .font(weight.returnFont().of(size: size.getAdjustedFontSize())),
                .extraAttributes([NSAttributedString.Key.kern: CGFloat(size) * letterSpacing])
            )
        } else {
            return StringStyle(
                .font(weight.returnFont().of(size: size.getAdjustedFontSize())),
                .extraAttributes([NSAttributedString.Key.kern: CGFloat(size) * letterSpacing])
            )
        }
    }
    
}

// MARK: - EXTENSIONS
public extension String {
    /**
    # Attributed Text Style util.
     Use .with method in order to get preferable  `TextStyle.Style` attributed text
     */
    func with(_ style: TextStyle.Style) -> NSAttributedString {
        return self.styled(with: style.stringStyle())
    }
}

public extension Int {
    
    /**
    # Adapted Font Size.
     Get dynamicly addapted font size based on figma width regerence
     */
    func getAdjustedFontSize() -> CGFloat {
        // Figma project is created for Pixel 2 with screen width of 411 pixels
        let projectSize: CGFloat = 411
        let currentSize: CGFloat = UIScreen.main.bounds.width
        
        // With the Rule of Three we can calculate the font size for the current device
        let finalFontSize: CGFloat = (currentSize * CGFloat(self)) / projectSize
        
        return finalFontSize
    }
}
