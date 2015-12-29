//
//  ViewController.swift
//  Calculator
//
//  Created by Patrick Mumme on 5/1/15.
//  Copyright (c) 2015 Patrick Mumme. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var opHistory: UILabel!
    
    private var userInputInProgress = false
    private var enterPressed = false
    private var brain = CalculatorBrain()
    private var displayValue: Double? {
        get{
            if !display.text!.isEmpty {
                if let number = NSNumberFormatter().numberFromString(display.text!) {
                    return number.doubleValue
                }
            }
            return nil
        }
        set{
            if let value = newValue {
                self.display.text! = "\(value)"
            } else {
                self.display.text = " "
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func appendDigit(sender: UIButton) {
        if userInputInProgress {
            display.text! += sender.currentTitle!
        } else {
            display.text! = sender.currentTitle!
            userInputInProgress = true
            enterPressed = false
        }
    }

    @IBAction func clearCalculator() {
        display.text! = "0"
        opHistory.text! = ""
        userInputInProgress = false
        enterPressed = false
        brain.clearBrain()
    }
    
    
    @IBAction func enter() {
        userInputInProgress = false
        enterPressed = true
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
        updateHistory()
    }
    
    @IBAction func backspace() {
        if (display.text!).characters.count > 1 && userInputInProgress {
            display.text! = String((display.text!).characters.dropLast())
        } else if !enterPressed {
            userInputInProgress = false
            displayValue = 0
        }
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if userInputInProgress {
            if sender.currentTitle! == "±" {
                displayValue! *= -1
            } else {
                enter()
                executeOperation(sender.currentTitle)
            }
        } else {
            executeOperation(sender.currentTitle)
        }
        if display.text?.rangeOfString("=") == nil && displayValue != nil {
            display.text! = "=" + display.text!
        } else if displayValue == nil {
            display.text! = "Error"
        }

        enterPressed = true
        updateHistory()
    }
    
    @IBAction func addDecimalSeparator(sender: UIButton) {
        if !userInputInProgress {
            display.text! = "0\(sender.currentTitle!)"
            userInputInProgress = true
        } else if display.text!.rangeOfString(sender.currentTitle!) == nil {
            display.text! += sender.currentTitle!
        }
    }
    
    func executeOperation(operationName: String?) {
        if let operation = operationName {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    func updateHistory() {
        opHistory.text! = brain.calculateEquation()
    }
    
}

