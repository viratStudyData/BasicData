//
//  Validation.swift
//  Paramount
//
//  Created by cbl24 on 15/02/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{5,16}" // PhoneNo 10-14 Digits
    case acceptAll = ""
}

//MARK: -----> TextField Type
enum FieldType : String{
    case email = "Email"
    case password = "Password"
    case name = "Name"
    case firstName = "First Name"
    case lastName = "Last Name"
    case phone = "Mobile Number"
    case confirmPassword = "Confirm Password"
    case city = "City"
    case loginPassword = "Password "
    case countryCode = "Country Code"
    case zipCode = "Zip Code"
    case address = "Address"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//MARK: -----> Status
enum Status : String {
    case empty = "Please enter "
    case allSpaces = "Enter the "
    case passwordFormat = "Your Password must contain one capital letter and one numeric and one special character"
    case valid
    case inValid = "Please enter a valid "
    case allZeros = "Please enter a Valid "
    case hasSpecialCharacter = " can only contain A-z, a-z characters only"
    case nameLength = " length should be in between 2 - 40 characters"
    case notANumber = " must be a number "
    case emptyCountrCode = "Enter country code "
    case mobileNumberLength = " Mobile Number should be of atleast 6 - 15 number"
    case pwd = "Password length should be between 6-15 characters"
    case pinCode = "PinCode length should be 6 characters long"
    case zip = "Pincode should not contain special characters"
    case address = "Address length should be of 2 to 60 characters"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func message(type : FieldType) -> String? {
        switch self {
        case .hasSpecialCharacter: return type.localized + localized
        case .nameLength: return type.localized + localized
        case .valid: return nil
        case .passwordFormat : return rawValue
        case .emptyCountrCode: return localized
        case .pwd: return rawValue
        case .mobileNumberLength : return localized
        case .pinCode , .zip : return localized
        default: return localized + type.localized
        }
    }
}

extension String {

    func validate( userName : String? , password: String? ) -> Bool{
        
        let name = userName?.replacingOccurrences(of: " ", with: "")
        
        if (name?.isEmpty)! {
            Alerts.shared.show(alert: .error, message: AlertMessage.enterEmailOrPhone.localized, type: .info)
            return false
        }else if Double(/name?.trimmed()) != nil {
            if (name?.count)! < 6 || (name?.count)! > 15 {
                Alerts.shared.show(alert: .error, message: AlertMessage.mobileLimit.localized, type: .info)
                return false
            }
        } else if !(isValid(type: .email, info: name) && isValid(type: .password, info: password)){
            return false
        }
        
        return true
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    
    private func isValid(type : FieldType , info: String?) -> Bool {
    
        guard let validStatus = info?.handleStatus(fieldType : type) else {
            return true
        }
        
        let errorMessage = validStatus
        Alerts.shared.show(alert: .error, message: errorMessage , type : .info)
        return false
    }
    
    func handleStatus(fieldType : FieldType) -> String? {
        
        switch fieldType {
            case  .name , .lastName , .city, .firstName:
                return  isValidName.message(type: fieldType)
            
            case .email   :
                return  isValidEmail.message(type: fieldType)
            
            case .password , .confirmPassword:
                return  isValid(password: 6, max: 15).message(type: fieldType)
            
            case .loginPassword:
                return isValid().message(type:fieldType)
            
            case .phone:
                return  isValidPhoneNumber.message(type: fieldType)
            
            case .countryCode:
                return isValidCountryCode.message(type:fieldType)
            
            case .zipCode:
                return isValidZipCode.message(type:fieldType)
            
            case .address:
                return isValidAddress.message(type:fieldType)
        }
    }
    
    
    
    var isNumber1 : Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    var hasSpecialCharcters : Bool {
        return  rangeOfCharacter(from: CharacterSet.letters.inverted) != nil
    }
    
    var isEveryCharcterZero : Bool{
        var count = 0
        self.forEach {
            if $0 == "0"{
                count += 1
            }
        }
        if count == self.count{
            return true
        }else{
            return false
        }
    }
    
    
    
    public func toString(format: String , date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public var length: Int {
        return self.count
    }
    
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    func isValid() -> Status {
        if length < 0 { return .empty }
        if isBlank  { return .allSpaces }
        return .valid
    }
    
    func isValid(Regexpassword min: Int , max: Int) -> Status {
        if length < 0 { return .empty }
        if isBlank  { return .allSpaces }
        if !(self.count >= min && self.count <= max){
            return .pwd
        }
        let isPasswordFormat = checkPassword(text: self)
        if !isPasswordFormat { return .passwordFormat }
        return .valid
    }
    
    func checkPassword(text : String?) -> Bool{
        let regex = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&!^~-]).{8,15})"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: text)
        if isMatched{
            return true
        }else {
            return false
        }
    }
    
