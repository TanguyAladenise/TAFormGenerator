//
//  TAInputValidator.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 26/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation


enum TAInputTypeRule: Int {
    case TypeEmail
    case TypeNumeric
    case TypeAlphabetic
    case TypedDate
    case TypeDateTime
}


class TAInputValidator {
    
    
    private var typeRules: [TAInputTypeRule] = []
    
    var minimumLength: Int?
    var maximumLength: Int?
    
    var minimumDate: NSDate?
    var maximumDate: NSDate?
    
    var minimumNumber: Int?
    var maximumNumber: Int?
    
    var isMandatory: Bool = false
    
    var regex: String?
    
    
    private var value: String!
    
    private var error: NSError?
    
    
    /**
    Add a type rule for input
    
    :param: typeRule Type rule
    */
    func addTypeRule(typeRule: TAInputTypeRule) {
        typeRules.append(typeRule)
    }
    
    
    /**
    Validate the given value
    
    :param: value Value to validate
    
    :returns: Validation result
    */
    func validate(value: String) -> (Bool, NSError?) {
        
        self.value = value
        
        // Before starting heaving validation work check if input is not mandatory and its value is null
        if !isMandatory && count(value) == 0 {
            return (true, nil)
        }
        
        for typeRule in typeRules {
            if validateRule(typeRule) == false {
                return (false, error)
            }
        }
        
        return (validateMandatory() && validateLength() && validateNumber() && validateDate() && validateRegex(), error)
    }
    
    
    /**
    Logic for mandatory validation
    
    :returns: Validation result
    */
    private func validateMandatory() -> Bool {
        if !isMandatory {
            return true
        }
        
        let valid = count(value) > 0 ? true : false
        if !valid {
            error = NSError(domain: kTAFormErrorDomain, code: kFormErrorFieldMandatory, userInfo: userInfo(NSLocalizedString("Field is empty", comment: ""), localizedFailureReason: NSLocalizedString("Field is required", comment: "Required field validation")))
        }
        
        return valid
    }
    
    
    /**
    Logic for value length validation
    
    :returns: Validation result
    */
    private func validateLength() -> Bool {
        return (checkMinimumLength() && checkMaximumLength())
    }
    
    
    /**
    Logic for minimum length validation
    
    :returns: Validation result
    */
    private func checkMinimumLength() -> Bool {
        // Test if value is required, otherwise value is valid
        if let minLength = minimumLength {
            let valid = count(value) < minLength ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextTooShort, userInfo: userInfo(NSLocalizedString("Field is too short", comment: ""), localizedFailureReason: String(format: NSLocalizedString("at least %d characters", comment: "Minimum length field validation"), minLength)))
            }
            return valid
        } else {
            return true
        }
    }
    
    
    /**
    Logic for maximum length validation
    
    :returns: Validation result
    */
    private func checkMaximumLength() -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxLength = maximumLength {
            let valid = count(value) > maxLength ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextTooLong, userInfo: userInfo(NSLocalizedString("Field is too long", comment: ""), localizedFailureReason: String(format: NSLocalizedString("less than %d characters", comment: "Maximum length field validation"), maxLength)))
            }
            return valid
        } else {
            return true
        }
    }
    
    
    /**
    Logic for validating a regular expression
    
    :returns: Validation result
    */
    private func validateRegex() -> Bool {
        if let regex = regex {
            let testRegex  = NSPredicate(format:"SELF MATCHES %@", regex)
            let valid = testRegex.evaluateWithObject(value)
            
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextInvalid, userInfo: userInfo(NSLocalizedString("Text is invalid", comment: ""), localizedFailureReason: NSLocalizedString("Text is invalid", comment: "")))
            }
            
            return valid
        } else {
            return true
        }
    }
    
    
    /**
    Validate maximum and minimum for a number value
    
    :returns: Validation result
    */
    private func validateNumber() -> Bool {
        return (checkMinimumNumber() && checkMaximumNumber())
    }
    
    
    /**
    Logic for minimum number validation
    
    :returns: Validation result
    */
    private func checkMinimumNumber() -> Bool {
        // Test if value is required, otherwise value is valid
        if let minNumber = minimumNumber {
            if let v = value.toInt() {
                let valid = v < minNumber ? false : true
                if !valid {
                    error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberLower, userInfo: userInfo(NSLocalizedString("Number too small", comment: ""), localizedFailureReason: String(format: NSLocalizedString("higher or equal to %d", comment: "Minimum number field validation"), minNumber)))
                }
                return valid
            } else {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberInvalid, userInfo: userInfo(NSLocalizedString("Number is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Number is not valid", comment: "Number field validation")))
                return false
            }
        } else {
            return true
        }
    }
    
    
    /**
    Logic for maximum number validation
    
    :returns: Validation result
    */
    private func checkMaximumNumber() -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxNumber = maximumNumber {
            if let v = value.toInt() {
                let valid = v > maxNumber ? false : true
                if !valid {
                    error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberHigher, userInfo: userInfo(NSLocalizedString("Number is too big", comment: ""), localizedFailureReason: String(format: NSLocalizedString("lower or equal to %d", comment: "Maximum number field validation"), maxNumber)))
                }
                return valid
            } else {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberInvalid, userInfo: userInfo(NSLocalizedString("Number is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Number is not valid", comment: "Number field validation")))
                return false
            }
        } else {
            return true
        }
    }
    
    
    /**
    Validate maximum and minimum for a date value
    
    :returns: Validation result
    */
    private func validateDate() -> Bool {
        return (checkMinimumDate() && checkMaximumDate())
    }
    
    
    /**
    Logic for minimum date validation
    
    :returns: Validation result
    */
    private func checkMinimumDate() -> Bool {
        // Test if value is required, otherwise value is valid
        if let minDate = minimumDate {
            var aDate = find(typeRules, TAInputTypeRule.TypeDateTime) != nil ? convertToDateTime() : convertToDate()
            if let date = aDate {
                let valid = minDate.compare(date) == NSComparisonResult.OrderedDescending ? false : true
                if !valid {
                    error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInferior, userInfo: userInfo(NSLocalizedString("Date not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date invalid", comment: "Minimum date field validation")))
                }
                return valid
            } else {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
                return false
            }
        } else {
            return true
        }
    }
    
    
    /**
    Logic for maximum date validation
    
    :returns: Validation result
    */
    private func checkMaximumDate() -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxDate = maximumDate {
            var aDate = find(typeRules, TAInputTypeRule.TypeDateTime) != nil ? convertToDateTime() : convertToDate()
            if let date = aDate {
                let valid = maxDate.compare(date) == NSComparisonResult.OrderedAscending ? false : true
                if !valid {
                    error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateSuperior, userInfo: userInfo(NSLocalizedString("Date not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date must be before", comment: "Maximum date field validation")))
                }
                return valid
            } else {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
                return false
            }
        } else {
            return true
        }
    }
    
    
    
    /**
    Validate a given rule
    
    :param: rule Rule to test on value
    
    :returns: Validation result
    */
    func validateRule(rule: TAInputTypeRule) -> Bool {
        switch rule {
        case .TypeEmail:
            let valid = valueIsValidEmail()
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorEmailInvalid, userInfo: userInfo(NSLocalizedString("Email is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Email is not valid", comment: "Email field validation")))
            }
            return valid
        case .TypeNumeric:
            let valid = value.toInt() == nil ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberInvalid, userInfo: userInfo(NSLocalizedString("Number is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Number is not valid", comment: "Number field validation")))
            }
            return valid
        case .TypeAlphabetic:
            let valid = value.toInt() == nil ? true : false
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextInvalid, userInfo: userInfo(NSLocalizedString("Text is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Text is not valid", comment: "Text field validation")))
            }
            return valid
        case .TypedDate:
            let valid = convertToDate() == nil ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
            }
            return valid
        case .TypeDateTime:
            let valid = convertToDateTime() == nil ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
            }
            return valid
