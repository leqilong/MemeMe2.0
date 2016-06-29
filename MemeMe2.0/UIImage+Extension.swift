//
//  UIImage+Extension.swift
//  MemeMe2.0
//
//  Created by Leqi Long on 6/7/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit


//func resizeToHeight and func resizeToWidth are to resize the memedImage and get rid of the extra space in pickerImageView when saving the memedImage

extension UIImage{
    func resizeToHeight(imagePickerView: UIImageView)-> UIImage {
        let image = imagePickerView.image!
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat(ceil(imagePickerView.bounds.height/image.size.height * image.size.width)), height: imagePickerView.bounds.height)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imagePickerView.bounds = imageView.bounds
        let view = imagePickerView.superview!
        UIGraphicsBeginImageContext(imageView.frame.size)
        view.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
        
    }
    func resizeToWidth(imagePickerView: UIImageView)-> UIImage {
        let image = imagePickerView.image!
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: imagePickerView.bounds.width, height: CGFloat(ceil(imagePickerView.bounds.width/image.size.width * image.size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imagePickerView.bounds = imageView.bounds
        let view = imagePickerView.superview!
        UIGraphicsBeginImageContext(imageView.frame.size)
        view.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}