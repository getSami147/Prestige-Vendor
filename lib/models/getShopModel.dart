// To parse this JSON data, do
//
//     final getShopModel = getShopModelFromJson(jsonString);

import 'dart:convert';

GetShopModel getShopModelFromJson(String str) => GetShopModel.fromJson(json.decode(str));

String getShopModelToJson(GetShopModel data) => json.encode(data.toJson());

class GetShopModel {
    final int? totalDocs;
    final int? limit;
    final int? totalPages;
    final int? page;
    final int? pagingCounter;
    final bool? hasPrevPage;
    final bool? hasNextPage;
    final dynamic prevPage;
    final dynamic nextPage;
    final Shop? shop;
    final List<dynamic>? docs;

    GetShopModel({
        this.totalDocs,
        this.limit,
        this.totalPages,
        this.page,
        this.pagingCounter,
        this.hasPrevPage,
        this.hasNextPage,
        this.prevPage,
        this.nextPage,
        this.shop,
        this.docs,
    });

    factory GetShopModel.fromJson(Map<String, dynamic> json) => GetShopModel(
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        docs: json["docs"] == null ? [] : List<dynamic>.from(json["docs"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
        "shop": shop?.toJson(),
        "docs": docs == null ? [] : List<dynamic>.from(docs!.map((x) => x)),
    };
}

class Shop {
    final Location? location;
    final String? id;
    final String? title;
    final String? type;
    final List<Week>? weeks;
    final String? vendorId;
    final String? subCategoryId;
    final String? address;
    final String? description;
    final List<String>? coverImage;
    final List<String>? logo;
    final String? status;
    final int? commission;
    final String? statesId;
    final String? statesName;
    final String? lga;
    final int? reademFormulaValue;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? slug;
    final int? v;

    Shop({
        this.location,
        this.id,
        this.title,
        this.type,
        this.weeks,
        this.vendorId,
        this.subCategoryId,
        this.address,
        this.description,
        this.coverImage,
        this.logo,
        this.status,
        this.commission,
        this.statesId,
        this.statesName,
        this.lga,
        this.reademFormulaValue,
        this.createdAt,
        this.updatedAt,
        this.slug,
        this.v,
    });

    factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        id: json["_id"],
        title: json["title"],
        type: json["type"],
        weeks: json["weeks"] == null ? [] : List<Week>.from(json["weeks"]!.map((x) => Week.fromJson(x))),
        vendorId: json["vendorId"],
        subCategoryId: json["subCategoryId"],
        address: json["address"],
        description: json["description"],
        coverImage: json["coverImage"] == null ? [] : List<String>.from(json["coverImage"]!.map((x) => x)),
        logo: json["logo"] == null ? [] : List<String>.from(json["logo"]!.map((x) => x)),
        status: json["status"],
        commission: json["commission"],
        statesId: json["statesId"],
        statesName: json["statesName"],
        lga: json["LGA"],
        reademFormulaValue: json["reademFormulaValue"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        slug: json["slug"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "_id": id,
        "title": title,
        "type": type,
        "weeks": weeks == null ? [] : List<dynamic>.from(weeks!.map((x) => x.toJson())),
        "vendorId": vendorId,
        "subCategoryId": subCategoryId,
        "address": address,
        "description": description,
        "coverImage": coverImage == null ? [] : List<dynamic>.from(coverImage!.map((x) => x)),
        "logo": logo == null ? [] : List<dynamic>.from(logo!.map((x) => x)),
        "status": status,
        "commission": commission,
        "statesId": statesId,
        "statesName": statesName,
        "LGA": lga,
        "reademFormulaValue": reademFormulaValue,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "slug": slug,
        "__v": v,
    };
}

class Location {
    final String? type;
    final List<double>? coordinates;

    Location({
        this.type,
        this.coordinates,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
    };
}

class Week {
    final String? day;
    final String? openTime;
    final String? closeTime;
    // final String? id;

    Week({
        this.day,
        this.openTime,
        this.closeTime,
        // this.id,
    });

    factory Week.fromJson(Map<String, dynamic> json) => Week(
        day: json["day"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        // id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "openTime": openTime,
        "closeTime": closeTime,
        // "_id": id,
    };
    @override
  String toString() {
    return 'Week(day: $day, openTime: $openTime, closeTime: $closeTime, )';
  }

}
