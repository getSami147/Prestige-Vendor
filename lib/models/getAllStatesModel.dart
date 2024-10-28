// To parse this JSON data, do
//
//     final getAllStatesModel = getAllStatesModelFromJson(jsonString);

import 'dart:convert';

GetAllStatesModel getAllStatesModelFromJson(String str) => GetAllStatesModel.fromJson(json.decode(str));

String getAllStatesModelToJson(GetAllStatesModel data) => json.encode(data.toJson());

class GetAllStatesModel {
    final int? status;
    final String? message;
    final List<Datum>? data;

    GetAllStatesModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllStatesModel.fromJson(Map<String, dynamic> json) => GetAllStatesModel(
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
    final String? name;
    final List<String>? lgAs;

    Datum({
        this.id,
        this.name,
        this.lgAs,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        lgAs: json["LGAs"] == null ? [] : List<String>.from(json["LGAs"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "LGAs": lgAs == null ? [] : List<dynamic>.from(lgAs!.map((x) => x)),
    };
}
