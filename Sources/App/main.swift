import Vapor
import VaporMySQL

let drop = Droplet()

drop.preparations = [Restaurant.self]

try drop.addProvider(VaporMySQL.Provider.self)

let restaurantController = RestaurantController()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.post("restaurant", "create") { (request) in
    return try restaurantController.create(request: request)        
}

drop.get("restaurant", "random") { (request) in
    guard let res = try restaurantController.random(request: request) as? Restaurant else {
        return try drop.view.make("welcome", [
            "message": drop.localization[request.lang, "Not thing to do here"]
            ])
    }
    
    return try drop.view.make("welcome", [
        "message": drop.localization[request.lang, res.name ?? "Nothing to do here"]
        ])
}

drop.resource("restaurant", RestaurantController())

drop.run()
