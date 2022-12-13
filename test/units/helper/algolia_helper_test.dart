import 'package:carg/helpers/algolia_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('AlgoliaHelper', () {
    test('Helper initialization ', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await AlgoliaHelper.create();
      expect(AlgoliaHelper.appID, isNot(''));
      expect(AlgoliaHelper.apiKey, isNot(''));
      expect(AlgoliaHelper.url, isNot(''));
      expect(AlgoliaHelper.path, isNot(''));
    });

    group('Generate filters ', () {
      group('Admin filters ', () {
        test('not my players', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(true, 'player_id', false);
          expect(filter, 'owned:false OR testing:true');
        });

        test('my players', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(true, 'player_id', true);
          expect(filter, 'owned_by:player_id AND NOT testing:true');
        });

        test('my players = null', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(true, 'player_id', null);
          expect(filter, 'owned_by:player_id OR owned:false OR testing:true');
        });
      });

      group('Common filters ', () {
        test('not my players', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(false, 'player_id', false);
          expect(filter, 'owned:false AND NOT testing:true');
        });

        test('my players', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(false, 'player_id', true);
          expect(filter, 'owned_by:player_id AND NOT testing:true');
        });

        test('my players = null', () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          var helper = await AlgoliaHelper.create();
          var filter = helper.getAlgoliaFilter(false, 'player_id', null);
          expect(filter,
              '(owned_by:player_id OR owned:false) AND NOT testing:true');
        });
      });
    });
  });
}
