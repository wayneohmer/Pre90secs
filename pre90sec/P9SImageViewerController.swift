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
