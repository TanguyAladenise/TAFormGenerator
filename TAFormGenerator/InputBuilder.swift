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


class InputBuilder {
    
    class func textInputWithStyle(inputStyle: InputStyle, placeholder: String? = nil) -> UIView {
        switch inputStyle {
        case .TextEmailField:
            return EmailInput(placeholder: placeholder)
        case .TextTwitterField:
            return TwitterInput(placeholder: placeholder)
        case .TextPhoneField:
            return PhoneInput(placeholder: placeholder)
        case .TextSecure:
            return SecureInput(placeholder: placeholder)
        case .NumberField:
            return NumberInput(placeholder: placeholder)
        default:
            return TextInput(placeholder: placeholder)
        }
    }
    
    class func radioButtons(label: String, options: [String]) -> RadioButtonsInput {
        return RadioButtonsInput(label: label, options: options)
    }
    
    
    class func dropdownInput(options: [String], placeholder: String? = nil) -> DropdownInput {
        return DropdownInput(dropdownOptions: options, placeholder: placeholder)
    }
    
    
    class func imageInput(label: String, target: UIViewController) -> ImageInput {
        return ImageInput(label: label, target: target)
    }
    
    
    class func linksInput(placeholder: String, target: UIViewController) -> LinksInput {
        return LinksInput(placeholder: placeholder, target: target)
    }
}