//
//  AudioToolboxUtilities.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 21/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import AudioToolbox

public enum SystemSounds: UInt32 {
    case peek = 1519 // weak boom
    case pop = 1520 // pop boom
    case cancelled = 1521 // three weak booms
    case tryAgain = 1102 // weak boom then strong boom
    case vibrateTwice = 1311 // two vibrations
    case vibrate1 = 1350 // vibration
    case vibrate2 = 1351 // vibration
    case vibrate3 = 4095 // vibration
}

public func AudioServicesPlaySystemSound(_ inSystemSoundName: SystemSounds) {
    AudioToolbox.AudioServicesPlaySystemSound(inSystemSoundName.rawValue)
}
