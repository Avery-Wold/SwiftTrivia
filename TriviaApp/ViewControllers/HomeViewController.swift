//
//  HomeViewController.swift
//  TriviaApp
//
//  Created by AveryW on 5/20/19.
//  Copyright © 2019 Avery. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var difficulty: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func doEasy(_ sender: Any) {
        self.difficulty = "easy"
        performSegue(withIdentifier: "homeToQuiz", sender: self)
    }
    
    @IBAction func doMedium(_ sender: Any) {
        self.difficulty = "medium"
        performSegue(withIdentifier: "homeToQuiz", sender: self)
    }
    
    @IBAction func doHard(_ sender: Any) {
        self.difficulty = "hard"
        performSegue(withIdentifier: "homeToQuiz", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "homeToQuiz") {
            let vc = segue.destination as! QuizViewController
            vc.difficulty = self.difficulty
        }

    }

}
