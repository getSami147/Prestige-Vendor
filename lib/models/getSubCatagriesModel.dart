// To parse this JSON data, do
//
//     final getSubCatagriesModel = getSubCatagriesModelFromJson(jsonString);

import 'dart:convert';

GetSubCatagriesModel getSubCatagriesModelFromJson(String str) => GetSubCatagriesModel.fromJson(json.decode(str));

String getSubCatagriesModelToJson(GetSubCatagriesModel data) => json.encode(data.toJson());

class GetSubCatagriesModel {
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

    GetSubCatagriesModel({
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

    factory GetSubCatagriesModel.fromJson(Map<String, dynamic> json) => GetSubCatagriesModel(
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
