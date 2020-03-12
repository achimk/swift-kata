//: [Previous](@previous)

import Foundation

// Module: CardGame (Bounded Context)

enum Suit {
    
    case club
    case diamond
    case spade
    case heart
}

enum Rank {
    
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace
}

typealias Card = (Suit, Rank)

typealias Hand = [Card]

typealias Deck = [Card]

typealias Player = (name: String, hand: Hand)

typealias Game = (deck: Deck, players: [Player])

typealias Deal = (Deck) -> (Deck, Card)

typealias PickupCard = (Hand, Card) -> Hand



//: [Next](@next)
