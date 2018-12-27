//
//  ViewController.swift
//  Simon Says
//
//  Created by Kevin Vu on 12/25/18.
//  Copyright © 2018 Hung Vu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [CircularButton]!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!
    
    // Keep track of current game stats
    var currentPlayer = 0
    var scores = [0, 0]
    
    var sequenceIndex = 0
    var colorSequence = [Int]() // Use to playback sequence of buttons
    var colorsToTap = [Int]() // Users will need to reproduce the same values as in colorSequence
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sort color buttons to show tags with 0 first
        colorButtons = colorButtons.sorted() {
            $0.tag < $1.tag
        }
        
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
        
        createNewGame()
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        colorsToTap.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true // disable when game has started
        for button in colorButtons {
            button.alpha = 0.5
            button.isEnabled = false // only enable when game has started
        }
    }
    
    // Add one color to the colorSequence array
    func addNewColor() {
        // Adds random unsigned integer from 0-3
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
    }
    
    func playSequence() {
        // If sequence index is less, then it's still valid
        if sequenceIndex < colorSequence.count {
            flash(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            
            actionButton.setTitle("Tap the Circles", for: .normal)
            for button in colorButtons {
                button.isEnabled = true
            }
        }
    }
    
    func flash(button: CircularButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (bool) in
            self.playSequence()
        }
    }
    
    @IBAction func colorButtonHandle(_ sender: CircularButton) {
        // 1. If the tag of the button is equal to the first entry of the colorsToTap array
        // 2. Remove the first entry from the array so next time function is invoked, we can just
        // check the first entry
        if sender.tag == colorsToTap.removeFirst() {
            
        } else {
            for button in colorButtons {
                button.isEnabled = false
            }
            
            return
        }
        
        // Assumed that user has successfully tapped all buttons correctly
        if colorsToTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }

    @IBAction func actionButtonHandle(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false // disable all user interactions before starting a new round
        
        addNewColor()
        
        // Calls the playSequence() method after one second it was tapped
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
}

