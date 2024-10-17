//
//  FeedbackGenerator.swift
//  Haptics
//
//  Created by Yevhen Tsyhanenko on 17/10/2024.
//

import Foundation
import UIKit
import AudioToolbox

extension FeedbackGenerator {
    struct C {
        static let kSystemSoundID_VibratePeek: SystemSoundID = 1519
        static let kSystemSoundID_VibratePop: SystemSoundID = 1520
        static let kSystemSoundID_VibrateNope: SystemSoundID = 1521
    }
}

extension FeedbackGenerator: Identifiable {
    var id: String {
        switch self {
        case .impact(let style):
            let suffix = switch style {
            case .light: "light"
            case .medium: "medium"
            case .heavy: "heavy"
            case .soft: "soft"
            case .rigid: "rigid"
            @unknown default: "default"
            }
            
            return "impact" + " " + suffix
        case .notification(let type):
            let suffix = switch type {
            case .success: "success"
            case .warning: "warning"
            case .error: "error"
            @unknown default: "default"
            }
            
            return "notification" + " " + suffix
        case .selection: return "selection"
        case .peek: return "peek"
        case .pop: return "pop"
        case .nope: return "nope"
        case .oldSchool: return "old school"
        }
    }
}

extension FeedbackGenerator: CaseIterable {
    static let allCases: [FeedbackGenerator] = [
        .impact(.light),
        .impact(.medium),
        .impact(.heavy),
        .impact(.soft),
        .impact(.rigid),
        .notification(.success),
        .notification(.warning),
        .notification(.error),
        .selection,
        .peek,
        .pop,
        .nope,
        .oldSchool
    ]
}

enum FeedbackGenerator: Hashable {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
    case peek
    case pop
    case nope
    case oldSchool
    
    func run() {
        switch self {
        case .impact(let style):
            self.runImpactFeedbackGenerator(style: style)
        case .notification(let type):
            self.runNotificationFeedbackGenerator(type: type)
        case .selection:
            self.runSelectionFeedbackGenerator()
        case .peek:
            self.runAudioServiceSystemSound(id: C.kSystemSoundID_VibratePeek)
        case .pop:
            self.runAudioServiceSystemSound(id: C.kSystemSoundID_VibratePop)
        case .nope:
            self.runAudioServiceSystemSound(id: C.kSystemSoundID_VibrateNope)
        case .oldSchool:
            self.runAudioServiceSystemSound(id: kSystemSoundID_Vibrate)
        }
    }
    
    private func runImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func runNotificationFeedbackGenerator(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    private func runSelectionFeedbackGenerator() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    private func runAudioServiceSystemSound(id: SystemSoundID) {
        AudioServicesPlaySystemSoundWithCompletion(id, nil)
    }
}
