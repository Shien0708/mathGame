//
//  ViewController.swift
//  mathGame
//
//  Created by 方仕賢 on 2022/1/26.
//

import UIKit

var second: Double = 20
var questionCount = 10

class ViewController: UIViewController {
    
    @IBOutlet weak var meteorImageView: UIImageView!
    
    @IBOutlet var numberButtonCollections: [UIButton]!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var questionNumLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var lazerImageView: UIImageView!
    
    @IBOutlet weak var aimImageView: UIImageView!
    
    @IBOutlet weak var timerSlider: UISlider!
    
    @IBOutlet weak var questionCountSlider: UISlider!
    
    @IBOutlet weak var totalSeconds: UILabel!
    
    @IBOutlet weak var totalCounts: UILabel!
    
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var damagePercentLabel: UILabel!
    
    @IBOutlet weak var operationSymbolSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var damagedView: UIView!
    
    @IBOutlet weak var explosionImageView: UIImageView!
    
    @IBOutlet weak var alertImageView: UIImageView!
    
    @IBOutlet weak var wrongImageView: UIView!
    
    @IBOutlet weak var missionImageView: UIImageView!
    
    @IBOutlet weak var accessImageView: UIImageView!
    
    var num1 = 0
    var num2 = 0
    var answerIndex = Int.random(in: 0...3)
    var answer = 0
    
    var timer: Timer?
    var displaySecond = second+1
    var againTimer: Timer?
    var explodeTimer: Timer?
    var wrongTimer: Timer?
    
    var correctCount = 0
    
    var isCorrect = 0
    
    var newX: CGFloat = 0
    var newY: CGFloat = 0
    
    var attackX: CGFloat = 0
    var attackY: CGFloat = 0
    
