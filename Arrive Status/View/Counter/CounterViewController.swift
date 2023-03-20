//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit

class CounterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Counter"
    }
    
    @IBAction func addDestinationButtonPressed(_ sender: Any) {
        print("!@Naar de nieuwe view")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDestinationViewController") as! AddDestinationViewController
//                navigationController?.pushViewController(vc, animated: true)
    }
}
