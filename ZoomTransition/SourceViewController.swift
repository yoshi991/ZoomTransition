//
//  SourceViewController.swift
//  ZoomTransition
//
//  Created by Henmi Yoshiki on 2019/07/05.
//  Copyright © 2019 yoshi991. All rights reserved.
//

import UIKit

class SourceViewController: UICollectionViewController {

    let photoMax = 35
    let zoomTransition = ZoomTransition()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destinationVC = segue.destination as? DestinationViewController,
            let indexPath = sender as? IndexPath
        else {
            return
        }
        
        destinationVC.indexPath = indexPath
        destinationVC.transitioningDelegate = zoomTransition
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoDestination", sender: indexPath)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoMax
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: String(format: "%03d", indexPath.row))
        cell.label.text = String(format: "Photo-%03d", indexPath.row)
        return cell
    }

}
