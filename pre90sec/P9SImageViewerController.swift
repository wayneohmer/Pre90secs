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
                    self.partentController.images.remove(at: indexPath.row)
                    self.collectionView?.reloadData()
                    do {
                        try FileManager.default.removeItem(at: self.partentController.images[indexPath.row].url)
                    } catch {
                        print("remove file failed")
                    }
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(alertController, animated: true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
