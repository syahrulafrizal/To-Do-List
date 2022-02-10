// To parse this JSON data, do
//
//     final activityGroupsModel = activityGroupsModelFromJson(jsonString);

import 'dart:convert';

ActivityGroupsModel activityGroupsModelFromJson(String str) =>
    ActivityGroupsModel.fromJson(json.decode(str));

String activityGroupsModelToJson(ActivityGroupsModel data) =>
    json.encode(data.toJson());

class ActivityGroupsModel {
  ActivityGroupsModel({
    this.total,
    this.limit,
    this.skip,
    this.data,
  });

  int? total;
  int? limit;
  int? skip;
  List<ActivityGroupData>? data;

  factory ActivityGroupsModel.fromJson(Map<String, dynamic> json) =>
      ActivityGroupsModel(
        total: json["total"],
        limit: json["limit"],
        skip: json["skip"],
        data: List<ActivityGroupData>.from(
            json["data"].map((x) => ActivityGroupData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "skip": skip,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ActivityGroupData {
  ActivityGroupData({
    this.id,
    this.title,
    this.createdAt,
  });

  int? id;
  String? title;
  DateTime? createdAt;

  factory ActivityGroupData.fromJson(Map<String, dynamic> json) =>
      ActivityGroupData(
        id: json["id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt!.toIso8601String(),
      };
}
