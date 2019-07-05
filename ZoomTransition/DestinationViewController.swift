//
//  DestinationViewController.swift
//  ZoomTransition
//
//  Created by Henmi Yoshiki on 2019/07/05.
//  Copyright © 2019 yoshi991. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: String(format: "%03d", indexPath.row))
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
