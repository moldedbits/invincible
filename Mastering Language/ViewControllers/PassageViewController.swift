//
//  PassageViewController.swift
//  Mastering Language
//
//  Created by Koushal Sharma on 15/09/17.
//  Copyright © 2017 Moldedbits. All rights reserved.
//

import UIKit
import PKHUD

class PassageViewController: UIViewController {
    
    struct SentanceRange {
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
//    @IBOutlet weak var passageLabel: UILabel! {
//        didSet {
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped))
//            passageLabel.addGestureRecognizer(tapGestureRecognizer)
//            tapGestureRecognizer.isEnabled = true
//
//            passageLabel.isUserInteractionEnabled = true
//            passageLabel.numberOfLines = 0
//        }
//    }
    
    //Mark:- Properties
    private var dataManager: DataManager?
    private var passage: Passage? {
        didSet {
            setupSentences()
        }
    }
    private var sentenceRanges = [SentanceRange]()
    
    //Mark:- Initialiser
    convenience init(dataManager: DataManager?, passage: Passage) {
        self.init()
        
        self.dataManager = dataManager
        self.passage = passage
    }
    
    //Mark:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let passage = passage else {
            HUD.show(.labeledError(title: "Error", subtitle: "Please try again later."))
            return
        }
        getPassageDetails(passage: passage)
        guard let spanishText = passage.passageText?.spanish else { return }
        let attributedString = NSMutableAttributedString(string: spanishText)
        passageTextView.attributedText = attributedString
    }
    
    func getPassageDetails(passage: Passage) {
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
    
    func setupSentences() {
        guard let spanishText = passage?.passageText?.spanish else { return }
        let attributedString = NSMutableAttributedString(string: spanishText)
        sentenceRanges = []
        for sentence in passage?.sentences ?? [] {
            guard let englishSentence = sentence.english,
                let spanishSentence = sentence.spanish
                else {
                    return
            }
            
            let range = (spanishText as NSString).range(of: spanishSentence)
            sentenceRanges.append(SentanceRange.init(range: range, spanish: spanishSentence, english: englishSentence))
        }
        
        for value in sentenceRanges {
            attributedString.addAttribute(NSAttributedStringKey(rawValue: "trans"), value: value.english, range: value.range)
        }
        
        passageTextView.attributedText = attributedString
    }
    
    @objc func textTapped(_ recognizer: UITapGestureRecognizer) {
        
        // Location of the tap in text-container coordinates
        let layoutManager = passageTextView.layoutManager
        var location = recognizer.location(in: passageTextView)
        location.x = location.x - passageTextView.textContainerInset.left
        location.y = location.y - passageTextView.textContainerInset.top
        
        // Find the character that's been tapped on
        let characterIndex = layoutManager.characterIndex(for: location, in: passageTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < passageTextView.textStorage.length {
            var range = NSRange()
            
            let value = passageTextView.attributedText.attribute(NSAttributedStringKey(rawValue: "trans"), at: characterIndex, effectiveRange: &range)
            
            print("\(value) \(range.location)")
        }
//        for sentenceRange in sentenceRanges {
//            guard let glyphRect = passageLabel.boundingRectForCharacterRange(range: sentenceRange.range) else { continue }
//
//            let touchPoint = recognizer.location(ofTouch: 0, in: self.passageLabel)
//            if glyphRect.contains(touchPoint) {
//                sentenceTapped(sentenceRange: sentenceRange, touchPoint: touchPoint, glyphRect: glyphRect)
//            }
//        }
    }
    
    func sentenceTapped(sentenceRange: SentanceRange, touchPoint: CGPoint, glyphRect: CGRect) {
        print("\(sentenceRange.spanish) \(touchPoint.debugDescription) \(glyphRect.debugDescription)")
    }
}

extension UILabel {
    func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        // Storage class stores the string, obviously
        let textStorage: NSTextStorage = NSTextStorage(attributedString: attributedText)
        
        // The storage class owns a layout manager
        let layoutManager: NSLayoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        // Layout manager owns a container which basically
        // defines the bounds the text should be contained in
        let textContainer: NSTextContainer = NSTextContainer(size: bounds.size)
        // For labels the fragment padding should be 0
        textContainer.lineFragmentPadding = 0
        
        layoutManager.addTextContainer(textContainer)
        
        // Begin computation of actual frame
        // Glyph is the final display representation
        // Eg: Ligatures have 2 characters but only 1 glyph.
        var glyphRange = NSRange()
        glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: &glyphRange)
        
        let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        return glyphRect
    }
}
