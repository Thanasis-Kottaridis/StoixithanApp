//
//  TestVC.swift
//  CleanArchitectureTemplate
//
//  Created by thanos kottaridis on 1/2/23.
//

import UIKit
import Presentation
import RxSwift
import RxCocoa

class TestVC: BaseVC {

    private let viewModel: TestViewModel
    
    @IBOutlet weak var iAmHereLbl: UILabel!
    @IBOutlet weak var goToTestCTA: UIButton!
    @IBOutlet weak var getEventsCTA: UIButton!
    @IBOutlet weak var updateFavorite: UIButton!
    
    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        iAmHereLbl.attributedText = "I'am Here".with(.style_20_28(weight: .BOLD))
    }
    
    override func setUpObservers() {
        goToTestCTA.rx.tap.bind { [weak self] in
            self?.viewModel.onTriggeredEvent(event: .goToTest)
        }.disposed(by: rx.disposeBag)
        
        getEventsCTA.rx.tap.bind { [weak self] in
            self?.viewModel.onTriggeredEvent(event: .getEvents)
        }.disposed(by: rx.disposeBag)
        
        updateFavorite.rx.tap.bind { [weak self] in
            self?.viewModel.onTriggeredEvent(event: .updateFavorite)
        }.disposed(by: rx.disposeBag)
    }
}
