//
//  P9SImageController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/17/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import Photos


class P9SImageController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    struct ImageStruct {
        var image:UIImage
        var url:URL
    }
    
    var images = [ImageStruct]()
    var selectedIndex = IndexPath()
    var imageDirectory = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
    var isProgressImages = false

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageDirectory = self.isProgressImages ? "\(self.imageDirectory)/progressImages" : "\(self.imageDirectory)/inspirationalImages"
        do {
            let imageFiles = try FileManager.default.contentsOfDirectory(atPath: imageDirectory)
            for imagefile in imageFiles {
                do {
                    let thisUrl = URL(fileURLWithPath:"\(imageDirectory)/\(imagefile)")
                    let thisImageData = try Data.init(contentsOf: thisUrl)
                    if let thisImage = UIImage(data:thisImageData) {
                        images.append(ImageStruct(image: thisImage, url: thisUrl))
                    }
                    
                } catch {
                    print("\(imagefile)")
                }
            }
            
        } catch {
            
        }
        let screenWidth = self.view.bounds.width - CGFloat((4)*2)
        let cellWidth = CGFloat(screenWidth/3)
        
        self.flowLayout.itemSize = self.isProgressImages ? CGSize(width:cellWidth, height:cellWidth+40) : CGSize(width:cellWidth, height:cellWidth)
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }

    @IBAction func plusTouched(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
        
        func launchPicker(sourceType:UIImagePickerControllerSourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { alertAction in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                launchPicker(sourceType: .camera)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose Photo From Library", style: .default, handler: { alertAction in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                launchPicker(sourceType: .photoLibrary)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender.value(forKey: "view") as! UIView?
            popoverController.sourceRect = (popoverController.sourceView?.bounds)!
        }
        self.present(alertController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fileUrl = URL(fileURLWithPath: "\(imageDirectory)/\(Int(Date().timeIntervalSince1970*100))")
            let pickImageData = UIImageJPEGRepresentation(pickedImage, 1)
            do {
                try pickImageData?.write(to: fileUrl)
                self.images.append(ImageStruct(image: pickedImage, url:fileUrl))
                if isProgressImages {
                    P9SGlobals.progressImageDates[fileUrl.lastPathComponent] = Date()
                }
                self.collectionView?.reloadData()

            } catch {
                print("could not save image")
            }
            
            if let asset = info[UIImagePickerControllerPHAsset] as?  PHAsset {
                if let takeTaken = asset.creationDate {
                    P9SGlobals.progressImageDates[fileUrl.lastPathComponent] = takeTaken
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PhotoTouched" {
            let vc = segue.destination as! P9SImageViewerController
            vc.selectedPhotoIndex = self.selectedIndex
            vc.partentController = self
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isProgressImages {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Progress", for: indexPath) as! P9SProgressImageCell
            cell.imageView.image = self.images[indexPath.item].image;
            cell.fileName = self.images[indexPath.item].url.lastPathComponent
            cell.dateField.text = P9SGlobals.progressImageDates[cell.fileName]?.shortFormatted()
            return cell

        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Inspiration", for: indexPath) as! P9SImageCell
            
            cell.imageView.image = self.images[indexPath.item].image;
            return cell

        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: "PhotoTouched", sender: nil)
    }

}
