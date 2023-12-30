abstract class GameSetting {
  int maxPoint;
  late bool isInfinite; // true when maxPoint == 1

  GameSetting({required this.maxPoint}) {
    isInfinite = maxPoint == -1;
  }
}
