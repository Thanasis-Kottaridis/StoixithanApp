//
//  FeedbackMessageView.swift
//  iOSGovWallet
//
//  Created by thanos kottaridis on 19/4/22.
//

import UIKit
import Domain

@IBDesignable
class FeedbackMessageView: UIView {
    // MARK: - OUTLET
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wifiIcon: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var contentToTopConstraint: NSLayoutConstraint!
    
    // MARK: - VARS
    let kCONTENT_XIB_NAME = "FeedbackMessageView"
    private var message: FeedbackMessage?
    private var topPadding: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    // MARK: - INITS
    override init(frame: CGRect) { // for using custom view in code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) { // for using custom view in xib
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - DISIGNABLE IMPLEMENTATION
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        contentView?.prepareForInterfaceBuilder()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        contentView.clipsToBounds = true
        // set up top padding
        contentToTopConstraint.constant = 16 + topPadding
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    func setUpView(message: FeedbackMessage) {
        self.message = message
        messageLbl.attributedText = message.message
            .with(.style_16_20(
                weight: .REGULAR,
                color: .White
            ))
        
        switch message.type {
        case .success:
            contentView.backgroundColor = ColorPalette.Green.value
        case .error:
            contentView.backgroundColor = ColorPalette.Red.value
        case .info:
            contentView.backgroundColor = ColorPalette.Gray.value
        case .network(let isError):
            contentView.backgroundColor = isError ? ColorPalette.Red.value : ColorPalette.Green.value
            
            wifiIcon.image = isError ? UIImage(named: "nowifi") :
            UIImage(named: "wifi")
        }
        
        closeIcon.addTapGestureRecognizer {
            let window = UIApplication.shared.windows.first as? BaseWindow
            window?.dismissingFeedbackMessage(completion: nil)
        }
    }
    
    func estimateHeight(message: FeedbackMessage) -> CGFloat {
        // safe area top insent + 16 top + 16 bottom + safe area / 2 for presentation reasons
        var estimateHeight = topPadding + CGFloat(16 + 16) + topPadding/2
        // screen width - 24 leading - 24 traling - 32 for cancel icon - 16 stack view padding
        estimateHeight += message.message.estimateSize(
            approximateWidth: UIScreen.main.bounds.width - 48 - 32 - 16,
            fontAsInt: 16,
            fontType: Font.MulishRegular
        ).height
        
        return estimateHeight
    }
}

