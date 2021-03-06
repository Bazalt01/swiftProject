//
//  TemplateFormatter.swift
//  CyberAssistant
//
//  Created by g.tokmakov on 27/08/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

struct Pattern {
    static let unbracketPattern = "(?<=\\[).+?(?=\\])"
    static let bracketPattern = "\\[.+?\\]"
}

fileprivate enum TemplateType {
    case number
    case word
    case numberRange
    case anySet
}

class TemplateFormatter {
    
    // MARK: - Public
    
    class func format(template: String) -> NSAttributedString {
        return format(attrTemplate: NSAttributedString(string: template))
    }
    
    class func format(attrTemplate: NSAttributedString) -> NSAttributedString {
        let values = findValuesInBracket(template: attrTemplate.string, pattern: Pattern.bracketPattern)
        
        let result = NSMutableAttributedString(attributedString: attrTemplate)
        for value in values {
            result.addAttribute(.foregroundColor, value: AppearanceColor.templateBracket, range: value.range)
        }
        return result
    }
    
    class func generateTemplateResult(template: String) -> String {
        let unbrackedValues = findValuesInBracket(template: template, pattern: Pattern.unbracketPattern)
        let brackedValues = findValuesInBracket(template: template, pattern: Pattern.bracketPattern)
        
        guard unbrackedValues.count > 0 else { return template }
        
        var result = template
        func replace(string: String, range: NSRange) {
            if let subrange = Range.init(range, in: template) {
                result.replaceSubrange(subrange, with: string)
            }
        }
        unbrackedValues.enumerated().reversed().forEach { (offset, value) in
            let text = value.text
            let brackedValue = brackedValues[offset]
            switch detectType(value: text) {
            case .number:
                if let number = Int(text) {
                    replace(string: String(arc4random_uniform(UInt32(number))), range: brackedValue.range)
                }
            case .word:
                replace(string: text, range: brackedValue.range)
            case .numberRange:
                let numbers = text.components(separatedBy: CharacterSet(charactersIn: "-"))
                let result = numbers.map({ return Int($0)! }).sorted(by: { $0 < $1 })
                let number = result[0] + Int(arc4random_uniform(UInt32(result[1] - result[0])))
                replace(string: String(number), range: brackedValue.range)
            case .anySet:
                let words = text.components(separatedBy: CharacterSet(charactersIn: ","))
                let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
                let word = words[randomIndex].trimmingCharacters(in: CharacterSet.whitespaces)
                replace(string: word, range: brackedValue.range)
            }
        }
        return result
    }
    
    // MARK: - Private
    
    private class func detectType(value: String) -> TemplateType {
        guard value.contains(",") == false else { return .anySet }
        
        if value.contains("-") {
            let symbols = value.components(separatedBy: CharacterSet(charactersIn: "-"))
            guard symbols.count == 2 else { return .word }
            for symbol in symbols {
                guard let _ = symbol.rangeOfCharacter(from: CharacterSet.decimalDigits) else { return .word }
            }
            return .numberRange
        }
        
        return (value.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) ? .number : .word
    }
    
    private class func findValuesInBracket(template: String, pattern: String) -> [(text: String, range: NSRange)] {
        guard let regExp = regularExpresion(pattern: pattern) else { return [] }
        
        var result = [(text: String, range: NSRange)]()
        var range = NSRange(location: 0, length: template.count)
        regExp.enumerateMatches(in: template, options: [], range: range) { (checkingResult, flag, stop) in
            if let cResult = checkingResult {
                range = NSRange(location: cResult.range.upperBound, length: range.length - cResult.range.upperBound)
                let substring = substringOf(string: template, range: cResult.range)
                result.append((text: substring, range: cResult.range))
            }
        }
        return result
    }
    
    private class func substringOf(string: String, range: NSRange) -> String {
        let beginIndex = string.index(string.startIndex, offsetBy: range.location)
        let endIndex = string.index(string.endIndex, offsetBy: -(string.count - range.upperBound))
        return String.init(string[beginIndex..<endIndex])
    }
    
    private class func regularExpresion(pattern: String) -> NSRegularExpression? {
        do {
            return try NSRegularExpression(pattern: pattern, options: [])            
        } catch {
            return nil
        }
    }
}

