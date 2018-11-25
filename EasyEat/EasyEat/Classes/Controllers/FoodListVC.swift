//
//  FoodListVC.swift
//  EasyEat
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 GHW. All rights reserved.
//

import UIKit
import Alamofire

class FoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var filter = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let food = foodList else {return 1}
        return food.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result" {
            if let nextViewController = segue.destination as? RecipeVC {
                nextViewController.mainFruit = foodList?.first
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as UITableViewCell
        guard let food = foodList else {return cell}
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        cell.textLabel?.text = food[indexPath.row]
        return cell
    }
    
    
    var foodList: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.0)
        // Do any additional setup after loading the view.
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Food prefear", message: "Hello World", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Weight loss", style: .default, handler: nil)
        let action2 = UIAlertAction(title: "Be strong", style: .default, handler: nil)
        let action3 = UIAlertAction(title: "Yealthy style", style: .default, handler: nil)
        let action4 = UIAlertAction(title: "Gluten free", style: .default, handler: nil)
        let action5 = UIAlertAction(title: "Lactose free", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func findReciptsTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "result", sender: self)
    }
    
    
    

}
