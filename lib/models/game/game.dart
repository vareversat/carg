import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/players/players.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

abstract class Game<T extends Players, S extends GameSetting> extends CargObject
    with ChangeNotifier {
  late DateTime startingDate;
  late bool isEnded;
  DateTime? endingDate;
  String? winner;
  T? players;
  String? notes;
  late GameType gameType;
  S settings;

  Game(
      {super.id,
      gameType,
      this.players,
      this.endingDate,
      this.winner,
      startingDate,
      isEnded,
      this.notes,
      required this.settings}) {
    this.gameType = gameType ?? GameType.UNDEFINE;
    this.startingDate = startingDate ?? DateTime.now();
    this.isEnded = isEnded ?? false;
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'starting_date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(startingDate),
      'ending_date': endingDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(endingDate!)
          : null,
      'is_ended': isEnded,
      'winners': winner,
      'notes': notes,
      'settings': settings.toJSON()
    };
  }

  @override
  String toString() {
    return '$runtimeType{id: ${super.toString()}, \n'
        'startingDate: $startingDate, \n'
        'isEnded: $isEnded, \n'
        'endingDate: $endingDate, \n'
        'winner: $winner, \n'
        'players: $players, \n'
        'notes: $notes, \n'
        'gameType: $gameType, \n'
        'settings: $settings}';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        super == other &&
            other is Game &&
            runtimeType == other.runtimeType &&
            startingDate == other.startingDate &&
            isEnded == other.isEnded &&
            endingDate == other.endingDate &&
            winner == other.winner &&
            players == other.players &&
            notes == other.notes &&
            gameType == other.gameType;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      startingDate.hashCode ^
      isEnded.hashCode ^
      endingDate.hashCode ^
      winner.hashCode ^
      players.hashCode ^
      notes.hashCode ^
      gameType.hashCode;
}
