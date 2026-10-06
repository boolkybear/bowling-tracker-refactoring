// Model for the bowling game
import Foundation

class BowlingGame {
    var scores: [RoundScore] = [RoundScore()]
    var currentRound = 1
}

class Score {
    var scores: [Int] = []
}

class RoundScore {
    var friendsScores: [Score] = []
}

extension BowlingGame {
    var isLastRound: Bool {
        currentRound == 10
    }

    var isCurrentRoundScoreCreated: Bool {
        scores.count == currentRound
    }

    func advanceRound() {
        currentRound += 1
        scores.append(RoundScore())
    }

    func getCurrentRoundScoreForFriend(at index: Int) -> Score {
        scores[currentRound - 1].friendsScores[index]
    }
}
