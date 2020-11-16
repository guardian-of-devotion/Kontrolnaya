//
//  SweetService.swift
//  DebuggingApp
//
//  Created by Teacher on 01.11.2020.
//

import Foundation

enum SweetServiceError: Error {
    case notFound
    case network(Error)
}

protocol SweetService {
    func loadFeed(
        after lastSweetId: UUID?,
        completion: @escaping (Result<[Sweet], SweetServiceError>) -> Void
    )
    func postSweet(
        withTitle title: String?,
        text: String,
        completion: @escaping (Result<Sweet, SweetServiceError>) -> Void
    )
}
