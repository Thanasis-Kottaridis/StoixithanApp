//
//  SportsTableViewCell.swift
//  Sports
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit
import Presentation
import Domain

class SportsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var sportHeaderContainer: UIView!
    @IBOutlet weak var sportImg: UIImageView!
    @IBOutlet weak var sportDescLbl: UILabel!
    @IBOutlet weak var rightArrowImg: UIImageView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    // MARK: - Vars
    static let kCONTENT_XIB_NAME = "SportsTableViewCell"
    private var sport: Sport?
    private var isExpanded: Bool = true
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = true
        sportImg.isHidden = true
        sportDescLbl.text = ""
        rightArrowImg.image = UIImage(named: "arrow-up")
    }
    
    func setUpView(sport: Sport) {
        self.sport = sport
        setUpHeaderView(sport: sport)
        setUpCollectionView()
    }
    
    private func setUpHeaderView(sport: Sport) {
        sportHeaderContainer.backgroundColor = ColorPalette.DarkBlue.value
        sportDescLbl.attributedText = sport.description?.with(.style_16_20(weight: .BLACK, color: .White))
        sportImg.isHidden = sport.sportIcon == nil
        sportImg.image = sport.sportIcon
        rightArrowImg.image = UIImage(named: isExpanded ? "arrow-up" : "arrow-down")
    }
    
    private func setUpCollectionView() {
//        eventsCollectionView.isHidden = true
    }
}

// MARK: - EVENTS MODEL UI EXT
fileprivate extension Sport {
    var sportIcon: UIImage? {
        switch self.id {
        case "FOOT":
            return UIImage(named: "soccer")
        case "BASK":
            return UIImage(named: "basketball")
        case "TENN":
            return UIImage(named: "tennis")
        case "TABL":
            return UIImage(named: "table-tennis")
        case "VOLL":
            return UIImage(named: "volleyball")
        case "ESPS":
            return UIImage(named: "video-games")
        case "ICEH":
            return UIImage(named: "ice-hockey")
        case "HAND":
            return UIImage(named: "handball")
        case "SNOO":
            return UIImage(named: "pool-8-ball")
        case "BADM":
            return UIImage(named: "badminton")
        default:
            return nil
        }
    }
}
