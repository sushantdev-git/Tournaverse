class Event {
  final int entryFee;
  final String eventName;
  final DateTime eventTime;
  final String gameName;
  final String gameMap;
  final String gameMode;
  final int totalSlots;
  final List<dynamic> userRegistered;
  final String imageUrl;
  final String eventId;
  final String? creatorId;
  final String? creatorName;

  const Event( {
    required this.eventId,
    required this.entryFee,
    required this.eventName,
    required this.eventTime,
    required this.gameName,
    required this.gameMap,
    required this.gameMode,
    required this.imageUrl,
    required this.totalSlots,
    required this.userRegistered,
    required this.creatorId,
    required this.creatorName,
  });
}
