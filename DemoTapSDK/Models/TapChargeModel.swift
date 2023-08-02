//
//  TapChargeModel.swift
//  DemoTapSDK
//
//  Created by Kokila Ekanayake on 8/2/23.
//

import Foundation

// MARK: - TapChargeModel
struct TapChargeModel: Codable {
    var id, object: String?
    var liveMode, customerInitiated: Bool?
    var apiVersion, method, status: String?
    var amount: Int?
    var currency: String?
    var threeDSecure, cardThreeDSecure, saveCard: Bool?
    var merchantID, product, description: String?
    var metadata: Metadata?
    var order: Order?
    var transaction: Transaction?
    var reference: Reference?
    var response: Response?
    var receipt: Receipt?
    var customer: Customer?
    var merchant: Merchant?
    var source: Source?
    var redirect, post: Post?
    var activities: [Activity]?
    var autoReversed: Bool?

    enum CodingKeys: String, CodingKey {
        case id, object
        case liveMode = "live_mode"
        case customerInitiated = "customer_initiated"
        case apiVersion = "api_version"
        case method, status, amount, currency, threeDSecure
        case cardThreeDSecure = "card_threeDSecure"
        case saveCard = "save_card"
        case merchantID = "merchant_id"
        case product, description, metadata, order, transaction, reference, response, receipt, customer, merchant, source, redirect, post, activities
        case autoReversed = "auto_reversed"
    }
}

// MARK: - Activity
struct Activity: Codable {
    var id, object: String?
    var created: Int?
    var status, currency: String?
    var amount: Int?
    var remarks: String?
}

// MARK: - Customer
struct Customer: Codable {
    var firstName, lastName, email: String?
    var phone: Phone?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
    }
}

// MARK: - Phone
struct Phone: Codable {
    var countryCode, number: String?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case number
    }
}

// MARK: - Merchant
struct Merchant: Codable {
    var id: String?
}

// MARK: - Metadata
struct Metadata: Codable {
    var udf1: String?
}

// MARK: - Order
struct Order: Codable {
}

// MARK: - Post
struct Post: Codable {
    var status: String?
    var url: String?
}

// MARK: - Receipt
struct Receipt: Codable {
    var email, sms: Bool?
}

// MARK: - Reference
struct Reference: Codable {
    var transaction, order: String?
}

// MARK: - Response
struct Response: Codable {
    var code, message: String?
}

// MARK: - Source
struct Source: Codable {
    var object, id: String?
}

// MARK: - Transaction
struct Transaction: Codable {
    var timezone, created: String?
    var url: String?
    var expiry: Expiry?
    var asynchronous: Bool?
    var amount: Int?
    var currency: String?
}

// MARK: - Expiry
struct Expiry: Codable {
    var period: Int?
    var type: String?
}
