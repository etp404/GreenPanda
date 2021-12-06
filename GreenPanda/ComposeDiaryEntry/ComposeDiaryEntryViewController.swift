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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var entryTextInput: UITextView!
    
    @IBOutlet weak var moodPicker: UISegmentedControl!
    
    @IBAction func moodSliderChanged(_ sender: UISegmentedControl) {
        viewModel?.score = Float(sender.selectedSegmentIndex)
    }
    
    private var viewModel: ComposeDiaryEntryViewModel?
    
    func configure(with viewModel: ComposeDiaryEntryViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        moodPicker.removeAllSegments()
        viewModel?.moodScoreReps.enumerated().forEach {(index, label) in
            moodPicker.insertSegment(withTitle: label, at: index, animated: false)
        }
        anyCancellable = viewModel?.$hideDoneButton.sink {hidden in
            self.doneButton.alpha = hidden ? 0.5 : 1
        }
        entryTextInput.delegate = self
        viewModel?.entryText = entryTextInput.text
        
        entryTextInput.becomeFirstResponder()
        
    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.composeButtonPressed {}
    }
 
    @objc
    func keyboardWillShow(sender: NSNotification) {
        guard let keyboardFrame: CGRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let keyboardHeightInSafeArea = view.safeAreaLayoutGuide.layoutFrame.intersection(keyboardFrameInView).height
        entryTextInput.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeightInSafeArea, right: 0)
        entryTextInput.verticalScrollIndicatorInsets.bottom = keyboardHeightInSafeArea
        
        self.view.layoutIfNeeded()
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
    entryTextInput.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        entryTextInput.verticalScrollIndicatorInsets.bottom = 0
        self.view.layoutIfNeeded()
    }
}

extension ComposeDiaryEntryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.entryText = textView.text
    }
}
