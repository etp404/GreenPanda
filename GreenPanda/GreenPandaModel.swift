//
//  GreenPandaModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 21/10/2020.
//

import Foundation

struct DiaryEntry {}

protocol GreenPandaModel {
    var entries: [DiaryEntry] { get }
}


