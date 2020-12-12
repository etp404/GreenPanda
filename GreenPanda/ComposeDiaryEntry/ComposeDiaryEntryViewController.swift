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
    @IBOutlet weak var moodScorePicker: UIPickerView!
    @IBOutlet weak var entryDate: UIDatePicker!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodSlider: UISlider!
    
    @IBAction func moodSliderChanged(_ sender: UISlider) {
        viewModel?.moodSliderUpdated(to: sender.value)
    }
    
    private var viewModel: ComposeDiaryEntryViewModel?
    
    func configure(with viewModel: ComposeDiaryEntryViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodScorePicker.delegate = self
        moodScorePicker.dataSource = self
        moodSlider.value = 2.0
        viewModel?.moodSliderUpdated(to: moodSlider.value)
        anyCancellable = viewModel?.$moodLabel.sink(receiveValue: {moodLabelValue in
            self.moodLabel.text = moodLabelValue
        })
    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.entryText = entryText.text
        viewModel?.date = entryDate.date
        viewModel?.score = moodScorePicker.selectedRow(inComponent: 0)
        viewModel?.composeButtonPressed {}
    }
    
}

extension ComposeDiaryEntryViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.moodScore(for: row)
    }

}

extension ComposeDiaryEntryViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.numberOfMoodScores
        }
        return 0
    }
    
}
