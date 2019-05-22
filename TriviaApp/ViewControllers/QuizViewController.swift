//
//  ViewController.swift
//  TriviaApp
//
//  Created by AveryW on 5/15/19.
//  Copyright © 2019 Avery. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    struct Question: Codable {
        let question: String
        let incorrectAnswers: [String]
        let correctAnswer: String
        
        init(_ dictionary: [String: Any]) {
            question = dictionary["question"] as! String
            incorrectAnswers = dictionary["incorrect_answers"] as! [String]
            correctAnswer = dictionary["correct_answer"] as! String
        }
    }
    
    var vSpinner: UIView?
    var questions: [Question] = []
    var difficulty: String = ""
    var categoryName: String = ""
    var categoryId: Int = 0
    var currentQuestion: Question?
    var currentQuestionPos = 0
    var noCorrect = 0
    var allAnswers: Array<String> = []
    var urlString: String = ""
    let bgColor = UIColor(red: 92/255, green: 2/255, blue: 192/255, alpha: 1)

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var answer0: UIButton!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var lblProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "\(categoryName.capitalized) Questions"
        btnSetup()
        self.showSpinnter(onView: self.view)
        getQuestionsFromJson()
        setGradientBackground()
    }
    
    @IBAction func submitAnswer0(_ sender: Any) {
        checkAnswer(idx: self.answer0.currentTitle!.htmlDecoded)
    }

    @IBAction func submitAnswer1(_ sender: Any) {
        checkAnswer(idx: self.answer1.currentTitle!.htmlDecoded)
    }

    @IBAction func submitAnswer2(_ sender: Any) {
        checkAnswer(idx: self.answer2.currentTitle!.htmlDecoded)
    }

    @IBAction func submitAnswer3(_ sender: Any) {
        checkAnswer(idx: self.answer3.currentTitle!.htmlDecoded)
    }
    
    // Check if an answer is correct then load the next question
    func checkAnswer(idx: String) {
        if(idx == currentQuestion!.correctAnswer) {
            noCorrect += 1
        }
        loadNextQuestion()
    }
    
    func getQuestionsFromJson(){
        if(categoryId == 0){
            urlString = "https://opentdb.com/api.php?amount=10&difficulty=\(difficulty)&type=multiple"
        }
        else {
            urlString = "https://opentdb.com/api.php?amount=10&category=\(categoryId)&difficulty=\(difficulty)&type=multiple"
        }
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {
                guard let json = try
                    JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                
                let responseCode = json["response_code"] as! Int
                let questions = json["results"] as? [[String: Any]]

                if(questions?.isEmpty == false || responseCode == 0){
                    for question in questions! {
                        self.questions.append(Question(question))
                    }
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.currentQuestion = self.questions[0]
                        self.setQuestion()
                    }
                } else {
                    self.removeSpinner()
                    let alert = UIAlertController(title: "OOPS", message: "Category was not found, please try a different one", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.performSegue(withIdentifier: "tryAgain", sender: self)}))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
        }.resume()
    }
    
    func loadNextQuestion() {
        // Show next question
        if(currentQuestionPos + 1 < questions.count) {
            currentQuestionPos += 1
            currentQuestion = questions[currentQuestionPos]
            setQuestion()
            // If there are no more questions show the results
        } else {
            performSegue(withIdentifier: "showResults", sender: nil)
        }
    }
    
    // Set labels and buttions for the current question
    func setQuestion() {
        let decodedString = currentQuestion!.question.description.htmlDecoded
        lblQuestion.text = decodedString //currentQuestion!.question
        self.allAnswers.append(self.currentQuestion?.correctAnswer ?? "")
        for iAnswer in self.currentQuestion?.incorrectAnswers ?? [""]{
            self.allAnswers.append(iAnswer)
        }
        let buttons = [
            self.answer0,
            self.answer1,
            self.answer2,
            self.answer3
        ]
        for button in buttons{
            let index = Int(arc4random_uniform(UInt32(self.allAnswers.count)))
            button?.setTitle((self.allAnswers[index].htmlDecoded), for: .normal)
            self.allAnswers.remove(at: index)
        }
        lblProgress.text = "\(currentQuestionPos + 1) / \(questions.count)"
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
    
    // Set up spinner view
    func showSpinnter(onView: UIView){
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner(){
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    // Set up answer buttons
    func btnSetup(){
        let buttons = [
            self.answer0,
            self.answer1,
            self.answer2,
            self.answer3
        ]
        for button in buttons {
            button?.layer.backgroundColor = bgColor.cgColor
            button?.layer.cornerRadius = 5
            button?.layer.borderWidth = 2
            button?.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // Before we move to the results screen pass the how many we got correct, and the total number of questions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showResults") {
            let vc = segue.destination as! ResultsViewController
            vc.noCorrect = noCorrect
            vc.total = questions.count
        }
    }
}
