//
//  Error.swift
//  banking-services
//
//  Created by Patsicha Tongteeka on 9/18/19.
//  Copyright © 2019 Patsicha Tongteeka. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(result: T)
    case failure(error: Error)
}

enum ReturnError: Error {
    case apiError(code: String, header: String?, message: String?)
    case invalidJSON
}

enum UserResult<T> {
    case success(result: T)
    case failure(userError: UserError)
}

struct UserError: Error, Equatable {
    public let type: ErrorType
    public let header: String?
    public let message: String
    public let redirectURL: String?
    
    public init(type: ErrorType, header: String? = nil, message: String, redirectURL: String? = nil) {
        if let hadHeader = header, !hadHeader.isEmpty {
            self.header = hadHeader
        } else {
            self.header = "Error"
        }
        
        self.type = type
        self.message = message
        self.redirectURL = redirectURL
    }
    
    public enum ErrorType {
        case terminate
        case offline
        case alert
        case discreet
        case appOutdated
    }
}

extension UserError {
    /// Given an ErrorMap, return the UserError for a specific status code
    public init?(for code: String, header: String? = nil, description: String? = nil, redirectURL: String? = nil, with errorMap: ErrorMap) {
        
        guard let (type, title, message) = errorMap[code]
            else { return nil }
        
        let hdr = title ?? header ?? "Error"
        let msg = message ?? description ?? "Error"
        self = UserError(type: type, header: hdr, message: msg, redirectURL: redirectURL)
    }
    
    public init(errorType: ErrorType, header: String? = nil, message: String, redirectURL: String? = nil) {
        self = UserError(type: errorType, header: header, message: message, redirectURL: redirectURL)
    }
    
    public static func generic() -> UserError {
        return UserError(type: .discreet, header: "Error", message: "Generic Error")
    }
    
    public static func terminate() -> UserError {
        return UserError(type: .terminate, header: "Error", message: "Terminate Error")
    }
    
    public static func offline() -> UserError {
        return UserError(type: .discreet, header: "Error", message: "Offline Error")
    }
}

extension UserResult {
    public static func genericFailure() -> UserResult {
        return UserResult.failure(userError: UserError.generic())
    }
    
    public static func terminateFailure() -> UserResult {
        return UserResult.failure(userError: UserError.terminate())
    }
}

typealias ErrorMap = [String: (errorType: UserError.ErrorType, header: String?, message: String?)]


extension Error {
    /// Converts any Error to an UserError
    func userError(with errorMap: ErrorMap? = nil) -> UserError {
        // Imediate case
        if let userError = self as? UserError {
            return userError
        }
        
        // If there's an error map and self is an API Error, try to create a UserError from there
        if let returnError = self as? ReturnError,
            case let .apiError(code: code, header: header, message: message) = returnError {
            if let errorMap = errorMap, let userError = UserError(for: code, header: header, description: message, with: errorMap) {
                return userError
            }
            if let message = message {
                return UserError(type: .discreet, header: header, message: message)
            }
        }
        return UserError.generic()
    }
}

extension Result {
    /// Converts any Result to an UserResult
    func userResult(with errorMap: ErrorMap? = nil) -> UserResult<T> {
        switch self {
        case .success(result: let any):
            return UserResult<T>.success(result: any)
        case .failure(error: let error):
            return UserResult<T>.failure(userError: error.userError(with: errorMap))
        }
    }
}
