import Foundation

class apiCall {
    static let shared = apiCall()
    let urlString: String = constant.backendURL
    func getAllVideos() async throws -> [Video]?{
        do {
            if let url = URL(string: urlString) {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { return nil }
                return try JSONDecoder().decode([Video].self, from: data)
            }
        }
        return nil
    }
}
