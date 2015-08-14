//
//  InputBuilder.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation



enum InputStyle : Int {
    
    case TextField
    case TextTwitterField
    case TextEmailField
    case TextPhoneField
    case TextSecure
    case NumberField
 
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


class InputBuilder {
    
    class func textInputWithStyle(inputStyle: InputStyle, placeHolder: String? = nil) -> UIView {
        
        switch inputStyle {
        case .TextEmailField:
            return EmailInput(placeholder: placeHolder)
        case .TextTwitterField:
            return TwitterInput(placeholder: placeHolder)
        case .TextPhoneField:
            return PhoneInput(placeholder: placeHolder)
        case .TextSecure:
            return SecureInput(placeholder: placeHolder)
        case .NumberField:
            return NumberInput(placeholder: placeHolder)
        default:
            return TextInput(placeholder: placeHolder)
        }
        
    }
    
    class func radioButtons(label: String, options: [String]) -> RadioButtonsInput {
        return RadioButtonsInput(label: label, options: options)
    }
    
}