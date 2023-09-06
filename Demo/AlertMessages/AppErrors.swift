//
//  AppErrors.swift
//  AlertMessages
//
//  Created by Nick Berendsen on 06/09/2023.
//

import Foundation

enum AppError: LocalizedError {
    case fileExtists
    case overwriteFile
    case unsavedData
    case unknownError

    public var description: String {
        switch self {
        case .fileExtists:
            "A file with this name already exist"
        case .overwriteFile:
            "Are you sure you want to overwrite this file?"
        case .unsavedData:
            "Are you sure you want to clear the form?"
        case .unknownError:
            "Unknown error"
        }
    }

    public var errorDescription: String? {
        return description
    }

    public var failureReason: String? {
        switch self {
        case .fileExtists:
            "Existing File"
        case .overwriteFile:
            "Overwrite File"
        case .unsavedData:
            "Unsaved Data"
        case .unknownError:
            "Unknown error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .fileExtists:
            "Please select another name."
        case .overwriteFile:
            "This can not be undone."
        case .unsavedData:
            "Changes to this form will be lost."
        case .unknownError:
            "Sorry..."
        }
    }
    
    /// This will be the label of the button
    var helpAnchor: String? {
        switch self {
        case .fileExtists:
            "I might do that"
        case .overwriteFile:
            "Overwrite"
        case .unsavedData:
            "I don't care"
        default:
            nil
        }
    }
}
