//
//  BaseWindow.swift
//  Presentation
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation
import UIKit
import Domain

public class BaseWindow: UIWindow {
    
    private var messageView: FeedbackMessageView?
    
    public lazy var  presentableMessageTimeCounter: Int = { return 0 }()
    public lazy var presentableMessageTimer: Timer = {
        return Timer()
    }()
    
    @objc private func fireTimer() {
        self.presentableMessageTimeCounter += 1
        print("....timer: \(presentableMessageTimeCounter)")
        if self.presentableMessageTimeCounter >= 4 { // present for 2 seconds
            presentableMessageTimer.invalidate()
            self.dismissingFeedbackMessage()
        }
    }
    
    public func resetTimer() {
        // set up timer
        print("....RESET TIMER ENTER")
        presentableMessageTimeCounter = 0
        presentableMessageTimer.invalidate()
        
        presentableMessageTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    public func presentingFeedbackMessage(feedBack: FeedbackMessage) {
        
        // FIXME: - Temp fix for handling presentation of multiple messages
        if messageView != nil {
            dismissingFeedbackMessage {[weak self] in
                self?.resetTimer()
                self?.presentingFeedbackMessage(feedBack: feedBack)
            }
            return
        }
        
        messageView = FeedbackMessageView()
        messageView?.setUpView(message: feedBack)
        
        guard let messageView = messageView else {
            return
        }

        let estimatedHeight = messageView.estimateHeight(message: feedBack)
        messageView.frame = CGRect(x: 0, y: -estimatedHeight, width: UIScreen.main.bounds.width, height: estimatedHeight)
        
        self.addSubview(messageView)
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) { [weak self] in
//            let topPadding = self?.safeAreaInsets.top ?? 0
            messageView.frame.origin.y = 0
        }
        
        animator.addCompletion({[weak self] (_) in
            self?.resetTimer()
        })
        
        animator.startAnimation()
    }
    
    public func dismissingFeedbackMessage(completion: (()-> Void)? = nil) {
        guard let messageView = messageView else {
            return
        }
        
        let dismissAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            messageView.frame.origin.y = -messageView.frame.size.height
        }
        
        dismissAnimator.startAnimation()
        
        dismissAnimator.addCompletion { [weak self] _ in
            self?.messageView?.removeFromSuperview()
            self?.messageView = nil
            completion?()
        }
    }
}
