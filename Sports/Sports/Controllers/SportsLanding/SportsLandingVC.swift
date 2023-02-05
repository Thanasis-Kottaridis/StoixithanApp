//
//  SportsLandingVC.swift
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

class SportsLandingVC: BaseVC {
    
    private let viewModel: SportsLandingViewModel
    
    // MARK: - Outlets
    
    @IBOutlet weak var genericHeader: UIView!
    @IBOutlet weak var sportsTV: UITableView!
    
    init(viewModel: SportsLandingViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: type(of: self)),
            bundle: Bundle(for: type(of: self))
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        genericHeader.backgroundColor = ColorPalette.RegularBlue.value
        
        setUpTableView()
    }
    
    override func populateData() {
        viewModel.onTriggeredEvent(event: .fetchData)
    }
    
    override func setUpObservers() {
        
        let sportsDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Sport>> { _, tableView, indexPath, element in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SportsTableViewCell.kCONTENT_XIB_NAME,
                for: indexPath
            ) as? SportsTableViewCell else {
                fatalError("Cant dequeueReusableCell")
            }
            cell.selectionStyle = .none
            cell.setUpView(sport: element) { [weak self] eventId, isFavorite in
                self?.viewModel.onTriggeredEvent(event: .selectFavoriteEvent(
                    eventId: eventId,
                    isFavorite: isFavorite
                ))
            }
            return cell
        }
        
        viewModel.stateObserver
            .map { newState -> [SectionModel<String, Sport>] in
                return newState.sportsListDisplayable
            }
            .distinctUntilChanged()
            .bind(to: sportsTV.rx.items(dataSource: sportsDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func setUpTableView() {
        sportsTV.separatorStyle = .none
        sportsTV.backgroundColor = ColorPalette.LightGray.value
        
        if #available(iOS 15.0, *) {
            sportsTV.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        sportsTV.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        // register header
        sportsTV.register(
            UINib(
                nibName: SportsTableViewHeader.kCONTENT_XIB_NAME,
                bundle: Bundle(for: SportsTableViewHeader.self)
            ),
            forHeaderFooterViewReuseIdentifier: SportsTableViewHeader.kCONTENT_XIB_NAME
        )
        
        // register cell
        sportsTV.register(
            UINib(
                nibName: SportsTableViewCell.kCONTENT_XIB_NAME,
                bundle: Bundle(for: SportsTableViewCell.self)
            ), forCellReuseIdentifier: SportsTableViewCell.kCONTENT_XIB_NAME
        )
    }
}

// MARK: - TableView Delegate
extension SportsLandingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sport = viewModel.state.value.spotrsList[safe: section],
              let sportId = sport.id
        else { return nil }
        let isExpanded = !viewModel.state.value.collapsedSports.contains(key: sportId)
        
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SportsTableViewHeader.kCONTENT_XIB_NAME
        ) as? SportsTableViewHeader
        else { return nil }
        
        view.setUpView(sport: sport, isExpand: isExpanded, delegate: self)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(48).adaptedCGFloat()
    }
}

// MARK: - Sport Header Delegate
extension SportsLandingVC: SportsTableViewHeaderDelegate {
    func didChangeExpandState(sport: Domain.Sport, isExpand: Bool) {
        viewModel.onTriggeredEvent(event: .collapseSport(sport: sport, isExpand: isExpand))
    }
}
