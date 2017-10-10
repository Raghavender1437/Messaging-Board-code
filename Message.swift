//
//  Message.swift
//  SwiftEngineTest
//
//  Created by Raghavender reddy Marpadaga on 9/8/17.
//
//

import Foundation
import MongoKitten

let collection = database["message"]


struct Message {
    
    var id: ObjectId
    var username: String
    var email: String
    var message: String
    
    var document: Document {
        
        return ["_id":self.id,
                "username" : self.username,
                "email" : self.email,
                "message" : self.message]
    }
    
    var documentForSave: Document {
        return ["username" : self.username,
                "email" : self.email,
                "message" : self.message]
        
    }
    
    init(username: String, email: String, message: String) {
        
        self.id = ObjectId()
        self.username = username
        self.email = email
        self.message = message
    }
    
    init(id: String) throws {
        
        let objectID = try ObjectId(id)
        let query: Query = "_id" == objectID
        
        guard let user = try collection.findOne(matching: query) else {
            fatalError()
        }
        
        guard
            let username = user.dictionaryValue["username"] as? String,
            let email = user.dictionaryValue["username"] as? String,
            let message = user.dictionaryValue["message"] as? String  else {
                fatalError()
        }
        
        self.id = objectID
        self.username = username
        self.email = email
        self.message = message
    }
    
    //Curd
    
    func save() throws {
        
        let query: Query = "_id" == self.id
        
        try collection.update(matching: query, to: self.documentForSave, upserting: true)
    }
    
    func delete() throws {
        
        try collection.remove(matching: "_id" == self.id)
    }
    
}
