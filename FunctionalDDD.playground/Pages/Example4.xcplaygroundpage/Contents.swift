//: [Previous](@previous)

import Foundation

typealias Money = Int
typealias PositiveMoney = Money
typealias BillingMoney = PositiveMoney?
typealias Price = PositiveMoney

struct Account {
    let id: String
    let balance: Money
}

struct PaymentDocument {
    let id: String
    let total: Money
}

struct OrderedPaymentDocuments {
    let first: PaymentDocument
    let other: [PaymentDocument]
    let total: PositiveMoney
    let partner: Account
}

struct ProposedAccountPayment {
    let amount: Money
}

enum AccountPayment {
    case add(PositiveMoney, Account)
    case charge(PositiveMoney, Account)
}

typealias ValidateAccountPayment = (ProposedAccountPayment, Account) -> AccountPayment?

typealias ChequeNumber = Int

typealias ValidateChequeNumber = (Int) -> ChequeNumber?

enum PaymentMethod {
    case cash
    case transfer
    case cheque(ChequeNumber)
}

enum AccountPaymentMethod {
    case charge(PositiveMoney)
    case partialCharge(PositiveMoney, method: PaymentMethod)
    case add(PositiveMoney, method: PaymentMethod)
}

enum PaymentMethodInfo {
    case direct(PaymentMethod)
    case account(AccountPaymentMethod)
}

struct Payment {
    let total: BillingMoney
    let method: PaymentMethodInfo
    let documents: OrderedPaymentDocuments
}

typealias PaymentService = (AccountPayment?, PaymentMethod?, OrderedPaymentDocuments) -> Result<Payment, [Swift.Error]>



//: [Next](@next)
