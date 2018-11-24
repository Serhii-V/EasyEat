//
//  StartVC.swift
//  EasyEat
//
//  Created by Serhii on 11/23/18.
//  Copyright © 2018 GHW. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
