import Vapor
import Fluent
import Foundation

struct Restaurant: Model {
    var id: Node?
    var name: String?    
    var dauma: String?
    var dauma2: Int?
    var exists: Bool = false
    
    init(name: String) {
        self.id = UUID().uuidString.makeNode()
        self.name = name
    }
}

extension Restaurant: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        name = node["name"]?.string
        dauma = node["dauma"]?.string
    }
    
    func makeNode(context: Context) throws -> Node {        
        return try Node(node: [
            "id": id,
            "name": name
            ])
    }
}

extension Restaurant: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("restaurants", closure: { (restaurants) in
            restaurants.id()
            restaurants.string("name")
        })
    }

    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}
