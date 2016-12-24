//
//  P9SImageViewCell.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/18/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SImageViewerCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var parentViewController: P9SImageViewerController!
    
    func setUpCell(tempPhoto : UIImage)
    {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = tempPhoto
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.clipsToBounds = false
        self.scrollView.decelerationRate = 0.0
        self.scrollView.backgroundColor = UIColor.clear
        // 100 is aribitray. works well.
        self.scrollView.maximumZoomScale = 100.0
        self.scrollView.zoomScale = 1.0
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapRecognizer)
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        self.scrollView.addGestureRecognizer(singleTapRecognizer)
    }

    func handleSingleTap()
    {
        self.parentViewController.navigationController?.navigationBar.isHidden = !(self.parentViewController.navigationController?.navigationBar.isHidden)!
        self.parentViewController.navigationController?.navigationBar.isTranslucent = !(self.parentViewController.navigationController?.navigationBar.isTranslucent)!
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer)
    {
        if self.scrollView.zoomScale != 1.0 {
            self.scrollView.setZoomScale(1.0, animated: true)
        } else {
            
            var zoomRect = CGRect()
            // create 3X zoom centered at the point touched. 3 is arbitrary and could be changed.
            zoomRect.size.height = self.imageView.frame.size.height / 3.0
            zoomRect.size.width = self.imageView.frame.size.width / 3.0
            
            let center = self.imageView.convert(recognizer.location(in: self.scrollView), to: self.scrollView)
            
            zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
            zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
            
            self.scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    

    func viewForZooming(in:UIScrollView) -> UIView?
    {
        return self.imageView
    }
    
    override func prepareForReuse()
    {
        self.imageView.image  = UIImage()
        super.prepareForReuse()
    }

}
