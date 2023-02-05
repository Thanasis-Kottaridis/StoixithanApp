//
//  SportsTableViewHeader.swift
//  Sports
//
//  Created by thanos kottaridis on 5/2/23.
//

import UIKit
import Domain
import Presentation

protocol SportsTableViewHeaderDelegate: AnyObject {
    func didChangeExpandState(sport: Sport, isExpand: Bool)
}

class SportsTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Outlets
    @IBOutlet weak var sportHeaderContainer: UIView!
    @IBOutlet weak var sportImg: UIImageView!
    @IBOutlet weak var sportDescLbl: UILabel!
    @IBOutlet weak var rightArrowImg: UIImageView!

    // MARK: - Vars
    static let kCONTENT_XIB_NAME = "SportsTableViewHeader"
    private weak var delegate: SportsTableViewHeaderDelegate?
    private var isExpand: Bool = true
    private var sport: Sport?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpand = true
        sportImg.isHidden = true
        sportDescLbl.text = ""
        rightArrowImg.image = UIImage(named: "arrow-down")
    }
    
    func setUpView(
        sport: Sport,
        isExpand: Bool,
        delegate: SportsTableViewHeaderDelegate
    ) {
        self.sport = sport
        self.isExpand = isExpand
        self.delegate = delegate
        setUpHeaderView(sport: sport)
    }
    
    private func setUpHeaderView(sport: Sport) {
        sportHeaderContainer.backgroundColor = ColorPalette.DarkBlue.value
        sportDescLbl.attributedText = sport.description?.with(.style_16_20(
            weight: .BLACK,
            color: .White
        ))
        sportImg.isHidden = sport.sportIcon == nil
        sportImg.image = sport.sportIcon
        setUpArrowImg()
        
        rightArrowImg.addTapGestureRecognizer { [weak self] in
            guard let self = self,
                  let sport = self.sport
            else { return }
            self.isExpand.toggle()
            self.setUpArrowImg()
            self.delegate?.didChangeExpandState(sport: sport, isExpand: self.isExpand)
        }
    }
    
    private func setUpArrowImg() {
        rightArrowImg.image = UIImage(named: isExpand ? "arrow-down" : "arrow-up")

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
