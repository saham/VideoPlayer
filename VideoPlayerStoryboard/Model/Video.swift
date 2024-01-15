import Foundation
struct Video :Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hlsURL
        case fullURL
        case description
        case publishedAt
        case author
    }
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        hlsURL = try container.decodeIfPresent(String.self, forKey: .hlsURL)
        fullURL = try container.decodeIfPresent(String.self, forKey: .fullURL)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        author = try container.decodeIfPresent(Author.self, forKey: .author)
    }
    var id:String?
    var title:String?
    var hlsURL:String?
    var fullURL:String?
    var description:String?
    var publishedAt:String?
    var author: Author?
}
struct Author:Codable, Equatable {
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
       id = try container.decodeIfPresent(String.self, forKey: .id)
       name = try container.decodeIfPresent(String.self, forKey: .name)
   }
   enum CodingKeys: String, CodingKey {
       case id
       case name
   }
   var id:String?
   var name:String?
}
