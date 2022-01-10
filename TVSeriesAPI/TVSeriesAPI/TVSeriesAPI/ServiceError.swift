//
//  ServiceError.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 10.01.2022.
//

public enum ServiceError: Error {
    case urlCreationError
    case requestFailed
    case decodeError
    case dataTaskError(_ message: String)
    case unknown(_ statusCode: Int)
    case information(_ code: Int)
    case redirection(_ code: Int)
    case clientError(_ code: Int)
    case serverError(_ code: Int)
    
    static func decideError(_ statusCode: Int) -> ServiceError {
        if (100...199).contains(statusCode) {
            return ServiceError.information(statusCode)
        } else if (300...399).contains(statusCode) {
            return ServiceError.redirection(statusCode)
        } else if (400...499).contains(statusCode) {
            return ServiceError.clientError(statusCode)
        } else if (500...599).contains(statusCode) {
            return ServiceError.serverError(statusCode)
        } else {
            return ServiceError.unknown(statusCode)
        }
    }
}
