// To parse this JSON data, do
//
//     final getSubCatByCatagoryModel = getSubCatByCatagoryModelFromJson(jsonString);

import 'dart:convert';

GetSubCatByCatagoryModel getSubCatByCatagoryModelFromJson(String str) => GetSubCatByCatagoryModel.fromJson(json.decode(str));

String getSubCatByCatagoryModelToJson(GetSubCatByCatagoryModel data) => json.encode(data.toJson());

class GetSubCatByCatagoryModel {
    final int? status;
    final String? message;
    final List<Datum>? data;

    GetSubCatByCatagoryModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetSubCatByCatagoryModel.fromJson(Map<String, dynamic> json) => GetSubCatByCatagoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final String? id;
    final String? title;
    final String? image;
    final String? type;
    final String? categoryId;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? slug;
    final int? v;

    Datum({
        this.id,
        this.title,
        this.image,
        this.type,
        this.categoryId,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.slug,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        image: json["image"],
        type: json["type"],
        categoryId: json["categoryId"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "type": type,
        "categoryId": categoryId,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "slug": slug,
        "__v": v,
    };
}
