import Foundation

extension Downloader {
    public convenience init(
        items: [(URL, String)],
        needsPreciseProgress: Bool = true,
        commonStrategy: Strategy = .ifUpdated,
        commonRequestHeaders: [String: String]? = nil
    ) {
        self.init(
            items: items.map { Item(url: $0.0, destination: $0.1) },
            needsPreciseProgress: needsPreciseProgress,
            commonStrategy: commonStrategy,
            commonRequestHeaders: commonRequestHeaders
        )
    }

    public func progress(_ handler: @escaping (Int64, Int64?) -> ()) {
        progress { done, whole, _, _, _ in
            handler(done, whole)
        }
    }
    
    public func progress(_ handler: @escaping (Float?) -> ()) {
        if needsPreciseProgress {
            progress { done, whole in
                handler(whole.map { whole in Float(Double(done) / Double(whole)) })
            }
        } else {
            progress { _, _, itemIndex, done, whole in
                handler(whole.map { whole in (Float(itemIndex) + Float(Double(done) / Double(whole))) / Float(self.items.count) })
            }
        }
    }
}
