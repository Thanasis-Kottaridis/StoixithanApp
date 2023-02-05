//
//  EventCollectionViewCell.swift
//  Sports
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit
import Domain
import Presentation

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var isFavoriteImg: UIImageView!
    @IBOutlet weak var participant1Lbl: UILabel!
    @IBOutlet weak var participant2Lbl: UILabel!
    @IBOutlet weak var countDownContainer: UIView!
    @IBOutlet weak var countDownLbl: UILabel!
    
    // MARK: - Vars
    static let kCONTENT_XIB_NAME = "EventCollectionViewCell"
    private var event: Event?

    override func prepareForReuse() {
        super.prepareForReuse()
        participant1Lbl.text = ""
        participant2Lbl.text = ""
        countDownLbl.text = ""
        isFavoriteImg.image = UIImage(named: "favorite-outline")
    }
    
    func setUpCell(event: Event) {
        self.event = event
        // set up participant lbl
        participant1Lbl.attributedText = event.eventParticipants[safe: 0]?
            .with(.style_16_20(weight: .REGULAR, color: .RegularBlue))
        participant2Lbl.attributedText = event.eventParticipants[safe: 1]?
            .with(.style_16_20(weight: .REGULAR, color: .RegularBlue))
        
        // set up isFavorite Icon
        isFavoriteImg.image = event.isFavoriteUIImage
        
        setUpCountDownView(event: event)
    }
    
    private func setUpCountDownView(event: Event) {
        countDownContainer.layer.cornerRadius = CGFloat(8).adaptedCGFloat()
        countDownContainer.layer.borderColor = ColorPalette.RegularBlue.value.cgColor
        countDownContainer.layer.borderWidth = CGFloat(2).adaptedCGFloat()
        countDownContainer.clipsToBounds = true
        
        countDownLbl.attributedText = event.getCountDown.with(.style_16_20(weight: .REGULAR, color: .RegularBlue))
    }
}

// MARK: - EVENTS MODEL UI EXT
fileprivate extension Event {
    var eventParticipants: [String] {
        let participants = description?.components(separatedBy: " - ") ?? []
        return participants
    }
    
    var isFavoriteUIImage: UIImage? {
        return UIImage(named: self.isFavorite ? "favorite-fill" : "favorite-outline")
    }
    
    var getCountDown: String {
        guard let timestamp = timestamp
        else { return "HH:MM:SS" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date.geCountDownOffset(from: Date(), absValue: true)
    }
}
