//
//  DocumentReference.swift
//  WhatsDoc
//
//  Created by brandon maldonado alonso on 14/04/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import FirebaseFirestore
import PromiseKit

enum FirestoreError: Error {
    case Unknown
}

public extension DocumentReference {
    
    public func getDocument() -> Promise<(DocumentSnapshot, [String: Any])> {
        return Promise { seal in
            getDocument(completion: { (snapshot, error) in
                if let error = error {
                    seal.reject(error)
                } else if let snapshot = snapshot, let data = snapshot.data() {
                    seal.fulfill((snapshot, data))
                } else {
                    seal.reject(FirestoreError.Unknown)
                }
            })
        }
    }
    
    public func delete() -> Promise<Void> {
        return Promise { seal in
            delete(completion: { (error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            })
        }
    }
    
    public func set(data: [String: Any]) -> Promise<Void> {
        return Promise { seal in
            setData(data, completion: { (error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            })
        }
    }
    
    public func update(data: [String: Any]) -> Promise<Void> {
        return Promise { seal in
            updateData(data, completion: { (error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            })
        }
    }
    
}
