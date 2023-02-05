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

protocol SportsTableViewCellDelegate: AnyObject {
    func didEventsCVOffsetChange(sportId: String, contentOffcet: CGPoint)
    func getCVOffset(by sportId: String) -> CGPoint?
}

class SportsTableViewCell: UITableViewCell {
    
    // MARK: - Vars
    static let kCONTENT_XIB_NAME = "SportsTableViewCell"
    private var sportId : String?
    private var sportObserver = PublishSubject<Sport>()
    // TODO: - Remove this callback since we have delegate.
    private var callback: ChangeFavoriteStateCallback?
    weak var delegate: SportsTableViewCellDelegate?

    // MARK: - Outlets
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        contentView.backgroundColor = ColorPalette.LightGray.value
        setUpCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sportId = nil
        eventsCollectionView.contentOffset = CGPoint(x: 0, y: 0)
        print("ContntOffset Debug: .... prepareForReuse called with offset \(eventsCollectionView.contentOffset)")
    }
    
    func setUpView(
        sport: Sport,
        callback: @escaping ChangeFavoriteStateCallback
    ) {
        self.callback = callback
        self.sportId = sport.id
        
        print("ContntOffset Debug: .... set up view called with \(sportId) and delegate \(delegate)")
        // fix collection view offset.
        fixCollectionViewOffset()
    
        sportObserver.onNext(sport)
    }
    
    private func setUpCollectionView() {
        eventsCollectionView.layer.cornerRadius = CGFloat(12).adaptedCGFloat()
        eventsCollectionView.delegate = self
        eventsCollectionView.clipsToBounds = true
        eventsCollectionView.register(
            UINib(
                nibName: EventCollectionViewCell.kCONTENT_XIB_NAME,
                bundle: Bundle(for: EventCollectionViewCell.self)
            ),
            forCellWithReuseIdentifier: EventCollectionViewCell.kCONTENT_XIB_NAME
        )
 
        sportObserver.observe(on: MainScheduler.instance)
            .map{ $0.sortedEvents }
            .distinctUntilChanged()
            .bind(to: eventsCollectionView.rx.items(
                cellIdentifier: EventCollectionViewCell.kCONTENT_XIB_NAME,
                cellType: EventCollectionViewCell.self
            )) {[weak self] indexPath, item, cell in
                cell.setUpCell(event: item, callback: self?.callback)
            }.disposed(by: rx.disposeBag)
    }
    
    private func fixCollectionViewOffset() {
        // updatem eventsCollectionView contentOffset
        // if previous offset for collection view provided
        if let sportId = sportId,
           let cvOffset = delegate?.getCVOffset(by: sportId) {
            print("ContntOffset Debug: .... fixCollectionViewOffset called with \(sportId) and offset \(cvOffset)")
            eventsCollectionView.contentOffset = cvOffset
        }
    }
}

// MARK: - CollectionView Delegate
extension SportsTableViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let id = sportId
        else { return }
        
        delegate?.didEventsCVOffsetChange(
            sportId: id,
            contentOffcet: eventsCollectionView.contentOffset
        )
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
    
    var sortedEvents: [Domain.Event] {
//        return self.events?.sorted { (object1, object2) -> Bool in
//            return (object1.timestamp ?? 0) > (object2.timestamp ?? 0)
//        } ?? []
        
        return self.events?.sorted { (object1, object2) -> Bool in
            if object1.isFavorite != object2.isFavorite {
                return object1.isFavorite && !object2.isFavorite
            } else {
                return (object1.timestamp ?? Int.min) > (object2.timestamp ?? Int.min)
            }
        } ?? []
    }
}
