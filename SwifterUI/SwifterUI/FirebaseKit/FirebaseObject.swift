
//  FirebaseObject.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 19/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import FirebaseFirestore
import CodableFirebase
import PromiseKit

public protocol FirebaseObject: Codable {

    // MARK: - Instance Properties

    var identifier: String { get set }
    var reference: DocumentReference { get set }

    // MARK: - Instance Methods

    func encodeData() -> Promise<[String: Any]>
}

public extension FirebaseObject {

    public func encodeData() -> Promise<[String: Any]> {
        return Promise { seal in
            DispatchQueue.addAsyncTask(to: .background) {
                do {
                    let encodedData = try FirestoreEncoder().encode(self)
                    seal.fulfill(encodedData)
                } catch let error {
                    seal.reject(error)
                }
            }
        }
    }

    @discardableResult
    public func upload() -> Promise<Void> {
        return firstly {
            encodeData()
        }.then({ data in
            return self.reference.set(data: data)
        })
    }

    @discardableResult
    public func update() -> Promise<Void> {
        return firstly {
            encodeData()
        }.then({ data in
            return self.reference.update(data: data)
        })
    }
    
    @discardableResult
    public func save() -> Promise<Void> {
        return Promise { seal in
            update().done({
                seal.fulfill(()) // If it works then fulfill
            }).catch({ error in
                // If there is an error try to upload the entire object
                self.upload().done({
                    seal.fulfill(()) // If it works then fulfill
                }).catch({ (error) in
                    seal.reject(error) // If it doesn't there is an external error probably with the database
                })
            })
        }
    }

    @discardableResult
    public func delete() -> Promise<Void> {
        return self.reference.delete()
    }

}

public extension FirebaseObject where Self: NSObject {

    @discardableResult
    public func startListener() -> Promise<Void> {
        return Promise { seal in
            DispatchQueue.addAsyncTask(to: .background, handler: {
                self.reference.addSnapshotListener({ (document, error) in
                    if let document = document, let data = document.data() {
                        self.setValuesForKeys(data)
                        self.receivedUpdate()
                        seal.fulfill(())
                    } else if let error = error {
                        seal.reject(error)
                    }
                })
            })
        }
    }
    
    public func receivedUpdate() {
        
    }

}