    var currentQuestion = 0
    var side:CGFloat = 100
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        restart()
    }
    
    @objc func showCompletionImage(){
        
            if correctCount == questionCount {
                missionImageView.image = UIImage(named: "complete")
            } else {
                missionImageView.image = UIImage(named: "failed")
            }
        
       
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.missionImageView.alpha = 0.85
        }
        animator.startAnimation()
    }
    
    func showRedView(){
        wrongTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideRedView), userInfo: nil, repeats: true)
    }
    
    func showAccessImage(){
        
        accessImageView.isHidden = false
        
        if resultLabel.text == "Yes" {
            accessImageView.image = UIImage(named: "accessGranted")
            
        } else {
            accessImageView.image = UIImage(named: "accessDenied")
        }
        
    }
    
    @objc func hideRedView(){
        if wrongImageView.isHidden == true {
            wrongImageView.isHidden = false
        } else {
            wrongImageView.isHidden = true
        }
    }

    func readyExplode(){
        explodeTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(explode), userInfo: nil, repeats: false)
    }
    
    @objc func explode(){
        
        let explosionImage = UIImage.animatedImageNamed("explosion-", duration: 0.7)
        explosionImageView.image = explosionImage
        explosionImageView.transform = CGAffineTransform(translationX: newX, y: newY)
        explosionImageView.isHidden = false
        
        meteorImageView.transform = CGAffineTransform(translationX: newX , y: newY).scaledBy(x: side/100, y: side/100)
    }
    
    func displayAllButtons(isHidden: Bool){
        for i in 0...3 {
            numberButtonCollections[i].isHidden = isHidden
        }
    }
    
    func countDown(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
    }
    
    func meteorPath(){
        newX -= CGFloat(245/second)
        
        newY += CGFloat(195/second)
        
        if isCorrect == 1{
            meteorImageView.transform = CGAffineTransform(translationX: newX , y: newY).scaledBy(x: side/100, y: side/100)
        } else {
            meteorImageView.transform = CGAffineTransform(translationX: newX , y: newY).scaledBy(x:side/100 , y: side/100)
        }
        
        //print("meteorPath:", newX, newY)
    }
    
    @objc func displayTime(){
        meteorPath()
        
        displaySecond -= 1
        
        timeLabel.text = "\(Int(displaySecond))"
        
        if displaySecond == 0 {
            timer?.invalidate()
            gameOver()
            //game over
        }
    }
    
    func gameOver(){
        
        displayAllButtons(isHidden: true)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showCompletionImage), userInfo: nil, repeats: false)
            
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(displayResult), userInfo: nil, repeats: false)
    }
    
    
    func showNextQuestion(){
        displayAllButtons(isHidden: true)
        
        againTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startTheGame(_:)), userInfo: nil, repeats: false)
    }
    
    
    func setAnswerTitle(answerIndex: Int, buttonIndex: Int, answer: Int) {
        if answerIndex == buttonIndex {
            numberButtonCollections[buttonIndex].setTitle("\(answer)", for: .normal)
        } else {
            numberButtonCollections[buttonIndex].setTitle("\(answer+Int.random(in: 1...10))", for: .normal)
        }
    }
    
    @objc @IBAction func startTheGame(_ sender: UIButton) {
        
        if resultLabel.text == "Yes"{
           removeBullet()
            explosionImageView.isHidden = true
        }
        resultLabel.text = ""
        wrongTimer?.invalidate()
        
        num1 = Int.random(in: 0...50)
        num2 = Int.random(in: 0...50)
        
        answerIndex = Int.random(in: 0...3)
        
        countDown()
        
        displayQuestion(isAnswered: false)
        
        for i in 0...3 {
            setAnswerTitle(answerIndex: answerIndex, buttonIndex: i, answer: answer)
        }
        
        currentQuestion += 1
        questionNumLabel.text = "\(currentQuestion) / \(questionCount)"
        
        accessImageView.isHidden = true
        startButton.isHidden = true
        aimImageView.isHidden = true
        settingButton.isHidden = true
        alertImageView.isHidden = false
        
        displayAllButtons(isHidden: false)
        
        let alertImage = UIImage.animatedImageNamed("alert-", duration: 1)
        alertImageView.image = alertImage
        
    }
    
    func checkIsEqual(buttonIndex: Int){
        if buttonIndex == answerIndex {
            isCorrect = 1
            correctCount += 1
            resultLabel.text = "Yes"
           
            side -= side/CGFloat(questionCount)
            
            lazerAnimation()
            readyExplode()
            
        } else {
            isCorrect = 0
           
            resultLabel.text = "Wrong"
           
            showRedView()
        }
    }
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        switch sender {
        case numberButtonCollections[0]:
            checkIsEqual(buttonIndex: 0)
            
        case numberButtonCollections[1]:
            checkIsEqual(buttonIndex: 1)
            
        case numberButtonCollections[2]:
            checkIsEqual(buttonIndex: 2)
            
        default:
            checkIsEqual(buttonIndex: 3)
        }
        
        showAccessImage()
        displayQuestion(isAnswered: true)
        timer?.invalidate()
        
        if questionCount == currentQuestion {
          gameOver()
        } else {
          showNextQuestion()
        }
    }
    
    @objc func displayResult(){
        
        missionImageView.alpha = 0
        resultView.isHidden = false
        gradient.frame = damagedView.bounds

        let damagedPercent:Double = (Double(1)-(Double(correctCount)/Double(questionCount)))*100
        
        print(damagedPercent)
        
        if damagedPercent < 10 {
            
            damagedView.isHidden = true
            
        } else if damagedPercent < 30 {
            
            gradient.colors = [UIColor.yellow.cgColor, UIColor.yellow.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
            
        } else if damagedPercent < 50 {
            
            gradient.colors = [UIColor.orange.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
            
        } else if damagedPercent < 70 {
            
            gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor]
            
        } else {
            gradient.colors = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.orange.cgColor]
        }
        
        damagedView.layer.addSublayer(gradient)
        
        if damagedPercent == 0 {
            
            damagePercentLabel.text = "You saved the earth!"
        } else {
            
            damagePercentLabel.text = "The earth got\n \(Int(damagedPercent)) % damage!"
        }
    }
    
    @IBAction func playAgain(_ sender: Any) {
        if resultLabel.text == "Yes" {
            removeBullet()
        }
        restart()
    }
    
    func restart() {
        
        newX -= newX
        newY -= newY
        resultView.isHidden = true
        settingView.isHidden = true
        startButton.isHidden = false
        aimImageView.isHidden = false
        settingButton.isHidden = false
        alertImageView.isHidden = true
        explosionImageView.isHidden = true
        damagedView.isHidden = false
        accessImageView.isHidden = true
        
        resultLabel.text = ""
        questionLabel.text = ""
        timeLabel.text = ""
        displaySecond = second+1
        questionNumLabel.text = ""
        currentQuestion = 0
        side = 100
        isCorrect = 0
        correctCount = 0
        
        wrongTimer?.invalidate()
        wrongImageView.isHidden = true
       
        meteorImageView.transform = CGAffineTransform(translationX: newX, y: newY)
        
        displayAllButtons(isHidden: true)
    }
    
    @IBAction func set(_ sender: Any) {
        if settingView.isHidden {
            settingView.isHidden = false
        } else {
            settingView.isHidden = true
        }
    }
    
    
    @IBAction func changeValue(_ sender: UISlider) {
        
        timerSlider.value.round()
        questionCountSlider.value.round()
        
        switch sender {
        case timerSlider:
            totalSeconds.text = "\(Int(timerSlider.value))"
            second = Double(timerSlider.value)
            displaySecond = second
            
        default:
            totalCounts.text = "\(Int(questionCountSlider.value))"
            questionCount = Int(questionCountSlider.value)
            
        }
    }
    
    func displayQuestion(isAnswered: Bool) {
        switch operationSymbolSegmentedControl.selectedSegmentIndex {
            
        case 0:
            answer = num1 + num2
            
            if isAnswered == false {
                questionLabel.text = "\(num1) + \(num2) = ?"
            } else {
                questionLabel.text = "\(num1) + \(num2) = \(answer)"
            }
            
        case 1:
            answer = num1 - num2
            
            if isAnswered == false {
                questionLabel.text = "\(num1) − \(num2) = ?"
            } else {
                questionLabel.text = "\(num1) − \(num2) = \(answer)"
            }
            
        case 2:
            answer = num1 * num2
            
            if isAnswered == false {
                questionLabel.text = "\(num1) × \(num2) = ?"
            } else {
                questionLabel.text = "\(num1) × \(num2) = \(answer)"
            }
            
        default:
            if isAnswered == false {
                num1 = Int.random(in: 50...100)
                answer = num1/num2
                questionLabel.text = "\(num1) ÷ \(num2) = ?"
            } else {
                
                questionLabel.text = "\(num1) ÷ \(num2) = \(answer)"
            }
        }
    }
    
    func removeBullet(){
        attackX += (390-(570+newX)-(75-(75*self.side/100)))
        attackY += (345-(newY-25)-(75-(75*self.side/100)))
        print(side)
        print(newX, newY)
        lazerImageView.transform = CGAffineTransform(translationX: CGFloat(attackX), y: CGFloat(attackY))
    }
    
    func lazerAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.lazerImageView.frame = self.lazerImageView.frame.offsetBy(dx: (570+self.newX)-390+(75-(75*self.side/100)), dy: (-25+self.newY)-345+(75-(75*self.side/100)))
        }
        
        animator.startAnimation()
        
        
    }

}

