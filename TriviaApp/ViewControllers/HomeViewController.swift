//
//  HomeViewController.swift
//  TriviaApp
//
//  Created by AveryW on 5/20/19.
//  Copyright © 2019 Avery. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var difficulty: String = ""
    var pickerString: String = "--SELECT CATEGORY--"
    var pickerId: Int = 0
    var select: String = "--SELECT CATEGORY--"
    let bgColor = UIColor(red: 92/255, green: 2/255, blue: 192/255, alpha: 1)
    let categories:[(name: String, id: Int)] = [
        ("--SELECT CATEGORY--", 100),
        ("Animals", 27),
        ("Any", 0),
        ("Books", 10),
        ("Celebrities", 26),
        ("Computers", 18),
        ("Gadgets", 30),
        ("General", 9),
        ("History", 23),
        ("Mathematics", 19),
        ("Movies", 11),
        ("Music", 12),
        ("Science & Nature", 17),
        ("Sports", 21),
        ("Television", 14),
        ("Video Games", 15)
    ]

    @IBOutlet weak var catPicker: UIPickerView!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var medBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setGradientBackground()
        setupButtons()
        catPicker.delegate = self
        catPicker.dataSource = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        catPicker?.selectRow((Int(INT16_MAX)/(2*categories.count)*categories.count), inComponent: 0, animated: false)
    }
    
    @IBAction func doEasy(_ sender: Any) {
        self.difficulty = "easy"
        getPickerValue()
    }
    
    @IBAction func doMedium(_ sender: Any) {
        self.difficulty = "medium"
        getPickerValue()
    }
    
    @IBAction func doHard(_ sender: Any) {
        self.difficulty = "hard"
        getPickerValue()
    }
    
    func setupButtons(){
        let buttons = [
            self.easyBtn,
            self.medBtn,
            self.hardBtn
        ]
        for button in buttons{
            button?.layer.cornerRadius = 5
            button?.layer.borderWidth = 2
            button?.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func getPickerValue(){
        if (pickerString == select) {
            let alert = UIAlertController(title: "Error", message: "Please Select a Category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "homeToQuiz", sender: nil)
        }
    }
    
    // Set the background as a purple gradient
    func setGradientBackground() {
        let colorTop =  UIColor.black.cgColor
        let colorBottom = bgColor.cgColor//UIColor.purple.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "homeToQuiz") {
            let vc = segue.destination as! QuizViewController
            vc.difficulty = self.difficulty
            vc.categoryId = pickerId
            vc.categoryName = pickerString
        }
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // set for infinite scroll
        return Int(INT16_MAX)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row  = row % categories.count
        pickerString = categories[row].name
        pickerId = categories[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let row  = row % categories.count
        var pickerLabel = view as? UILabel
        if view == nil {
            pickerLabel = UILabel()
            pickerLabel?.layer.borderWidth = 1
            pickerLabel?.layer.borderColor = UIColor.black.cgColor
            //color the background
            pickerLabel?.backgroundColor = bgColor
//            let hue = CGFloat(row)/CGFloat(categories.count)
//            pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = categories[row].name
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 26.0)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        pickerLabel?.attributedText = myTitle
        pickerLabel?.textAlignment = .center
        return (pickerLabel)!
    }
}
