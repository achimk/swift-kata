//: [Previous](@previous)

import Foundation
import XCPlayground
import PlaygroundSupport


typealias Money = Int
typealias PositiveMoney = Money


typealias PaymentDocumentId = String

enum PaymentDocumentType {
    case saleInvoice
    case saleCreditNote
    case purchaseInvoice
    case purchaseCreditNote
}

struct PaymentDocument {
    let id: PaymentDocumentId
    let type: PaymentDocumentType
    let date: Date
    let total: Money
}

struct ConfirmedPaymentDocuments {
    let first: PaymentDocument
    let other: [PaymentDocument]
    let total: PositiveMoney
}

enum BusinessPartnerKind {
    case supplier(BusinessPartnerInfo)
    case customer(BusinessPartnerInfo)
}

typealias BusinessPartnerId = String

struct BusinessPartnerInfo {
    let id: BusinessPartnerId
}

enum OrderPaymentType {
    case sale
    case purchase
}

struct OrderedPaymentDocuments {
    let type: OrderPaymentType
    let partner: BusinessPartnerInfo
    let documents: ConfirmedPaymentDocuments
}

typealias PaymentDocumentFilter = (PaymentDocument) -> Bool

typealias PaymentDocumentsCalculator = ([PaymentDocument]) -> PositiveMoney?

typealias ConfirmedPaymentDocumentsService = ([PaymentDocument], PaymentDocumentsCalculator, PaymentDocumentFilter) -> ConfirmedPaymentDocuments?

typealias OrderPaymentDocumentsService = (BusinessPartnerInfo, [PaymentDocument]) -> OrderedPaymentDocuments?

typealias ChequeNumber = Int

enum AccountPayment {
    case advance(PositiveMoney)
    case charge(PositiveMoney)
}

enum PaymentMethod {
    case cash
    case transfer
    case cheque(ChequeNumber)
}

enum AccountPaymentMethod {
    case accountCharge(PositiveMoney)
    case accountPartialCharge(PositiveMoney, method: PaymentMethod)
    case accountAdvance(PositiveMoney, method: PaymentMethod)
    case method(PaymentMethod)
}

typealias AccountPaymentMethodService = (AccountPayment?, PaymentMethod?, OrderedPaymentDocuments) -> AccountPaymentMethod?

enum PaymentType {
    case incoming
    case outgoing
}

struct Payment {
    let total: Money
    let method: AccountPaymentMethod
    let documents: OrderedPaymentDocuments
}

typealias PaymentService = (OrderedPaymentDocuments, AccountPaymentMethod) -> Payment?


class PaymentForm {
    
    func set(accountPayment: AccountPayment?) {
        
    }
    
    func set(paymentMethod: PaymentMethod?) {
        
    }
    
}

//: [Next](@next)
