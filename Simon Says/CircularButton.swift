//
//  CircularButton.swift
//  Simon Says
//
//  Created by Kevin Vu on 12/27/18.
//  Copyright © 2018 Hung Vu. All rights reserved.
//

import UIKit

import Foundation

class CircularButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }
}
