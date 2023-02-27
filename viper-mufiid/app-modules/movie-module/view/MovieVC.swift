//
//  MovieVC.swift
//  viper-mufiid
//
//  Created by dios on 27/02/23.
//

import UIKit

class MovieVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var myTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = myTitle
    }

}
