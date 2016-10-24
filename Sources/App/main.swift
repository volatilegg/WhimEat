import Vapor
import VaporMySQL

let drop = Droplet()

drop.preparations = [Restaurant.self]

try drop.addProvider(VaporMySQL.Provider.self)

let restaurantController = RestaurantController()

drop.get { request in
    guard let res = try restaurantController.random(request: request) as? Restaurant else {
        return try drop.view.make("welcome", [
            "message": drop.localization[request.lang, "Not thing to do here"]
            ])
    }
    
    return try drop.view.make("welcome", [
        "message": drop.localization[request.lang, res.name ?? "Nothing to do here"]
        ])
}

drop.post("restaurant", "create") { (request) in
    return try restaurantController.create(request: request)        
}

drop.resource("restaurant", RestaurantController())

drop.run()
