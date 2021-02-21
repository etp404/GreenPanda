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
    @IBOutlet weak var stackView: UIStackView!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    @IBAction func submit(_ sender: Any) {
        viewModel?.entryText = entryTextInput.text
        viewModel?.composeButtonPressed {}
    }
 
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
        animateWithKeyboard(notification: notification, animations: {[weak self] in
            self?.entryTextInput.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height+60, right: 0)

            //self?.stackViewBottomConstraint.constant = keyboardFrame.height
////            if let textPosition = self?.entryTextInput.selectedTextRange!.start,
////               let caret = self?.entryTextInput.caretRect(for: textPosition) {
////                self?.entryTextInput.scrollRectToVisible(caret, animated: true)
////            }
        })
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification, animations: {
           // self.stackViewBottomConstraint.constant = 0
        })
    }
    
    func animateWithKeyboard(
            notification: NSNotification,
            animations: (() -> Void)?
        ) {
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            let curveValue = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
            let curve = UIView.AnimationCurve(rawValue: curveValue)!

            // Create a property animator to manage the animation
            let animator = UIViewPropertyAnimator(
                duration: duration,
                curve: curve
            ) {
                // Perform the necessary animation layout updates
                animations?()
                
                // Required to trigger NSLayoutConstraint changes
                // to animate
                self.view?.layoutIfNeeded()
            }
            
            // Start the animation
            animator.startAnimation()
        }
}



