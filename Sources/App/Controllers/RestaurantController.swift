import Vapor
import HTTP

final class RestaurantController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Restaurant.all().makeNode().converted(to: JSON.self)
    }
    
    func random(request: Request) throws -> ResponseRepresentable {
        let restaurants = try Restaurant.all()
        
        guard restaurants.count > 0 else {
            throw Abort.custom(status: .badRequest, message: "could not find restaurant")
        }
        
        return restaurants.random()
    }

    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: .badRequest, message: "no name dumb ass")
        }
        
        var restaurant = Restaurant(name: name)
        try restaurant.save()
        
        return restaurant
    }
    
    func show(request: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        return restaurant
    }
    
    func delete(request: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        try restaurant.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Restaurant.query().delete()
        return JSON([])
    }
    
    func replace(request: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        try restaurant.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Restaurant> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}
