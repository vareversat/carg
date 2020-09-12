import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/models/score/team_game_score.dart';
import 'package:carg/services/score/score_service.dart';

abstract class TeamGameScoreService<T extends TeamGameScore,
    P extends TeamGameRound> implements ScoreService<T, P> {

    int getTotalPoints(TeamGameEnum teamGameEnum, TeamGameRound teamGameRound) {
        if (teamGameEnum == teamGameRound.taker) {
            return teamGameRound.takerScore;
        } else {
            return teamGameRound.defenderScore;
        }
    }
}
