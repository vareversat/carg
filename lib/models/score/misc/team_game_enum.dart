enum TeamGameEnum { US, THEM }

extension TeamGameEnumExtension on TeamGameEnum {
  String get name {
    switch (this) {
      case TeamGameEnum.US:
        return 'Nous';
      case TeamGameEnum.THEM:
        return 'Eux';
      default:
        return '';
    }
  }
}
