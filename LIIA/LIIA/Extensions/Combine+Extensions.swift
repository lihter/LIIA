import Combine
import Foundation

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        Empty<Output, Failure>().eraseToAnyPublisher()
    }

    func receiveOnMain() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

public extension Future where Failure == Error {

    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

}

public extension Future {

    convenience init(operation: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let output = await operation()
                promise(.success(output))
            }
        }
    }

}
