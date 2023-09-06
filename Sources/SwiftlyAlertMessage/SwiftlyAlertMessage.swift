//
//  AlertMessage.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/09/2023.
//

import SwiftUI

public struct AlertMessage {
    public init(error: Error, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.error = error
        self.role = role
        self.action = action
    }
    public let error: Error
    public let role: ButtonRole?
    public let action: (() -> Void)?
}

extension AlertMessage {
    /// Wrap an `Error` into a `LocalizedError`
    ///
    /// This to avoid an error:
    /// Protocol ‘LocalizedError’ as a type cannot conform to the protocol itself
    struct LocalizedAlertError: LocalizedError {
        let underlyingError: LocalizedError
        var errorDescription: String? {
            underlyingError.errorDescription
        }
        var recoverySuggestion: String? {
            underlyingError.recoverySuggestion
        }

        var helpAnchor: String? {
            underlyingError.helpAnchor
        }

        init?(error: Error?) {
            guard let localizedError = error as? LocalizedError else { return nil }
            underlyingError = localizedError
        }
    }
}

extension View {
    func errorAlert(error: Binding<AlertMessage?>) -> some View {
        let localizedAlertError = AlertMessage.LocalizedAlertError(error: error.wrappedValue?.error)
        return alert(
            isPresented: .constant(localizedAlertError != nil),
            error: localizedAlertError,
            actions: { _ in
                Button(localizedAlertError?.helpAnchor ?? "OK") {
                    error.wrappedValue = nil
                }
            },
            message: { error in
                Text(error.recoverySuggestion ?? "")
            }
        )
    }
}

extension View {
    func confirmationAlert(confirm: Binding<AlertMessage?>) -> some View {
        let localizedAlertError = AlertMessage.LocalizedAlertError(error: confirm.wrappedValue?.error)
        return confirmationDialog(
            localizedAlertError?.errorDescription ?? "Confirm",
            isPresented: .constant(localizedAlertError != nil),
            actions: {
                Button(localizedAlertError?.helpAnchor ?? "OK", role: confirm.wrappedValue?.role) {
                    if let action = confirm.wrappedValue?.action {
                        action()
                    }
                    confirm.wrappedValue = nil
                }
                Button("Cancel", role: .cancel, action: {
                    confirm.wrappedValue = nil
                })
            },
            message: {
                Text(localizedAlertError?.recoverySuggestion ?? "")
            }
        )
    }
}

extension Error {

    func alert(role: ButtonRole? = nil, action: (() -> Void)? = nil) -> AlertMessage {
        AlertMessage(error: self, role: role, action: action)
    }
}
