//
//  Player.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//


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
            return "EXTREME X3"
        }
    }
    
    var speed: Int64 {
        switch self {
        case .normal:
            return 3
        case .hard:
            return 2
        case .extreme:
            return 1
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
