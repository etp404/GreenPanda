//
//  EntryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 28/01/2022.
//

import Foundation

struct EntryViewModel: Hashable {
    let id: UUID
    let date: String
    let entryText: String
    let score: String
}
