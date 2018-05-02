//
//  StorageReference.swift
//  WhatsDoc
//
//  Created by brandon maldonado alonso on 14/04/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import PromiseKit
import Firebase

public extension StorageReference {
    
    public func upload(file: URL, metadata: StorageMetadata? = nil) -> Promise<StorageMetadata?> {
        return Promise { seal in
            putFile(from: file, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(metadata)
                }
            })
        }
    }
    
    public func upload(data: Data, metadata: StorageMetadata? = nil) -> Promise<StorageMetadata?> {
        
        return Promise { seal in
            putData(data, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(metadata)
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
    
}
