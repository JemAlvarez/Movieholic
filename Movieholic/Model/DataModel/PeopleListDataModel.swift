//

import Foundation
 
struct PeopleListDataModel: Decodable { // people JSON data model
    let profile_path: String?
    let id: Int
    let name: String
}

struct PeopleListDataModelBase: Decodable { // base json
    let page: Int
    let results: [PeopleListDataModel]
    let total_pages: Int
}
