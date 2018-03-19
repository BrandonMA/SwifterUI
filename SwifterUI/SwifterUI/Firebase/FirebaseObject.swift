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

public protocol FirebaseObject: Codable {
    
    // MARK: - Instance Properties
    
    var id: String { get set }
    var reference: DocumentReference { get set }
    
    // MARK: - Instance Methods
    
    func encodeData(completion: @escaping ([String: Any]) -> Void, errorCompletion: ((Error?) -> Void)?)
    func upload(successCompletion: (() -> Void)?, errorCompletion: ((Error?) -> Void)?)
    func update(successCompletion: (() -> Void)?, errorCompletion: ((Error?) -> Void)?)
}

public extension FirebaseObject {
    
    func encodeData(completion: @escaping ([String: Any]) -> Void, errorCompletion: ((Error?) -> Void)?) {
        DispatchQueue.addAsyncTask(to: .background) {
            do {
                let encodedData = try FirestoreEncoder().encode(self)
                completion(encodedData)
            } catch let error {
                errorCompletion?(error)
            }
        }
    }
    
    func upload(successCompletion: (() -> Void)? = nil, errorCompletion: ((Error?) -> Void)? = nil) {
        encodeData(completion: { (data) in
            self.reference.setData(data, completion: { (error) in
                if let error = error {
                    errorCompletion?(error)
                } else {
                    successCompletion?()
                }
            })
        }) { (error) in
            errorCompletion?(error)
        }
    }
    
    func update(successCompletion: (() -> Void)? = nil, errorCompletion: ((Error?) -> Void)? = nil) {
        encodeData(completion: { (data) in
            self.reference.updateData(data, completion: { (error) in
                if let error = error {
                    errorCompletion?(error)
                } else {
                    successCompletion?()
                }
            })
        }) { (error) in
            errorCompletion?(error)
        }
    }
    
}
