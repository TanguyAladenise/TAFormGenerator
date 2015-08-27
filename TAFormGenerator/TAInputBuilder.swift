//
//  TAInputBuilder.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation



enum TAInputStyle : Int {
    
    case TextField
    case TextTwitterField
    case TextEmailField
    case TextPhoneField
    case TextSecure
    case NumberField
    case URLInput
    case LinksField
 
    case RadioButtons
    
    case TextLocation
    case TextDisable
    case DatePicker
    case DateTimePicker
    case SpeedPicker
    case DistancePicker
    case PricePicker
    case SexePicker
    case LanguagePicker
    case AddressPicker
    case CityPicker
    case CustomPicker
    case RangePicker
}


class TAInputBuilder {
    
    class func textInputWithStyle(inputStyle: TAInputStyle, placeholder: String? = nil) -> UIView {
        switch inputStyle {
        case .TextEmailField:
            return TAEmailInput(placeholder: placeholder)
        case .TextTwitterField:
            return TATwitterInput(placeholder: placeholder)
        case .TextPhoneField:
            return TAPhoneInput(placeholder: placeholder)
        case .TextSecure:
            return TASecureInput(placeholder: placeholder)
        case .NumberField:
            return TANumberInput(placeholder: placeholder)
        default:
            return TATextInput(placeholder: placeholder)
        }
    }
    
    class func radioButtons(label: String, options: [String]) -> TARadioButtonsInput {
        return TARadioButtonsInput(label: label, options: options)
    }
    
    
    class func dropdownInput(options: [String], placeholder: String? = nil) -> TADropdownInput {
        return TADropdownOptionsInput(dropdownOptions: options, placeholder: placeholder)
    }
    
    
    class func dateInput(datePickerMode: UIDatePickerMode, placeholder: String? = nil) -> TADateInput {
        return TADateInput(datePickerMode: datePickerMode, placeholder: placeholder)
    }
    
    
    class func imageInput(label: String, target: UIViewController) -> TAImageInput {
        return TAImageInput(label: label, target: target)
    }
    
    
    class func linksInput(placeholder: String, target: UIViewController) -> TALinksInput {
        return TALinksInput(placeholder: placeholder, target: target)
    }
    
    
    class func stepperInput(placeholder: String) -> TAStepperInput {
        return TAStepperInput(placeholder: placeholder)
    }
    
    
    class func textViewInput(placeholder: String? = nil) -> TATextViewInput {
        return TATextViewInput(placeholder: placeholder)
    }
}