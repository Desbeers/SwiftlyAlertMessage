//
//  ContentView.swift
//  AlertMessages
//
//  Created by Nick Berendsen on 06/09/2023.
//

import SwiftUI
import SwiftlyAlertMessage

struct ContentView: View {
    /// The error alert
    @State private var error: AlertMessage?
    /// The confirmation dialog
    @State private var confirm: AlertMessage?
    /// The response from the buttons
    @State private var response: String?
    /// The text in the form
    @State private var text: String = "Current text"
    /// The body of the `View`
    var body: some View {
        VStack {
#if !os(tvOS)
            Text("Alerts and Confirmation Dialogs")
                .font(.largeTitle)
#endif
            LabeledContent("Error Alerts") {
                Text("Errors defined in this application")
                    .foregroundStyle(.secondary)
                Button("Unknown Error") {
                    error = AppError.unknownError.alert()
                }
                Button("Unknown Error with action") {
                    error = AppError.unknownError.alert {
                        response = "Apologies Accepted"
                    }
                }
                Button("File Exist Error with action") {
                    error = AppError.fileExtists.alert {
                        response = "The user is thinking about it"
                    }
                }
                Text("Error that was just thrown at us from the system")
                    .foregroundStyle(.secondary)
                Button("A Good'oll NSError message") {
                    let info = [
                      NSLocalizedDescriptionKey:
                        "The reference was bad",
                      NSLocalizedFailureReasonErrorKey:
                        "Bad Reference",
                      NSLocalizedRecoverySuggestionErrorKey:
                        "Try using a good one."
                    ]

                    let badReferenceNSError = NSError(
                      domain: "ReferenceDomain",
                      code: 42,
                      userInfo: info
                    )
                    error = badReferenceNSError.alert {
                        response = "Welcome to the new world!"
                    }
                }
            }
            LabeledContent("Confirmation Dialogs") {
                Button("Confirm overwrite file") {
                    confirm = AppError.overwriteFile.alert(role: .destructive) {
                        response = "The file is overwritten"
                    }
                }
                Text("The button has a 'destructive' role")
                    .foregroundStyle(.tertiary)
                    .padding(.bottom)
                Text("A form with a value")
                    .foregroundStyle(.secondary)
                TextField("Text", text: $text, prompt: Text("Default text"))
                    .frame(width: 300)
                    .labelsHidden()
                Button("Clear text") {
                    confirm = AppError.unsavedData.alert {
                        text = ""
                        response = "The form is cleared"
                    }
                }
                .disabled(text.isEmpty)
            }
            LabeledContent("Button response") {
                Text(response ?? "...")
            }
        }
        .padding(20)
        .frame(maxHeight: .infinity)
        .task(id: response) {
            if response != nil {
                try? await Task.sleep(for: .seconds(4))
                response = nil
            }
        }
        .buttonStyle(.bordered)
        .labeledContentStyle(GroupStyle())
        .animation(.default, value: response)
        .errorAlert(message: $error)
        .confirmationDialog(message: $confirm)
    }
}

struct GroupStyle: LabeledContentStyle {
#if os(tvOS)
    let frameWidth: Double = 800
#else
    let frameWidth: Double = 400
#endif
    /// The modifier
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top) {
            configuration.label
                .font(.headline)
                .frame(width: frameWidth / 2, alignment: .trailing)
            VStack(alignment: .leading) {
                configuration.content
            }
            .padding()
            .frame(width: frameWidth, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.accentColor.opacity(0.1))
            )

        }
    }
}
