//
//  CatDetailController.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit

class CatDetailController: UIViewController {
    
    var coordinator:MainCoordinator?
    private var viewModel = CatDetailViewModel()
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func setUp(with cat:Cat) {
        viewModel.cat = cat
    }
    
    func  configureUI() {
        if let url = viewModel.catURL {
               catImageView.setImage(with: url)
        }
    }
}
