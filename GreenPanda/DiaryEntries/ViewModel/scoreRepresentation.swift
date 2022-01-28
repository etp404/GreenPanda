//
//  scoreRepresentation.swift
//  GreenPanda
//
//  Created by Matthew Mould on 28/01/2022.
//

import Foundation

func scoreSmiley(for score:Int) -> String {
    switch (score) {
    case 0: return "😩"
    case 1: return "😕"
    case 2: return "😐"
    case 3: return "🙂"
    case 4: return "😁"
    default: return ""
    }
}
