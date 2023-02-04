//
//  SportsLandingVC.swift
//  Sports
//
//  Created by thanos kottaridis on 4/2/23.
//

import UIKit
import Presentation

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
    }
    
    override func populateData() {
        
    }
    
    override func setUpObservers() {
        
    }
    
    private func setUpTableView() {
        
    }
}
