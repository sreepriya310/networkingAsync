//
//  async.swift
//  requestapp
//
//  Created by Sreepriya M on 20/10/23.
//


import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case invalidData
}

@available(macOS 12.0, *)
@available(macOS 12.0, *)
public struct NetworkingKitAsync {
    public static func request<T: Decodable>(
        method: HTTPMethod,
        url: URL,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)  // This line is corrected

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
