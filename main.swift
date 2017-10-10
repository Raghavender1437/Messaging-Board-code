
import MongoKitten
import Vapor


print("Hello, world!")

let drop = Droplet()

let server = try Server(mongoURL: "mongodb://localhost/")
let database = server["MKTutorial"]

drop.get { req in
    
    return try drop.view.make("welcome", ["message":drop.localization[req.lang, "WELCOME", "title"]])
    
}

//GET
drop.get("hello") { req in
    return "Hello, Mongokitten!"
}

//POST
drop.post("message") { req in
    
    guard
        let username = req.data["username"]?.string,
        let email = req.data["email"]?.string,
        let message = req.data["message"]?.string else {
            throw Abort.badRequest
    }
    
    let user = Message(username:username, email: email, message:message)
    
    try user.save()
    
    return "Created a User with username: \(user.username), email:\(user.email), message:\(message)"
    
    
}

drop.get("message") { req in
    
    guard let id = req.headers["id"]?.string else {
        throw Abort.badRequest
    }
    
    let user = try Message(id: id)
    
    return "User found with Username \(user.username), email:\(user.email), message:\(user.message) "
    
}
drop.run()
