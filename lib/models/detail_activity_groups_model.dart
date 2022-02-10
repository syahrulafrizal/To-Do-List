// To parse this JSON data, do
//
//     final detailActivityGroupsModel = detailActivityGroupsModelFromJson(jsonString);

import 'dart:convert';

DetailActivityGroupsModel detailActivityGroupsModelFromJson(String str) =>
    DetailActivityGroupsModel.fromJson(json.decode(str));

String detailActivityGroupsModelToJson(DetailActivityGroupsModel data) =>
    json.encode(data.toJson());

class DetailActivityGroupsModel {
  DetailActivityGroupsModel({
    this.id,
    this.title,
    this.createdAt,
    this.todoItems,
  });

  int? id;
  String? title;
  DateTime? createdAt;
  List<TodoItem>? todoItems;

  factory DetailActivityGroupsModel.fromJson(Map<String, dynamic> json) =>
      DetailActivityGroupsModel(
        id: json["id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        todoItems: List<TodoItem>.from(
            json["todo_items"].map((x) => TodoItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt!.toIso8601String(),
        "todo_items": List<dynamic>.from(todoItems!.map((x) => x.toJson())),
      };
}

class TodoItem {
  TodoItem({
    this.id,
    this.title,
    this.activityGroupId,
    this.isActive,
    this.priority,
  });

  int? id;
  String? title;
  int? activityGroupId;
  int? isActive;
  String? priority;

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        id: json["id"],
        title: json["title"],
        activityGroupId: json["activity_group_id"],
        isActive: json["is_active"],
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "activity_group_id": activityGroupId,
        "is_active": isActive,
        "priority": priority,
      };
}