    var isValidInformation : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }
    
    var isValidExtension : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if self.self.count < 6  && isNumber1 { return .valid }
        if self.self.count == 0 { return .valid }
        return .inValid
    }
    
    var isValidEmail : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        // if isEmail { return .valid }
        if !isValidRegEx(self, RegEx.email){return .inValid}
        
        return .valid
    }
    
    func  isValid(password min: Int , max: Int) -> Status {
        if length < 0 { return .empty }
        if isBlank  { return .allSpaces }
        if !(self.count >= min && self.count <= max){
            return .passwordFormat
        }
        //        let isPasswordFormat = checkPassword(text: self)
        //        if !isPasswordFormat { return .passwordFormat }
        return .valid
    }
    
    var isValidPhoneNumber : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        if isEveryCharcterZero { return .allZeros }
        // if !hasSpecialCharcters { return .emptyCountrCode }
        if self.count >= 6 && self.count <= 15 { return .valid
        }else{
            return .mobileNumberLength
        }
    }
    
    var isValidCountryCode : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        
        return .valid
    }
    
    var isValidName : Status {
        if self == "" {return .empty}
        if length < 0 { return .empty }
//        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        //if !isValidRegEx(self, RegEx.alphabeticStringWithSpace){return .hasSpecialCharacter}
        if length < 2 || length > 40{return .nameLength}
        return .valid
    }
    
    var isValidFullName : Status {
        if self == "" {return .empty}
        if length < 0 { return .empty }
        if !isValidRegEx(self, RegEx.alphabeticStringWithSpace){return .hasSpecialCharacter}
        if length < 2 || length > 40{return .nameLength}
        return .valid
    }
    
    func isValidCardNumber(length max:Int ) -> Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if self.count >= 16 && self.count <= max{
            return .valid
        }
        return .inValid
    }
    
    var isValidCVV : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if isNumber1{
            if self.count >= 3 && self.count <= 4{
                return .valid
            }else{ return .inValid }
        }else { return .notANumber }
    }
    
    var isValidZipCode : Status {
        if length < 0 { return .empty }
        if isEveryCharcterZero { return .allZeros }
        if isBlank { return .allSpaces }
//        if hasSpecialCharcters {
//            return .zip}
        if length != 6 {return .pinCode}
        if !isNumber1{ return .notANumber }
        
        return .valid
    }
    
    var isValidAmount :  Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if !isNumber1{ return .notANumber }
        return .valid
    }
    
    var isValidAddress: Status {
        if length < 0 { return .empty}
        if length != 2 {return .address}
        return .valid
    }
}

extension String {
    
    func login(email : String? , password : String?) -> Bool {
        if  isValid(type: .email, info: email) && isValid(type: .loginPassword, info: password) { return true }
        
        return false
    }
    
    func emailValidation(email: String?) -> Bool {
        if isValid(type: .email, info: email) { return true}
        return false
    }
    
    func signUp(firstName : String?, lastName: String?,  email : String?, phone : String?, zipCode: String?, password : String?, confirmPassword: String? ) -> Bool {
        if isValid(type : .firstName , info : firstName) && isValid(type: .lastName, info: lastName) &&  isValid(type : .email , info : email)   && isValid(type : .phone , info : phone) && isValid(type : .zipCode , info : zipCode) && isValid(type : .password , info : password) && isValid(type : .confirmPassword , info : confirmPassword){
            return true
        }
        return false
    }
    
    func myProfile(firstName:String?, lastName: String?, email: String?, phone: String?, zipCode: String?) -> Bool {
        if isValid(type: .firstName, info: firstName) && isValid(type: .lastName, info: lastName) && isValid(type: .email, info: email) && isValid(type: .phone, info: phone) && isValid(type: .zipCode, info: zipCode)  {
            return true
        }
        return false
    }
 }
