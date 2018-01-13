//
//  Emoji.swift
//  EmojisDictionary
//
//  Created by Andres Gutierrez on 1/11/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//

import Foundation

// Emoji Categories:
enum emojiCategory: String {
    case Smileys = "Smileys"
    case People = "People"
    case Animals = "Animals"
    case Nature = "Nature"
    case Food = "Food"
    case Objects = "Objects"
    case Symbols = "Symbols"
}

// Emoji Class:
class Emoji: Codable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    var category: String
    
    init(symbol: String, name: String, description: String, usage: String, category: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
        self.category = category
    }
    
    // creation of file to save:
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = documentDirectory.appendingPathComponent("emojis").appendingPathExtension("plist")
    
    // save file method:
    static func saveToFile(emojis: [[Emoji]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmojis = try? propertyListEncoder.encode(emojis)
        try? encodedEmojis?.write(to: Emoji.archiveURL, options: .noFileProtection)
        print("save to: ", Emoji.archiveURL)
    }
    
    // load file method:
    static func loadFromFile() -> [[Emoji]] {
        let propertyListDecoder = PropertyListDecoder()
        var emojiArray: [[Emoji]] = []
        
        if let retrievedEmojiData = try? Data(contentsOf: Emoji.archiveURL), let decodedEmojis = try?
            propertyListDecoder.decode(Array<[Emoji]>.self, from: retrievedEmojiData) {
            emojiArray = decodedEmojis
            print("load from: ", Emoji.archiveURL)
        }
        return emojiArray
    }
    
    
    // emoji sample list:
    static func loadSampleEmojis() -> [Emoji] {
        return [
            Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness", category: emojiCategory.Smileys.rawValue),
            Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure", category: emojiCategory.Smileys.rawValue),
            Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive", category: emojiCategory.Smileys.rawValue),
            Emoji(symbol: "👮", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority", category: emojiCategory.People.rawValue),
            Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow", category: emojiCategory.Animals.rawValue),
            Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory", category: emojiCategory.Animals.rawValue),
            Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti", usage: "spaghetti", category: emojiCategory.Food.rawValue),
            Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk; chance; game", category: emojiCategory.Objects.rawValue),
            Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping", category: emojiCategory.Objects.rawValue),
            Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework; study", category: emojiCategory.Objects.rawValue),
            Emoji(symbol: "🚀", name: "Rocket", description: "An upwards-flying rocket.", usage: "launch", category: emojiCategory.Symbols.rawValue),
            Emoji(symbol: "🛰", name: "Satellite", description: "A communications satellite.", usage: "communication", category: emojiCategory.Symbols.rawValue),
            Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness", category: emojiCategory.Symbols.rawValue),
            Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness", category: emojiCategory.Symbols.rawValue),
            Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion", category: emojiCategory.Symbols.rawValue),
            Emoji(symbol: "❄️", name: "Snowflake", description: "A blueish snowflake.", usage: "cold", category: emojiCategory.Nature.rawValue)
        ]
    }
}
