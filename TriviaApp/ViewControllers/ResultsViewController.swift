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

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startOver") {
            _ = segue.destination as! HomeViewController
        }
    }

}
