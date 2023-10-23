//
//  GameParameters.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import Foundation


enum Skin {
    case bolt
    case boltcar
    case cloud
    
    var actionTitle: String {
        switch self {
        case .bolt:
            return "BOLT SKIN"
        case .boltcar:
            return "CAR SKIN"
        case .cloud:
            return "CLOUD SKIN"
        }
    }
    
    var selection: String {
        switch self {
        case .bolt:
            return "bolt.fill"
        case .boltcar:
            return "bolt.car.fill"
        case .cloud:
            return "bolt.horizontal.icloud.fill"
        }
    }
}

enum Mode {
    case normal
    case hard
    case extreme
    
    var selection: String {
        switch self {
            
        case .normal:
            return "NORMAL"
        case .hard:
            return "HARD  X2"
        case .extreme:
            return "EXTREME  X3"
        }
    }
    
    var speed: Double {
        switch self {
        case .normal:
            return 2
        case .hard:
            return 1.5
        case .extreme:
            return 1.1
        }
    }
}

enum Obstacle {
    case battery
    case box
    case water
    
    var actionTitle: String {
        switch self {
        case .battery:
            return "BATTERYBLOCK"
        case .box:
            return "BOX"
        case .water:
            return "WATER"
        }
    }
    
    var selection: String {
        switch self {
        case .battery:
            return "bolt.fill.batteryblock.fill"
        case .box:
            return "shippingbox.fill"
        case .water:
            return "water.waves"
        }
    }
}

struct Game {
    static let playerLifeCount = 3
    static let playerMoveStep: CGFloat = 100
    static let obstacleFrameSide: CGFloat = 70
}

struct Menu {
    static let start = "start"
    static let leaderboard = "leaderboard"
    static let settings = "settings"
    static let mode = "SELECT GAME MODE"
    static let boltFill = "bolt.fill"
    static let boltCar = "bolt.car.fill"
    static let boltSignal = "bolt.brakesignal"
    static let createNewPlayer = "CREATE NEW PLAYER"
    static let createIcon = "plus.circle.fill"
    static let userIcon = "person.circle.fill"
    static let selectPlayer = "SELECT PLAYER"
    static let selectPlayerSkin = "SELECT YOUR SKIN"
    static let selectObstacle = "SELECT OBSTACLE SKIN"
}

struct Alert {
    static let createTitle = "Enter your name"
    static let createMessage = "10 characters max"
    static let errorTitle = "ERROR"
    static let errorMessage = "Username cannot be empty and must contain 10 characters max!"
    static let duplicateMessage = "Username already exists!"
    
    static let cancel = "Cancel"
    static let save = "Save"
    static let ok = "Ok"
}

struct Constant {
    static let one = 1.0
    static let two = 2.0
    static let three = 3.0
    static let score = "SCORE:"
}
