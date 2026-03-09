import Foundation

final class HiringAPICacheManager {
    private let cache = NSCache<NSString, NSData>()

    func cachedResponse(for url: URL) -> Data? {
        let key = url.absoluteString as NSString
        return cache.object(forKey: key) as Data?
    }

    func setCache(for url: URL, data: Data) {
        let key = url.absoluteString as NSString
        cache.setObject(data as NSData, forKey: key)
    }
}
