import 'package:carg/repositories/impl/player_repository.dart';
import 'package:carg/services/base_abstract_service.dart';

abstract class AbstractPlayerService extends BaseAbstractService {
  AbstractPlayerService()
      : super(firebaseAbstractRepository: PlayerRepository());
}
