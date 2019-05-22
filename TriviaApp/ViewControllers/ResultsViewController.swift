//
//  ResultsViewController.swift
//  TriviaApp
//
//  Created by AveryW on 5/15/19.
//  Copyright © 2019 Avery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var goBack: UIButton!
    
    var noCorrect = 0
    var total = 0
    let bgColor = UIColor(red: 92/255, green: 2/255, blue: 192/255, alpha: 1)

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        setGradientBackground()
        displaySetup()
        resultSetup()
    }
    
    func displaySetup(){
        goBack.layer.backgroundColor = bgColor.cgColor
        goBack.layer.borderWidth = 2
        goBack.layer.cornerRadius = 5
        goBack.layer.borderColor = UIColor.black.cgColor
    }
    
    func resultSetup(){
        // Set Button title
        goBack.setTitle("Play Again", for: .normal)
        // Set the results
        lblResults.text = "You got \(noCorrect) out of \(total) correct"
        // Calculate the percentage of quesitons you got right
        var percentRight = Double(noCorrect) / Double(total)
        percentRight *= 100
        // Based on the percentage of questions you got right present the user with different message
        var title = ""
        if(percentRight < 40) {
            title = "Not Good"
        } else if(percentRight < 70) {
            title = "Almost"
        } else {
            title = "Good Job"
        }
        lblTitle.text = title
    }
    
    @IBAction func btnAgain(_ sender: Any) {
        performSegue(withIdentifier: "startOver", sender: self)
    }
    
    // Set the background as a purple gradient
    func setGradientBackground() {
        let colorTop =  UIColor.black.cgColor
        let colorBottom = bgColor.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startOver") {
            _ = segue.destination as! HomeViewController
        }
    }

}
