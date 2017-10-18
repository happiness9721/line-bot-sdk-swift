import Foundation

protocol HTTPClient {
  func sendRequest(request: URLRequest)
}
