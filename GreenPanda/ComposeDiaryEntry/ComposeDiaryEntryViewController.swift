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
    
    @IBOutlet weak var entryTextInput: UITextView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodSlider: UISlider!
    
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)

    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.entryText = entryTextInput.text
        viewModel?.composeButtonPressed {}
    }
 
    @objc
    func keyboardDidShow(sender: NSNotification) {
        guard let frame: CGRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
       
        stackViewBottomConstraint.constant = frame.height
        self.view.layoutIfNeeded()

        print("keyboard keyboardDidShow")

    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
        
        stackViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()

        guard let frame: CGRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
       
        
        print("keyboard \(frame)")
        print("keyboard keyboardWillHide")
    }
}

