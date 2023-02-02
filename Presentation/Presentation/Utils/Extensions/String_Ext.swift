//
//  estimateSize.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation

extension String {
    func truncate(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func estimateSize(
        approximateWidth: CGFloat,
        approximateHeight: CGFloat = 1000,
        fontAsInt: Int,
        fontType: Font = Font.MulishRegular
    ) -> (width: CGFloat, height: CGFloat) {
        var estimatedFrame: CGRect = CGRect()
        let size = CGSize(width: approximateWidth, height: approximateHeight)
        let attributes = [
            NSAttributedString.Key.font : fontType.of(size: fontAsInt.getAdjustedFontSize())
        ]
        
        estimatedFrame = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return (estimatedFrame.width, estimatedFrame.height)
    }
}
