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
            cell.setUpView(sport: element)
            return cell
        }
        
        viewModel.stateObserver
            .map { newState -> [SectionModel<String, Sport>] in
                return [SectionModel(model: "section_const", items: newState.spotrsList)]
            }
            .distinctUntilChanged()
            .bind(to: sportsTV.rx.items(dataSource: sportsDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func setUpTableView() {
        sportsTV.separatorStyle = .none
        sportsTV.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        sportsTV.register(
            UINib(
                nibName: SportsTableViewCell.kCONTENT_XIB_NAME,
                  bundle: Bundle(for: SportsTableViewCell.self)
            ), forCellReuseIdentifier: SportsTableViewCell.kCONTENT_XIB_NAME
        )
    }
}

extension SportsLandingVC: UITableViewDelegate {
    
}
