// ignore_for_file: constant_identifier_names

enum BeloteTeamEnum { US, THEM }

extension BeloteTeamEnumExtension on BeloteTeamEnum? {
  String get name {
    switch (this) {
      case BeloteTeamEnum.US:
        return 'Nous';
      case BeloteTeamEnum.THEM:
        return 'Eux';
      default:
        return '';
    }
  }
}
