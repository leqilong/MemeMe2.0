//
//  FontsPickerViewController.swift
//  MemeMe1.0
//
//  Created by Leqi Long on 6/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit


protocol FontsPickerViewControllerDelegate{
    func userSelectedFont(fontName: String)
}


class FontsPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var fontsData = [
        "HelveticaNeue-CondensedBlack",
        "Superclarendon-Bold",
        "TimesNewRomanPS-BoldMT",
        "AmericanTypewriter-Condensed",
        "GillSans-Bold",
        "IowanOldStyle-Bold"
    ]
    
    
// MARK -Outlets and properties
    @IBOutlet weak var fontsPicker: UIPickerView!
    @IBOutlet weak var selectedFontLabel: UILabel!
    
    var delegate: FontsPickerViewControllerDelegate?
    var savedFont: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontsPicker.delegate = self
        fontsPicker.dataSource = self
        
        selectedFontLabel.text = savedFont
        
        fontsPicker.selectRow(0, inComponent: 0, animated: false)
        updateSelectedFontLabel()
    }
 
    
// MARK -Delegates and data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontsData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontsData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateSelectedFontLabel()
    }
    
    func updateSelectedFontLabel(){
        let font = fontsData[fontsPicker.selectedRowInComponent(0)]
        selectedFontLabel.font = UIFont(name: font, size: 20)
        selectedFontLabel.text! = font
        delegate?.userSelectedFont(selectedFontLabel.text!)
    }
    
    @IBAction func chooseFont(sender: AnyObject) {
        if (self.delegate != nil){
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
