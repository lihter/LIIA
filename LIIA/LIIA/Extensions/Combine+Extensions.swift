import Combine

extension AnyPublisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        Empty<Output, Failure>().eraseToAnyPublisher()
    }

}
