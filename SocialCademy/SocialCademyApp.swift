//
//  SocialCademyApp.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 08/10/2022.
//

import SwiftUI
import Firebase

@main
struct SocialCademyApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
