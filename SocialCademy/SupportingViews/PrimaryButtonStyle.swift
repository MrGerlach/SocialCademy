//
//  PrimaryButtonStyle.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 26/10/2022.
//

import SwiftUI

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
     
        func makeBody(configuration: Configuration) -> some View {
            Group {
                if isEnabled {
                    configuration.label
                } else {
                    ProgressView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
            .animation(.default, value: isEnabled)
        }
}


// --------------------- DANGER !!! ----------------------------
//                       DEBUG AREA
//                          :)
#if DEBUG
struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPreview(disabled: false)
        ButtonPreview(disabled: true)
    }

    private struct ButtonPreview: View {
        let disabled: Bool

        var body: some View {
            Button("Sign In", action: {})
                .buttonStyle(.primary)
                .padding()
                .previewLayout(.sizeThatFits)
                .disabled(disabled)
        }
    }
}
#endif

//struct PrimaryButtonStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        PrimaryButtonStyle()
//    }
//}
