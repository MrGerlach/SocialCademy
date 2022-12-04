//
//  ErrorHandler.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 06/11/2022.
//

import Foundation

@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }
}

extension StateManager {
    typealias Action = () async throws -> Void
    
    nonisolated func withStateManagingTask(perform action: @escaping Action) {
        Task {
            await withStateManagement(perform: action)
        }
    }
    
    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        isWorking = false
    }
}

extension StateManager {
    var isWorking: Bool {
        get { false }
        set {}
    }
}
