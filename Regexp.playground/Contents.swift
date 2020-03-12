//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

enum Result<Value, ErrorReason> {
    case success(Value)
    case failure(ErrorReason)
}

enum Either<L, R> {
    case left(L)
    case right(R)
}

//private val DEFAULT_PASSWORD_REQUIREMENT = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#\$^+=!*()@%&]).{6,100}\$"


let emailPattern = "^.+@.+\\..+$"
let uppercasePattern = "^.*?[A-Z].*?$"
let lowercasePattern = "^.*?[a-z].*?$"
let phonePattern =  "^\\d{3}-\\d{3}-\\d{4}$"
let validatePattern = "^\\d{2}(.)\\d{3}(.)\\d{3}\\d{1}-\\d{3}(.)\\{3}$"
let customPattern = "^\\d{2}\\.\\d{3}\\.\\d{3}\\.\\d{1}-\\d{3}\\.\\d{3}$"

let containsUpperCasePattern = "^.*?[A-Z].*?$"
let containsLowerCasePattern = "^.*?[a-z].*?$"
let containsDigitPattern = "^.*?\\d.*?$"
let containsSpecialCharactersPattern = "^.*?[#\\$^+=!*()@%&].*?$"

let emailValue = "test@enterpryze.com"
let phoneValue = "000-000-0000"
let validateValue = "00.000.000.0-000.000"
let customValue = "00.999.333.1-666.222"

let pattern = customPattern
let value = customValue

let predicate = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
print(predicate)
