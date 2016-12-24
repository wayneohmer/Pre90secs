//
//  P9SImageViewerController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/18/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageViewer"

class P9SImageViewerController: UICollectionViewController {

    
    var partentController:P9SImageController!
    var selectedPhotoIndex:IndexPath?
    var cellHidden = true

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flowLayout.itemSize = self.collectionView!.frame.size
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        self.collectionView?.scrollToItem(at: selectedPhotoIndex!, at: .centeredHorizontally, animated: false)
        self.cellHidden = false
        self.collectionView?.reloadInputViews()
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trashTouched(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "You Sure?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { alertAction in
            if let cell = self.collectionView?.visibleCells[0] as? P9SImageViewerCell {
                if let indexPath = self.collectionView?.indexPath(for: cell) {
                    let removeUrl = self.partentController.images[indexPath.row].url
                    self.partentController.images.remove(at: indexPath.row)
                    self.collectionView?.reloadData()
                    do {
                        try FileManager.default.removeItem(at: removeUrl)
                        P9SGlobals.progressImageDates.removeValue(forKey: removeUrl.lastPathComponent)
                    } catch {
                        print("remove file failed")
                    }
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.partentController.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! P9SImageViewerCell
    
        cell.setUpCell(tempPhoto: self.partentController.images[indexPath.item].image)
        cell.parentViewController = self
        cell.isHidden = cellHidden
        return cell
    }

}
