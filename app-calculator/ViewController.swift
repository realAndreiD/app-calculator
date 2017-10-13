//
//  ViewController.swift
//  app-calculator
//
//  Created by Mordre on 10/10/2017.
//  Copyright © 2017 Free. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false
    
    private func showSizeClasses() {
        if !userIsTyping {
            display.textAlignment = .center
            display.text = "width " + traitCollection.horizontalSizeClass.description + " height" + traitCollection.verticalSizeClass.description
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSizeClasses()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { coordinator in
            self.showSizeClasses()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅") { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
        } else {
            display.text! = digit
            userIsTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}
extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        case .unspecified:
            return "??"
        }
    }
}
