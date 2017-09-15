//
//  PassageViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import PKHUD
import EasyTipView
import AVFoundation

struct GlobalSettings {
    enum FontSize: CGFloat {
        case small = 16.0
        case medium = 18.0
        case large = 20.0
    }
}

class PassageViewController: UIViewController {
    
    struct SentenceRange {
        var range: NSRange
        var spanish: String
        var english: String
    }
    
    @IBOutlet weak var passageTextView: UITextView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped))
            passageTextView.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizer.isEnabled = true
            
            passageTextView.isUserInteractionEnabled = true
            passageTextView.isEditable = false
        }
    }
    
    //Mark:- Properties
    private var dataManager: DataManager?
    private var passage: Passage? {
        didSet {
            setupSentences()
        }
    }
    private var sentenceRanges = [SentenceRange]()
    private var basicAttributePassage: NSMutableAttributedString?
    private var tipView: EasyTipView?
    private var tipPointView: UIView?
    private var takeQuizTapped: ((Passage) -> ())?
    private lazy var synthesizer: AVSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        return synthesizer
    }()
    fileprivate var currentSentenceRange: SentenceRange?
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, passage: Passage, takeQuizTapped: @escaping (Passage) -> ()) {
        self.init()
        
        self.dataManager = dataManager
        self.passage = passage
        self.takeQuizTapped = takeQuizTapped
    }
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEasyTipPreferences()
        getPassageDetails(passage: passage)
        setupNavigationbar()
        setupPassageTextView()
    }
    
    private func setupNavigationbar() {
        navigationItem.title = passage?.key ?? ""
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func setupPassageTextView() {
        guard let spanishText = passage?.passageText?.spanish else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributes: [NSAttributedStringKey: Any] = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: GlobalSettings.FontSize.medium.rawValue),
                                                         NSAttributedStringKey.paragraphStyle: paragraphStyle
        ]
        basicAttributePassage = NSMutableAttributedString(string: spanishText, attributes: attributes)
        passageTextView.attributedText = basicAttributePassage
    }
    
    private func getPassageDetails(passage: Passage?) {
        guard let passage = passage else {
            HUD.show(.labeledError(title: "Error", subtitle: "Please try again later."))
            return
        }
        HUD.show(.progress)
        dataManager?.getPassage(key: passage.key)
            .then { passage -> Void in
                self.passage = passage
            }
            .always {
                HUD.hide()
            }
            .catch { error in
                print(error.localizedDescription)
        }
    }
    
    private func setupSentences() {
        guard let spanishText = passage?.passageText?.spanish else { return }
        sentenceRanges = []
        for sentence in passage?.sentences ?? [] {
            guard let englishSentence = sentence.english,
                let spanishSentence = sentence.spanish
                else {
                    return
            }
            
            let range = (spanishText as NSString).range(of: spanishSentence)
            sentenceRanges.append(SentenceRange(range: range, spanish: spanishSentence, english: englishSentence))
        }
        
        for (index, value) in sentenceRanges.enumerated() {
            basicAttributePassage?.addAttribute(NSAttributedStringKey(rawValue: "sentenceIndex"), value: index, range: value.range)
        }
        
        passageTextView.attributedText = basicAttributePassage
    }
    
    private func resetViews() {
        tipView?.dismiss()
        tipPointView?.removeFromSuperview()
        tipPointView = nil
        synthesizer.stopSpeaking(at: .immediate)
        passageTextView.attributedText = basicAttributePassage
    }
    
    @objc func textTapped(_ recognizer: UITapGestureRecognizer) {
        resetViews()
        
        // Location of the tap in text-container coordinates
        let layoutManager = passageTextView.layoutManager
        var location = recognizer.location(in: passageTextView)
        location.x = location.x - passageTextView.textContainerInset.left
        location.y = location.y - passageTextView.textContainerInset.top
        
        // Find the character that's been tapped on
        let characterIndex = layoutManager.characterIndex(for: location, in: passageTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < (passageTextView.textStorage.length - 10) {
            var range = NSRange()
            
            let value = passageTextView.attributedText.attribute(NSAttributedStringKey(rawValue: "sentenceIndex"), at: characterIndex, effectiveRange: &range)
            
            guard let selectedSentenceRange = sentenceRange(for: range, attributedValue: value) else { return }
            currentSentenceRange = selectedSentenceRange
            showTranslatedPopup(for: selectedSentenceRange, point: location)
            speakSelectedRange(sentenceRange: selectedSentenceRange)
        }
    }
    
    private func sentenceRange(for range: NSRange, attributedValue: Any?) -> SentenceRange? {
        guard let index = attributedValue as? Int, index < sentenceRanges.count else { return nil}
        return sentenceRanges[index]
    }
    
    private func showTranslatedPopup(for sentenceRange: SentenceRange, point: CGPoint) {
        tipView = EasyTipView(text: sentenceRange.english)
        tipPointView = UIView(frame: CGRect(x: point.x, y: point.y, width: 50, height: 10))
        passageTextView.addSubview(tipPointView!)
        tipView?.show(animated: true, forView: tipPointView!, withinSuperview: passageTextView)
        
        passageTextView.attributedText = attributedStringForSelectionRange(sentenceRange: sentenceRange)
    }
    
    fileprivate func attributedStringForSelectionRange(sentenceRange: SentenceRange) -> NSMutableAttributedString? {
        guard let attribtuedString = basicAttributePassage?.mutableCopy() as? NSMutableAttributedString else { return nil }
        attribtuedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: sentenceRange.range)
        attribtuedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.lightGray.withAlphaComponent(0.2), range: sentenceRange.range)
        
        return attribtuedString
    }
    
    private func speakSelectedRange(sentenceRange: SentenceRange) {
        let utterance = AVSpeechUtterance(string: sentenceRange.spanish)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        
        synthesizer.speak(utterance)
    }
    
    private func setupEasyTipPreferences() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.systemFont(ofSize: GlobalSettings.FontSize.medium.rawValue)
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(red: 0.56, green: 0.47, blue: 0.67, alpha: 1)
        preferences.drawing.arrowPosition = .top
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        
        EasyTipView.globalPreferences = preferences
    }
    
    @IBAction func takeQuizButtonTapped(_ sender: UIButton) {
        guard let passage = passage else { return }
        self.takeQuizTapped?(passage)
    }
}

extension PassageViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        guard let sentenceRange = currentSentenceRange else { return }

        let range = NSRange(location: (currentSentenceRange?.range.location ?? 0) + characterRange.location, length: characterRange.length)
        let mutableAttribuedString = attributedStringForSelectionRange(sentenceRange: sentenceRange)
        mutableAttribuedString?.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
        passageTextView.attributedText = mutableAttribuedString
    }
    
    private func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        guard let sentenceRange = currentSentenceRange else { return }
        passageTextView.attributedText = attributedStringForSelectionRange(sentenceRange: sentenceRange)
    }
}


