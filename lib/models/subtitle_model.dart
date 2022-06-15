class Subtitle {
  final String subtitle;
  final Duration start;
  final Duration end;

  Subtitle(
    this.subtitle,
    this.start,
    this.end,
  );

  factory Subtitle.fromString(String startStr, String endStr, String sub) {
    List<String> tmpStartStr = startStr.split(':');
    var hourStart = int.parse(tmpStartStr[0]);
    var minuteStart = int.parse(tmpStartStr[1]);
    var secondStart = int.parse(tmpStartStr[2].split(',')[0]);

    List<String> tmpEndStr = endStr.split(':');
    var hourEnd = int.parse(tmpEndStr[0]);
    var minuteEnd = int.parse(tmpEndStr[1]);
    var secondEnd = int.parse(tmpEndStr[2].split(',')[0]);

    return Subtitle(
      sub,
      Duration(hours: hourStart, minutes: minuteStart, seconds: secondStart),
      Duration(hours: hourEnd, minutes: minuteEnd, seconds: secondEnd),
    );
  }
}
