//
// Created by Rob on 13/11/21.
//

struct RandomEmoji {
    private static var emojis = ["🙏", "👊", "🙌", "👏", "👑", "🌞", "⭐️", "☀️", "🌈"]

    private init() {
    }

    static func get() -> String {
        emojis.remove(at: emojis.indices.randomElement()!)
    }
}