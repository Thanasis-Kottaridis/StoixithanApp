//
//  GenericHeader.swift
//  Presentation
//
//  Created by thanos kottaridis on 5/2/23.
//

import UIKit

public struct GenericHeaderConfigurations {
    public let appLogo: String
    public let backgroundColor: ColorPalette
    public let leftIcon: String?
    public let leftAction: (() -> Void)?
    public let rightIcon: String?
    public let rightAction: (() -> Void)?
    public let applyTopSafeAreaPadding: Bool
    
    public init(
        appLogo: String,
        backgroundColor: ColorPalette,
        leftIcon: String?,
        leftAction: (() -> Void)?,
        rightIcon: String?,
        rightAction: (() -> Void)?,
        applyTopSafeAreaPadding: Bool
    ) {
        self.appLogo = appLogo
        self.backgroundColor = backgroundColor
        self.leftIcon = leftIcon
        self.leftAction = leftAction
        self.rightIcon = rightIcon
        self.rightAction = rightAction
        self.applyTopSafeAreaPadding = applyTopSafeAreaPadding
    }
    
    public class Builder {
        private var appLogo: String
        private var backgroundColor: ColorPalette = ColorPalette.RegularBlue
        private var leftIcon: String? = nil
        private var leftAction: (() -> Void)? = nil
        private var rightIcon: String? = nil
        private var rightAction: (() -> Void)? = nil
        private var applyTopSafeAreaPadding: Bool = true
        
        public init(appLogo: String) {
            self.appLogo = appLogo
        }
        
        @discardableResult
        public func setUpBGColor(
            backgroundColor: ColorPalette
        ) -> Self {
            self.backgroundColor = backgroundColor
            return self
        }
        
        @discardableResult
        public func setUpRightIcon(
            rightIcon: String,
            action: @escaping () -> Void
        ) -> Self {
            self.rightIcon = rightIcon
            self.rightAction = action
            return self
        }
        
        @discardableResult
        public func setUpLeftIcon(
            leftIcon: String,
            action: @escaping () -> Void
        ) -> Self {
            self.leftIcon = leftIcon
            self.leftAction = action
            return self
        }
        
        @discardableResult
        public func applyTopSafeAreaPadding(
            shouldApply: Bool
        ) -> Self {
            self.applyTopSafeAreaPadding = shouldApply
            return self
        }
        
        // MARK: - Builde fnuc
        public func build() -> GenericHeaderConfigurations {
            GenericHeaderConfigurations(
                appLogo: appLogo,
                backgroundColor: backgroundColor,
                leftIcon: leftIcon,
                leftAction: leftAction,
                rightIcon: rightIcon,
                rightAction: rightAction,
                applyTopSafeAreaPadding: applyTopSafeAreaPadding
            )
        }
    }
}

public class GenericHeader: UIView {

    // MARK: - Vars
    public let kCONTENT_XIB_NAME = "GenericHeader"
    public var headerConfigurations: GenericHeaderConfigurations?
    private var topSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0

    // MARK: - Outlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var rightIcon: UIImageView!
    @IBOutlet public weak var leftIcon: UIImageView!
    @IBOutlet public weak var appIcon: UIImageView!
    @IBOutlet public weak var headerTopConstraint: NSLayoutConstraint!

    
    // MARK: - Inits
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    public func setUpViwe(configurations: GenericHeaderConfigurations) {
        self.headerConfigurations = configurations
        contentView.backgroundColor = configurations.backgroundColor.value
        appIcon.image = UIImage(named: configurations.appLogo)
        
        // set up option buttons
        setUpRightIcon(configurations: configurations)
        setUpLeftIcon(configurations: configurations)
        
        // set up top constraint.
        headerTopConstraint.constant = configurations.applyTopSafeAreaPadding ? topSafeArea : 0
    }
    
    private func setUpRightIcon(configurations: GenericHeaderConfigurations) {
        guard let icon = configurations.rightIcon,
              let action = configurations.rightAction
        else { return }
        rightIcon.image = UIImage(named: icon)
        rightIcon.addTapGestureRecognizer(action: action)
    }
    
    private func setUpLeftIcon(configurations: GenericHeaderConfigurations) {
        guard let icon = configurations.leftIcon,
              let action = configurations.leftAction
        else { return }
        leftIcon.image = UIImage(named: icon)
        leftIcon.addTapGestureRecognizer(action: action)
    }
}
