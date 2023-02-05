//
//  SportsTableViewCell.swift
//  Sports
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit
import Domain
import Presentation
import RxSwift
import RxCocoa
import RxDataSources

class SportsTableViewCell: UITableViewCell {
    
    // MARK: - Vars
    static let kCONTENT_XIB_NAME = "SportsTableViewCell"
    private var sportObserver = PublishSubject<Sport>()
    
    // MARK: - Outlets
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        setUpCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setUpView(sport: Sport) {
        sportObserver.onNext(sport)
    }
    
    private func setUpCollectionView() {
        eventsCollectionView.register(
            UINib(
                nibName: EventCollectionViewCell.kCONTENT_XIB_NAME,
                bundle: Bundle(for: EventCollectionViewCell.self)
            ),
            forCellWithReuseIdentifier: EventCollectionViewCell.kCONTENT_XIB_NAME
        )
 
        sportObserver.observe(on: MainScheduler.instance)
            .map{ $0.events ?? [] }
            .distinctUntilChanged()
            .bind(to: eventsCollectionView.rx.items(
                cellIdentifier: EventCollectionViewCell.kCONTENT_XIB_NAME,
                cellType: EventCollectionViewCell.self
            )) { indexPath, item, cell in
                cell.setUpCell(event: item)
            }.disposed(by: rx.disposeBag)
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
