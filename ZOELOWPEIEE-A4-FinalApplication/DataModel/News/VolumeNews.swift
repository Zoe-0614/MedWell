//
//  VolumeNews.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 01/06/2023.
//

import Foundation

/// A struct representing a collection of news volumes that conforms to the `Decodable` protocol.
struct VolumeNews: Decodable {
    var news: [NewsData]
}
