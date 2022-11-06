//
//  Firestore+Extensions.swift
//  SocialCademy
//
//  Created by Michał Gerlach on 06/11/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            } /// Method only throws if there’s an encoding error, which indicates a problem with our model.
            /// We handled this with a force try, while all other errors are passed to the completion handler.
        }
    }
}

extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: type)
        }
    }
}
