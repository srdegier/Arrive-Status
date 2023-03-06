//
//  ViewController.swift
//  Arrive Status
//
//  Created by Stefan de Gier on 02/03/2023.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var destinationCounterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.destinationCounterCollectionView.dataSource = self
    }
    
}

extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = destinationCounterCollectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCounterCollectionViewCell", for: indexPath) as! DestinationCounterCollectionViewCell
        return cell
    }

}
