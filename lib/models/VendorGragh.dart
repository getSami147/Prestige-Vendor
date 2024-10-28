// To parse this JSON data, do
//
//     final vendorGraghModel = vendorGraghModelFromJson(jsonString);

import 'dart:convert';

VendorGraghModel vendorGraghModelFromJson(String str) => VendorGraghModel.fromJson(json.decode(str));

String vendorGraghModelToJson(VendorGraghModel data) => json.encode(data.toJson());

class VendorGraghModel {
    final List<MonthlySale>? monthlySales;
    final List<WeeklySale>? weeklySales;

    VendorGraghModel({
        this.monthlySales,
        this.weeklySales,
    });

    factory VendorGraghModel.fromJson(Map<String, dynamic> json) => VendorGraghModel(
        monthlySales: json["monthlySales"] == null ? [] : List<MonthlySale>.from(json["monthlySales"]!.map((x) => MonthlySale.fromJson(x))),
        weeklySales: json["weeklySales"] == null ? [] : List<WeeklySale>.from(json["weeklySales"]!.map((x) => WeeklySale.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "monthlySales": monthlySales == null ? [] : List<dynamic>.from(monthlySales!.map((x) => x.toJson())),
        "weeklySales": weeklySales == null ? [] : List<dynamic>.from(weeklySales!.map((x) => x.toJson())),
    };
}

class MonthlySale {
    final double? amount;
    final DateTime? date;

    MonthlySale({
        this.amount,
        this.date,
    });

    factory MonthlySale.fromJson(Map<String, dynamic> json) => MonthlySale(
        amount: json["amount"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    };
}

class WeeklySale {
    final int? amount;
    final String? day;

    WeeklySale({
        this.amount,
        this.day,
    });

    factory WeeklySale.fromJson(Map<String, dynamic> json) => WeeklySale(
        amount: json["amount"],
        day: json["day"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "day": day,
    };
}
