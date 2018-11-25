//
//  RecipeVC.swift
//  EasyEat
//
//  Created by Serhii on 11/25/18.
//  Copyright © 2018 GHW. All rights reserved.
//
import Alamofire
import UIKit

class RecipeVC: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeDescription: UITextView!
    
    var mainFruit: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendRequest()
        // Do any additional setup after loading the view.
    }
    

    func sendRequest() {
        let baseUrl = "http://app2511-1111-easyeat.a3c1.starter-us-west-1.openshiftapps.com/easyeatapp/recipepage.eat?good="
        guard let foodReq = mainFruit else {return}
        let fullUrl = baseUrl + foodReq.lowercased()
        Alamofire.request(fullUrl).responseString { response in
            print("String:\(response.result.value)")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                
                    if self.iSContainsFruit(str: data) {
                        self.recipeImage.image = UIImage(named: "fruits")
                    } else if (self.isContainsVegetables(str: data)) {
                        self.recipeImage.image = UIImage(named: "salat")
                    } else {
                        self.recipeImage.image = UIImage(named: "recipt")
                    }
                    self.recipeDescription.isHidden = false
                }
                
            case .failure(_):
                print("Error message:\(response.result.error)")
                break
            }
        }
    }
    
    func iSContainsFruit(str: String) -> Bool {
        if (str.contains(find: "APPLE")) {
           return true
        }
        if (str.contains(find: "PINEAPPLE")) {
            return true
        }
        if (str.contains(find: "APPLE")) {
            return true
        }
        return false
    }
    
    func isContainsVegetables(str: String) -> Bool {
        if (str.contains(find: "PAPPER")) {
            return true
        }
        if (str.contains(find: "CABBAGE")) {
            return true
        }
        if (str.contains(find: "CUCUMBER")) {
            return true
        }
        return false
    }

}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
