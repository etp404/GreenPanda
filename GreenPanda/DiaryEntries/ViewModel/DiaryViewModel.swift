//
//  DiaryViewModel.swift
//  GreenPanda
//
//  Created by Matthew Mould on 28/01/2022.
//

import Foundation

protocol DiaryViewModel {
    func composeButtonPressed()
    var chartViewModelPublisher: Published<ChartViewModel>.Publisher { get }
    var entriesPublisher: Published<[EntryViewModel] >.Publisher { get }
    var entriesTableHiddenPublisher: Published<Bool>.Publisher { get }
    var promptHiddenPublisher: Published<Bool>.Publisher { get }
    func proportionOfCellAboveTopOfCollectionView(_ proportion: Double, index: Int)
    func topVisibleRowNumberDidChange(to rowNumber: Int)
    func deleteEntry(at row:Int)
    func editEntry(at row: Int)
}
