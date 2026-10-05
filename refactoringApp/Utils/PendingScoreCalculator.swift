//
//  PendingScoreCalculator.swift
//  refactoringApp
//

class PendingScoreCalculator {
    static func calculateScore(friend: Int) -> Int {
        var friendScores = game.scores.map { round in
            if friend < round.friendsScores.count {
                return round.friendsScores[friend]
            } else {
                return Score()
            }
        }
        if friendScores.last?.scores.isEmpty == true {
            friendScores.removeLast()
        }
        var total = 0
        var index = 1
        for round in friendScores {
            if index == 10 {
                total += getScoreSum(round)
            } else {
                let nextRolls = friendScores.count <= index ? [] : friendScores.suffix(from: index).reduce([]) { accumulated, item in
                    return accumulated + item.scores
                }
                total += getScoreSum(round)
                if isStrike(round) {
                    let bonus = nextRolls.prefix(2)
                    total += bonus.reduce(0, +)
                } else if isSpare(round) {
                    let bonus = nextRolls.prefix(1)
                    total += bonus.reduce(0, +)
                }
            }
            index += 1
        }

        return total
    }

    static func getScoreSum(_ score: Score) -> Int {
        return score.scores.reduce(0, +)
    }

    static func isStrike(_ score: Score) -> Bool {
        let isStrike = score.scores.count == 1 && score.scores[0] == 10
        return isStrike
    }

    static func isSpare(_ score: Score) -> Bool {
        let isSpare = score.scores.count == 2 && score.scores[0] + score.scores[1] == 10
        return isSpare
    }
}
