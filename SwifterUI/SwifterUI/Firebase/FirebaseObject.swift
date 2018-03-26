//
//  FirebaseObject.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 19/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase
import PromiseKit

public protocol FirebaseObject: Codable {

    // MARK: - Instance Properties

    var id: String { get set }
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

    public func upload() -> Promise<Void> {

        return Promise { seal in

            encodeData().done({ data in

                self.reference.setData(data, completion: { error in
                    if let error = error {
                        seal.reject(error)
                    } else {
                        seal.fulfill(())
                    }
                })

            }).catch({ (error) in

                seal.reject(error)

            })

        }

    }

    public func update() -> Promise<Void> {

        return Promise { seal in

            encodeData().done({ data in

                self.reference.updateData(data, completion: { error in
                    if let error = error {
                        seal.reject(error)
                    } else {
                        seal.fulfill(())
                    }
                })

            }).catch({ (error) in
                seal.reject(error)
            })

        }
    }

    public func delete() -> Promise<Void> {

        return Promise { seal in

            self.reference.delete(completion: { (error) in

                if let error = error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }

            })

        }

    }

}

public extension FirebaseObject where Self: NSObject {

    public func startListener() -> Promise<Void> {

        return Promise { seal in
            DispatchQueue.addAsyncTask(to: .background, handler: {
                self.reference.addSnapshotListener({ (document, error) in
                    if let document = document, let data = document.data() {
                        self.setValuesForKeys(data)
                        seal.fulfill(())
                    } else {
                        seal.resolve(error)
                    }
                })
            })
        }
    }

}