//        case .FieldBirthdate:
//            var valid = validateDate()
//            if !valid {
//                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorBirthdateInvalid, userInfo: userInfo(NSLocalizedString("Birthdate invalid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
//                return valid
//            }
//            
//            valid = convertToDate() == nil ? false : true
//            if !valid {
//                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorBirthdateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
//            }
//            return valid
        }
        
    }
    
    
    /**
    Convert value to date.
    
    :returns: Return a NSDate instance. If return nil, string is not date compatible
    */
    func convertToDate() -> NSDate? {
        var formatter       = NSDateFormatter()
        formatter.locale    = NSLocale.currentLocale()
        formatter.timeZone  = NSTimeZone.localTimeZone()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter.dateFromString(value)
    }
    
    
    /**
    Convert value to date.
    
    :returns: Return a NSDate instance. If return nil, string is not date compatible
    */
    func convertToDateTime() -> NSDate? {
        var formatter       = NSDateFormatter()
        formatter.locale    = NSLocale.currentLocale()
        formatter.timeZone  = NSTimeZone.localTimeZone()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter.dateFromString(value)
    }
    
    
    /**
    Validate a string as email format
    
    :returns: Validation result
    */
    func valueIsValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(value)
    }
    
    
    func userInfo(localizedDescription: String, localizedFailureReason: String) -> Dictionary<String, String> {
        return [
            NSLocalizedDescriptionKey: NSLocalizedString(localizedDescription, comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(localizedFailureReason, comment: ""),
        ]
    }
}








