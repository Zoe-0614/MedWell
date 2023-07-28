//
//  NewsData.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 01/06/2023.
//

import UIKit

/// A class representing news data that conforms to the `Decodable` protocol.
class NewsData: NSObject, Decodable{
    
    // MARK: - Properties
    var id: String?
    var title: String?
    var newsDescription: String?
    var url: String?
    var author: String?
    var image: String?
    var category: [String]?
    var published: String?
    
    /// The coding keys for the NewsData.
    private enum NewsKeys: String, CodingKey{
        case newsId = "id"
        case newsTitle = "title"
        case newsDescriptions = "description"
        case newsUrl = "url"
        case newsAuthor = "author"
        case newsImage = "image"
        case newsCategory = "category"
        case newsPublished = "published"
    }
    
    ///  Initializes a new instance of `NewsData` by decoding the data from a decoder.
    ///  - Parameter decoder: The decoder to use for decoding the data.
    ///  - Throws: An error if the decoding process fails.
    required init(from decoder: Decoder) throws{
        // The container that contains the news info
        let container = try decoder.container(keyedBy: NewsKeys.self)
        // Get news info
        id = try container.decodeIfPresent(String.self, forKey: .newsId)
        title = try container.decodeIfPresent(String.self, forKey: .newsTitle)
        newsDescription = try container.decodeIfPresent(String.self, forKey: .newsDescriptions)
        url = try container.decodeIfPresent(String.self, forKey: .newsUrl)
        author = try container.decodeIfPresent(String.self, forKey: .newsAuthor)
        image = try container.decodeIfPresent(String.self, forKey: .newsImage)
        category = try container.decodeIfPresent([String].self, forKey: .newsCategory)
        published = try container.decodeIfPresent(String.self, forKey: .newsPublished)
    }
}
