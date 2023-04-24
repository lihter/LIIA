import Combine
import UIKit

// MARK: Gestures
public extension UIView {

    var tap: GesturePublisher {
        gesture(.tap())
    }

    func gesture(_ gestureType: GestureType) -> GesturePublisher {
        GesturePublisher(view: self, gestureType: gestureType)
    }

    func throttledTap(for interval: Double = 0.5) -> AnyPublisher<Void, Never> {
        tap
            .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
            .map { _ in }
            .eraseToAnyPublisher()
    }

}

public enum GestureType {

    var recognizer: UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        }
    }

    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())

}

class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {

    private var subscriber: S?
    private var view: UIView
    private var gestureType: GestureType

    init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType

        configureGesture(gestureType)
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    private func configureGesture(_ gestureType: GestureType) {
        let recognizer = gestureType.recognizer

        recognizer.addTarget(self, action: #selector(handler))
        view.addGestureRecognizer(recognizer)
    }

    @objc private func handler() {
        _ = subscriber?.receive(gestureType)
    }

}

public struct GesturePublisher: Publisher {

    public typealias Output = GestureType
    public typealias Failure = Never

    private let view: UIView
    private let gestureType: GestureType

    init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }

    public func receive<S>(subscriber: S) where S: Subscriber,
                                         GesturePublisher.Failure == S.Failure,
                                         GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber, view: view, gestureType: gestureType)

        subscriber.receive(subscription: subscription)
    }

}
