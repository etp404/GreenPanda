//
//  ComposeDiaryEntryViewController.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit
import Combine

class ComposeDiaryEntryViewController: UIViewController {

    private var anyCancellable: AnyCancellable?
    
    @IBOutlet weak var entryText: UITextField!
    @IBOutlet weak var entryDate: UIDatePicker!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodSlider: UISlider!
    
    @IBAction func moodSliderChanged(_ sender: UISlider) {
        viewModel?.score = sender.value
    }
    
    private var viewModel: ComposeDiaryEntryViewModel?
    
    func configure(with viewModel: ComposeDiaryEntryViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodSlider.value = 2.0
        viewModel?.score = moodSlider.value
        anyCancellable = viewModel?.$moodLabel.sink(receiveValue: {moodLabelValue in
            self.moodLabel.text = moodLabelValue
        })
    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.entryText = entryText.text
        viewModel?.date = entryDate.date
        viewModel?.composeButtonPressed {}
    }
    
}

