//
//  EventDetailsVC.swift
//  Sports
//
//  Created by thanos kottaridis on 12/2/23.
//

import UIKit
import Presentation

class EventDetailsVC: BaseVC {

    private let viewModel: EventDetailsViewModel

    
    init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: type(of: self)),
            bundle: Bundle(for: type(of: self))
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
