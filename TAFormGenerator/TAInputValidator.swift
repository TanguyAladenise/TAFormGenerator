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


protocol TAInputValidatorProtocol {
    func validateInput(inputValidator: TAInputValidator) -> (Bool, NSError?)
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
    
    
    private var value: AnyObject!
    
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
    func validate(value: AnyObject?) -> (Bool, NSError?) {
        
        if let v: AnyObject = value {
            self.value = v
        } else {
            self.value = ""
        }
        
        
        // Before starting heaving validation work check if input is not mandatory and its value is null
        if !isMandatory && value == nil {
            return (true, nil)
        }
        
        for typeRule in typeRules {
            if validateRule(typeRule) == false {
                return (false, error)
            }
        }
        
        return (validateMandatory(self.value) && validateLength(self.value) && validateNumber() && validateDate() && validateRegex(self.value), error)
    }
    
    
    /**
    Logic for mandatory validation
    
    :returns: Validation result
    */
    func validateMandatory(value: AnyObject?) -> Bool {
        if !isMandatory {
            return true
        }
        
        // From this point value is mandatory //
        
        var valid = true
        
        if value == nil {
            valid = false
        } else if let string = value as? String {
            valid = count(string) > 0 ? true : false
        } else if let array = value as? [AnyObject] {
            valid = array.count > 0 ? true : false
        }
        
        if !valid {
            error = NSError(domain: kTAFormErrorDomain, code: kFormErrorFieldMandatory, userInfo: userInfo(NSLocalizedString("Field is empty", comment: ""), localizedFailureReason: NSLocalizedString("Field is required", comment: "Required field validation")))
        }
        
        return valid
    }
    
    
    /**
    Logic for value length validation
    
    :returns: Validation result
    */
    private func validateLength(value: AnyObject?) -> Bool {
        if shouldValidateLength() {
            return (checkString(value) && checkMinimumLength(value) && checkMaximumLength(value))
        } else {
            return true
        }
    }
    
    

