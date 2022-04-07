import 'package:carg/const.dart';
import 'package:carg/repositories/team/abstract_team_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamRepository extends AbstractTeamRepository {
  TeamRepository(
      {String? database, String? environment, FirebaseFirestore? provider})
      : super(
            database: database ?? Const.teamDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance);
}
