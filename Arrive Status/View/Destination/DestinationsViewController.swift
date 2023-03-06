//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit

class DestinationsViewController: UIViewController {
    
    @IBOutlet weak var destinationCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Destinations"
        self.destinationCollectionView.dataSource = self
    }
    
    @IBAction func addDestinationButtonPressed(_ sender: Any) {
        print("!@Naar de nieuwe view")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDestinationViewController") as! AddDestinationViewController
                navigationController?.pushViewController(vc, animated: true)
    }
}

extension DestinationsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = destinationCollectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCollectionViewCell", for: indexPath) as! DestinationCollectionViewCell
        return cell
    }

}