    /**
    Make sure length checking is required
    
    :returns: Validation result
    */
    private func shouldValidateLength() -> Bool {
        if minimumLength == nil && maximumLength == nil {
            return false
        } else {
            return true
        }
    }
    
    
    /**
    Check if value is of type String. To check before checking for lenght
    
    :returns: Validation result
    */
    private func checkString(value: AnyObject?) -> Bool {
        if let string = value as? String {
            return true
        } else {
            error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextInvalid, userInfo: userInfo(NSLocalizedString("Value is invalid", comment: ""), localizedFailureReason: NSLocalizedString("Value is invalid", comment: "")))
            return false
        }
    }
    
    
    /**
    Logic for minimum length validation
    
    :returns: Validation result
    */
    private func checkMinimumLength(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let minLength = minimumLength {
            let valid = count(value as! String) < minLength ? false : true
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
    private func checkMaximumLength(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxLength = maximumLength {
            let valid = count(value as! String) > maxLength ? false : true
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
    private func validateRegex(value: AnyObject?) -> Bool {
        if let regex = regex {
            let testRegex  = NSPredicate(format:"SELF MATCHES %@", regex)
            let valid = testRegex.evaluateWithObject(value!)
            
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextInvalid, userInfo: userInfo(NSLocalizedString("Value is invalid", comment: ""), localizedFailureReason: NSLocalizedString("Value is invalid", comment: "")))
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
        if shouldValidateNumber() {
            return (checkNumber(self.value) && checkMinimumNumber(self.value) && checkMaximumNumber(self.value))
        } else {
            return true
        }
    }
    
    /**
    Make sure number checking is required
    
    :returns: Validation result
    */
    private func shouldValidateNumber() -> Bool {
        if minimumNumber == nil && minimumNumber == nil {
            return false
        } else {
            return true
        }
    }

    
    /**
    Check if value is a number. Use before validating min and max value
    
    :returns: Validation result
    */
    private func checkNumber(value: AnyObject?) -> Bool {
        // FIXME: - Number logic
        // For the time being number values are passed as string and are only INT so validation is same as string
        if checkString(value) {
            if let number = (value as! String).toInt() {
                return true
            }
        }
        
        error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberInvalid, userInfo: userInfo(NSLocalizedString("Number is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Number is not valid", comment: "Number field validation")))
        return false
    }
    
    
    /**
    Logic for minimum number validation
    
    :returns: Validation result
    */
    private func checkMinimumNumber(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let minNumber = minimumNumber {
            let v = (value as! String).toInt()
            let valid = v < minNumber ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberLower, userInfo: userInfo(NSLocalizedString("Number too small", comment: ""), localizedFailureReason: String(format: NSLocalizedString("higher or equal to %d", comment: "Minimum number field validation"), minNumber)))
            }
            return valid
        } else {
            return true
        }
    }
    
    
    /**
    Logic for maximum number validation
    
    :returns: Validation result
    */
    private func checkMaximumNumber(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxNumber = maximumNumber {
            let v = (value as! String).toInt()
            let valid = v > maxNumber ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberHigher, userInfo: userInfo(NSLocalizedString("Number is too big", comment: ""), localizedFailureReason: String(format: NSLocalizedString("lower or equal to %d", comment: "Maximum number field validation"), maxNumber)))
            }
            return valid
            
        } else {
            return true
        }
    }
    
    
    /**
    Validate maximum and minimum for a date value
    
    :returns: Validation result
    */
    private func validateDate() -> Bool {
        if shouldValidateDate() {
            return (checkMinimumDate(self.value) && checkMaximumDate(self.value))
        } else {
            return true
        }
    }
    
    
    /**
    Make sure date checking is required
    
    :returns: Validation result
    */
    private func shouldValidateDate() -> Bool {
        if minimumDate == nil && maximumDate == nil {
            return false
        } else {
            return true
        }
    }

    
    /**
    Logic for minimum date validation
    
    :returns: Validation result
    */
    private func checkMinimumDate(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let minDate = minimumDate {
            println(value)
            var aDate = find(typeRules, TAInputTypeRule.TypeDateTime) != nil ? convertToDateTime(value) : convertToDate(value)
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
    private func checkMaximumDate(value: AnyObject?) -> Bool {
        // Test if value is required, otherwise value is valid
        if let maxDate = maximumDate {
            var aDate = find(typeRules, TAInputTypeRule.TypeDateTime) != nil ? convertToDateTime(value) : convertToDate(value)
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
            let valid = validateEmail(value)
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorEmailInvalid, userInfo: userInfo(NSLocalizedString("Email is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Email is not valid", comment: "Email field validation")))
            }
            return valid
        case .TypeNumeric:
            let valid = checkNumber(self.value)
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorNumberInvalid, userInfo: userInfo(NSLocalizedString("Number is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Number is not valid", comment: "Number field validation")))
            }
            return valid
        case .TypeAlphabetic:
            let valid = !checkNumber(self.value)
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorTextInvalid, userInfo: userInfo(NSLocalizedString("Text is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Text is not valid", comment: "Text field validation")))
            }
            return valid
        case .TypedDate:
            let valid = convertToDate(self.value) == nil ? false : true
            if !valid {
                error = NSError(domain: kTAFormErrorDomain, code: kFormErrorDateInvalid, userInfo: userInfo(NSLocalizedString("Date is not valid", comment: ""), localizedFailureReason: NSLocalizedString("Date is not valid", comment: "Date field validation")))
            }
            return valid
        case .TypeDateTime:
            let valid = convertToDateTime(self.value) == nil ? false : true
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
    private func convertToDate(value: AnyObject?) -> NSDate? {
        if let date = value as? NSDate {
            return date
        } else if let dateString = value as? String {
            var formatter       = NSDateFormatter()
            formatter.locale    = NSLocale.currentLocale()
            formatter.timeZone  = NSTimeZone.localTimeZone()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            return formatter.dateFromString(dateString)
        }
        
        return nil
    }
    
    
    /**
    Convert value to date.
    
    :returns: Return a NSDate instance. If return nil, string is not date compatible
    */
    private func convertToDateTime(value: AnyObject?) -> NSDate? {
        if let date = value as? NSDate {
            return date
        } else if let dateString = value as? String {
            var formatter       = NSDateFormatter()
            formatter.locale    = NSLocale.currentLocale()
            formatter.timeZone  = NSTimeZone.localTimeZone()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            return formatter.dateFromString(dateString)
        }
        
        return nil
    }
    
    
    /**
    Validate an email with a regex
    
    :param: email String to validate
    
    :returns: Validation result
    */
    func validateEmail(email: AnyObject?) -> Bool {
        if let email = email as? String {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluateWithObject(email)
        } else {
            return false
        }
    }
    
    
    /**
    Validate a url type
    
    :param: url URL to validate
    
    :returns: Validation result
    */
    func validateURL(url: AnyObject?) -> Bool {
        if let v = url as? String {
            if let url = NSURL(string: v) {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    
    func userInfo(localizedDescription: String, localizedFailureReason: String) -> Dictionary<String, String> {
        return [
            NSLocalizedDescriptionKey: NSLocalizedString(localizedDescription, comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(localizedFailureReason, comment: ""),
        ]
    }
}








