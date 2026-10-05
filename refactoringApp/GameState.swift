//
//  GameState.swift
//  refactoringApp
//

protocol GameState {
    var friends: [String] { get set }
    var game: BowlingGame { get set }
}

final class DefaultGameState: GameState {
    var friends: [String] = []
    var game = BowlingGame()
}
