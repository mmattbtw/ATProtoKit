//
//  GetRepoRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoKit {
    public static func getRepoRecord(from recordQuery: RecordQuery, pdsURL: String = "https://bsky.social") async throws -> Result<RecordOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.getRecord") else {
            return .failure(URIError.invalidFormat)
        }

        do {
            var queryItems = [
                ("repo", recordQuery.repo),
                ("collection", recordQuery.collection),
                ("rkey", recordQuery.recordKey)
            ]

            if let cid = recordQuery.recordCID {
                queryItems.append(("cid", cid))
            }

            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            print("\n===\nqueryURL: \(queryURL)")
            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, authorizationValue: nil)

            let response = try await APIClientService.sendRequest(request, decodeTo: RecordOutput.self)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}