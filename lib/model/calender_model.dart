import 'dart:convert';

class CalenderModel {
  CalenderModel({
    this.summary,
    required this.items,
  });

  var summary;

  List<Item> items;

  factory CalenderModel.fromRawJson(String str) =>
      CalenderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalenderModel.fromJson(Map<String, dynamic> json) => CalenderModel(
        summary: summaryValues.map[json["summary"]],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summaryValues.reverse[summary],
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.kind,
    required this.etag,
    required this.id,
    required this.status,
    required this.htmlLink,
    required this.created,
    required this.updated,
    required this.summary,
    required this.description,
    required this.creator,
    required this.organizer,
    required this.start,
    required this.end,
    required this.iCalUid,
    required this.sequence,
    required this.eventType,
  });

  var kind;
  String etag;
  String id;
  var status;
  String htmlLink;
  DateTime created;
  DateTime updated;
  String summary;
  var description;
  Creator creator;
  Creator organizer;
  End start;
  End end;
  String iCalUid;
  int sequence;
  var eventType;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: kindValues.map[json["kind"]],
        etag: json["etag"],
        id: json["id"],
        status: statusValues.map[json["status"]],
        htmlLink: json["htmlLink"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        summary: json["summary"],
        description: json["description"] ?? null,
        creator: Creator.fromJson(json["creator"]),
        organizer: Creator.fromJson(json["organizer"]),
        start: End.fromJson(json["start"]),
        end: End.fromJson(json["end"]),
        iCalUid: json["iCalUID"],
        sequence: json["sequence"],
        eventType: eventTypeValues.map[json["eventType"]],
      );

  Map<String, dynamic> toJson() => {
        "kind": kindValues.reverse[kind],
        "etag": etag,
        "id": id,
        "status": statusValues.reverse[status],
        "htmlLink": htmlLink,
        "created": created.toIso8601String(),
        "updated": updated.toIso8601String(),
        "summary": summary,
        "description": description == null ? null : description,
        "creator": creator.toJson(),
        "organizer": organizer.toJson(),
        "start": start.toJson(),
        "end": end.toJson(),
        "iCalUID": iCalUid,
        "sequence": sequence,
        "eventType": eventTypeValues.reverse[eventType],
      };
}

class Attendee {
  Attendee({
    required this.email,
    required this.self,
    required this.responseStatus,
  });

  var email;
  bool self;
  var responseStatus;

  factory Attendee.fromRawJson(String str) =>
      Attendee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        email: summaryValues.map[json["email"]],
        self: json["self"],
        responseStatus: responseStatusValues.map[json["responseStatus"]],
      );

  Map<String, dynamic> toJson() => {
        "email": summaryValues.reverse[email],
        "self": self,
        "responseStatus": responseStatusValues.reverse[responseStatus],
      };
}

enum Summary { THE_1025_DEEPAKYADAV_GMAIL_COM }

final summaryValues = EnumValues(
    {"1025deepakyadav@gmail.com": Summary.THE_1025_DEEPAKYADAV_GMAIL_COM});

enum ResponseStatus { NEEDS_ACTION }

final responseStatusValues =
    EnumValues({"needsAction": ResponseStatus.NEEDS_ACTION});

class Creator {
  Creator({
    required this.email,
  });

  String email;

  factory Creator.fromRawJson(String str) => Creator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}

class End {
  End({
    required this.dateTime,
  });

  DateTime dateTime;

  factory End.fromRawJson(String str) => End.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory End.fromJson(Map<String, dynamic> json) => End(
        dateTime: DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime.toIso8601String(),
      };
}

enum EventType { DEFAULT }

final eventTypeValues = EnumValues({"default": EventType.DEFAULT});

enum Kind { CALENDAR_EVENT }

final kindValues = EnumValues({"calendar#event": Kind.CALENDAR_EVENT});

enum Status { CONFIRMED }

final statusValues = EnumValues({"confirmed": Status.CONFIRMED});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
