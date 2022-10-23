//
//  ViewController.swift
//  VaryForTraits
//
//  Created by Berksu Kısmet on 2.10.2022.
//

import UIKit

class ViewController: UIViewController {
    let specialCharacters = ["log_10", "cos", "sin", "tan", "AC","log_e","π", "e"]
    
    // Define Outlets
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var mathStack1: UIStackView!
    
    //Define Model
    var model = CalculatorOperator()
    
    //Controlling User Situation
    var isInTheMiddleOfTyping = false
    var isTheLastOperationEnd = false
    var userOperations: String = "" {
        didSet{
            history.text = userOperations
        }
    }
    
    var displayText: Double{
        get{
            return Double(result.text!)!
        }
        set{
            result.text! = String(newValue)
        }
    }
    
    
    // MARK: - Add more buttons if device orientation is landscape
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    // detect the transition and adjest the buttons
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustShownButton()
    }
    
    
    // control the device orientation at the beginning
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let orientation = self.view.window?.windowScene?.interfaceOrientation {
            let landscape = orientation == .landscapeLeft || orientation == .landscapeRight
            if landscape{
                mathStack1.isHidden = false
            }else{
                mathStack1.isHidden = true
            }
        }
    }
    
    // This button adjust the buttons that shown on the view related to device orientation
    func adjustShownButton(){
        if UIDevice.current.orientation.isLandscape {
            mathStack1.isHidden = false
        } else {
            mathStack1.isHidden = true
        }
    }
}



// MARK: - User Intents
extension ViewController{
    
    @IBAction func numberButtons(_ sender: UIButton) {
        if let pressedDigit = sender.currentTitle{
            // If user press the number buttons in a sequence, append the digits
            if isInTheMiddleOfTyping{
                result.text! += pressedDigit
            }else{
                // If user press the number buttons fistly, take only this number
                result.text = pressedDigit
                isInTheMiddleOfTyping = true
            }
            
            // If user press "=", clear history
            if isTheLastOperationEnd {
                //userOperations = " "
                isTheLastOperationEnd = false
            }
        }
    }

    func clearAll(){
        result.text = "0"
        userOperations = " "
        model.setCalculation(0)
    }
    
    @IBAction func operandButton(_ sender: UIButton) {
        if result.text == "nan" || result.text == "-inf" || result.text == "inf"{
            clearAll()
            return
        }
        
        if isInTheMiddleOfTyping {
            model.setCalculation(displayText)
            isInTheMiddleOfTyping = false
        }
        
        if let pressedOperand = sender.currentTitle {
            // If user press "AC", remove everyting
            if pressedOperand == "AC"{
                clearAll()
                return
            }else{
                
                //Control whether the value is constant or not. If it is constant, show the value of this constant
                if let value = model.getContantValue(for: pressedOperand){
                    result.text = value
                }else{
                    // If user pressed "=", continue with this state
                    if isTheLastOperationEnd{
                        if let calc = model.calculation {
                            userOperations = "\(calc)"
                            if !specialCharacters.contains(pressedOperand){
                                userOperations += " "  +  pressedOperand
                            }
                        }
                    }else{
                        if((userOperations.contains("+") || userOperations.contains("-") ) && (pressedOperand == "x" || pressedOperand == "÷")){
                            // for operation priority, add some paranthesis
                            userOperations = "(" + userOperations + " " + result.text! + ") " +  pressedOperand
                        }else if !specialCharacters.contains(pressedOperand) {
                            userOperations += result.text! + " " + pressedOperand
                        }
                        
                    }
                }

                //Do the operation
                model.doMathematicalOperations(pressedOperand)
                
                //If user press "=", finish the sequence
                if pressedOperand == "="{
                    isTheLastOperationEnd = true
                }
            }
        }
        
        // After the calculations, update the result
        if let result = model.calculation{
            displayText = result
        }
    }
    
}
