//
//  ScoreTableViewCell.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 22.10.2023.
//

import UIKit

final class ScoreTableViewCell: UITableViewCell {

    static var identifier: String { "\(Self.self)" }
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func configure(with playerName: String?, and playerScore: Int64) {
        playerLabel.textColor = .white
        scoreLabel.textColor = playerLabel.textColor
        
        playerLabel.text = playerName
        scoreLabel.text = String(playerScore)
    }
}
