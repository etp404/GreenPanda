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
        entryTextInput.backgroundColor = UIColor.gray
    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.entryText = entryTextInput.text
        viewModel?.composeButtonPressed {}
    }
 
    @objc
    func keyboardDidShow(sender: NSNotification) {
        guard let keyboardFrame: CGRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let keyboardHeightInSafeArea = view.safeAreaLayoutGuide.layoutFrame.intersection(keyboardFrameInView).height
        entryTextInput.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeightInSafeArea, right: 0)
        entryTextInput.verticalScrollIndicatorInsets.bottom = keyboardHeightInSafeArea
        if let textPosition = entryTextInput.selectedTextRange?.start {
            let caret = entryTextInput.caretRect(for: textPosition)
            entryTextInput.scrollRectToVisible(caret, animated: true)
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
        entryTextInput.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        entryTextInput.verticalScrollIndicatorInsets.bottom = 0
        self.view.layoutIfNeeded()
    }
}

