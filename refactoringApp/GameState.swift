//
//  GameState.swift
//  refactoringApp
//

protocol GameState {
    var friends: [String] { get set }
    var game: BowlingGame { get set }
    var isCurrentRoundFinishedForAllFriends: Bool { get }
}

final class DefaultGameState: GameState {
    var friends: [String] = []
    var game = BowlingGame()
}

extension GameState {
    var isCurrentRoundFinishedForAllFriends: Bool {
        game.scores[game.currentRound - 1].friendsScores.count == friends.count
    }
}
