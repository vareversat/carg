import 'package:carg/const.dart';
import 'package:carg/repositories/player/abstract_player_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRepository extends AbstractPlayerRepository {
  PlayerRepository(
      {String? database, String? environment, FirebaseFirestore? provider})
      : super(
            database: database ?? Const.playerDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance);
}
