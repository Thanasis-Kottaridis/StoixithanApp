//
//  GenericLoader.swift
//  Presentation
//
//  Created by thanos kottaridis on 1/2/23.
//

import Foundation
import Lottie

enum LottieLoaders: String, Codable {
    case loader1
    
    var jsonText: String {
        switch self {
        case .loader1: return "loading"
        }
    }
}

struct GenericLoader {
    
    private static var animationView = AnimationView()
    private static var instance: LoadingResource?
    
    /**
     - Parameter loaderType: The available type of loaders are described in LottieLoaders enumeration
     */
    static func show(loaderType: LottieLoaders = .loader1) {
        guard !animationView.isAnimationPlaying else { return }
        
        instance = LoadingResource()
        instance?.addLottieView(loaderType)
    }
    
    static func hide(_ animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.instance?.clearView(withAnimation: animated)
        }
        
    }
    
    // MARK: - Main Loading View
    private class LoadingResource: UIView {
        
        fileprivate var type: LottieLoaders = .loader1
        fileprivate var preventLoopState: Bool = false // If we endAnimation before loopState begins, then startEntryAnimation() will automatically trigger loopState. In order to prevent this we observe this flag.
        
        convenience init() {
            self.init(frame: .zero)
            autoresizingMask = [.flexibleTopMargin,
                                .flexibleLeftMargin,
                                .flexibleBottomMargin,
                                .flexibleRightMargin]
            isOpaque = false
            backgroundColor = ColorPalette.White.withAlpha(0.8)
        }
        
        fileprivate func addLottieView(_ lottieType: LottieLoaders) {
            guard let keyWindow = (UIApplication.shared.windows.first { $0.isKeyWindow }) else { return }
            self.type = lottieType
            
            self.addExclusiveConstraints(superview: keyWindow, top: (keyWindow.topAnchor, 0), bottom: (keyWindow.bottomAnchor, 0), left: (keyWindow.leadingAnchor, 0), right: (keyWindow.trailingAnchor, 0))
            
            let animation = Animation.named(
                lottieType.jsonText,
                bundle: Bundle(for: LoadingResource.self)
            )
            animationView.animation = animation
            let bounds = UIScreen.main.bounds
            animationView.addExclusiveConstraints(
                superview: self,
                width: bounds.width / 2,
                height: bounds.width / 2,
                centerX: (self.centerXAnchor),
                centerY: (self.centerYAnchor)
            )
            
            animationView.contentMode = .scaleAspectFill
            animationView.backgroundBehavior = .pauseAndRestore /// Describes the behavior of an AnimationView when the app is moved to the background.
            
            animationView.loopMode = .loop
            animationView.play()
        }
        
        fileprivate func clearView(withAnimation: Bool) {
            self.preventLoopState = true /// Update flag value
            self.removeFromSuperview()
        }
    }
    
}

