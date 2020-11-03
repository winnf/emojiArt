//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Winnie Fong on 10/31/20.
//  Copyright © 2020 Winnie Fong. All rights reserved.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "🐶🐱🐭🐰🐹🦊🐻🐽🍊"
    
    @Published private var emojiArt: EmojiArt
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    
    // MARK: -Intents(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel() //in the case where it's fetching and the user tries to fetch something else, cancel the old one
            let publisher = URLSession.shared.dataTaskPublisher(for: url) //returns a tuple, maps it so it returns a UIImage (maps publisher to a different publisher)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main) //publishes them on the main queue
                .replaceError(with: nil) //change error type to never so you can do assign
            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self) //assign to our variable
            //Alternative way
//            DispatchQueue.global(qos: .userInitiated).async { //perform this function off of this background queue
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async { //back on main queue because the view watches backgroundImage changes
//                        if url == self.emojiArt.backgroundURL { //to protect against user selecting image from slow server and changing another image, old image comes back up
//                            self.backgroundImage = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
