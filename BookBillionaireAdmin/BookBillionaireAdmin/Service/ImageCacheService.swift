//
//  ImageCacheService.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/23/24.
//
import SwiftUI
import Foundation

class ImageCacheService {
    static let shared = ImageCacheService()
    private var cache: [URL: UIImage] = [:]

    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache[url] {
            completion(cachedImage)
        } else {
            downloadImage(from: url) { image in
                if let image = image {
                    self.cache[url] = image
                }
                completion(image)
            }
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

/// 실행 방법
//ImageCache.shared.getImage(for: imageURL) { image in
//    if let image = image {
//        // 이미지를 표시하거나 처리합니다.
//    } else {
//        // 이미지 로딩 실패 처리
//    }
//}
