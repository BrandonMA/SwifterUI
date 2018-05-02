//
//  CollectionReference.swift
//  WhatsDoc
//
//  Created by brandon maldonado alonso on 15/04/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import FirebaseFirestore
import PromiseKit

extension CollectionReference {
    
    func getDocuments(field: String, isEqualTo: Any) -> Promise<QuerySnapshot> {
        return Promise { seal in
            whereField(field, isEqualTo: isEqualTo).getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    seal.reject(error)
                } else if let snapshot = snapshot {
                    seal.fulfill(snapshot)
                }
            })
        }
    }
}
