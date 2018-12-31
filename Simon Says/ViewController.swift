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
    
    var gameEnded = false
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
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
        
        currentPlayer = 0 // player 1 starts first
        scores = [0, 0]
        
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.75
        
        updateScoreLabel()
    }
    
    func updateScoreLabel() {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.75
        
        // If current player is first player, then set it to 2nd player
        currentPlayer = currentPlayer == 0 ? 1 : 0
        
        playerLabels[currentPlayer].alpha = 1.0
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
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
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
            
            endGame()
            return
        }
        
        // Assumed that user has successfully tapped all buttons correctly
        if colorsToTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            scores[currentPlayer] += 1
            updateScoreLabel()
            switchPlayers()
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

