// To parse this JSON data, do
//
//     final getAllCatagriesModel = getAllCatagriesModelFromJson(jsonString);

import 'dart:convert';

GetAllCatagriesModel getAllCatagriesModelFromJson(String str) => GetAllCatagriesModel.fromJson(json.decode(str));

String getAllCatagriesModelToJson(GetAllCatagriesModel data) => json.encode(data.toJson());

class GetAllCatagriesModel {
    final int? status;
    final String? message;
    final int? totalDocs;
    final int? limit;
    final int? totalPages;
    final int? page;
    final int? pagingCounter;
    final bool? hasPrevPage;
    final bool? hasNextPage;
    final dynamic prevPage;
    final dynamic nextPage;
    final List<Datum>? data;

    GetAllCatagriesModel({
        this.status,
        this.message,
        this.totalDocs,
        this.limit,
        this.totalPages,
        this.page,
        this.pagingCounter,
        this.hasPrevPage,
        this.hasNextPage,
        this.prevPage,
        this.nextPage,
        this.data,
    });

    factory GetAllCatagriesModel.fromJson(Map<String, dynamic> json) => GetAllCatagriesModel(
        status: json["status"],
        message: json["message"],
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final String? id;
    final String? title;
    final String? image;
    final String? description;
    final String? type;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? slug;
    final int? v;

    Datum({
        this.id,
        this.title,
        this.image,
        this.description,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.slug,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        image: json["image"],
        description: json["description"],
        type: json["type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "description": description,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "slug": slug,
        "__v": v,
    };
}
