// To parse this JSON data, do
//
//     final newCustomerReview = newCustomerReviewFromJson(jsonString);
//
//     final responseCustomerReview = responseCustomerReviewFromJson(jsonString);

import 'dart:convert';

NewCustomerReview newCustomerReviewFromJson(String str) =>
    NewCustomerReview.fromJson(json.decode(str));

String newCustomerReviewToJson(NewCustomerReview data) =>
    json.encode(data.toJson());

ResponseCustomerReview responseCustomerReviewFromJson(String str) =>
    ResponseCustomerReview.fromJson(json.decode(str));

String responseCustomerReviewToJson(ResponseCustomerReview data) =>
    json.encode(data.toJson());

class NewCustomerReview {
  NewCustomerReview({
    this.id,
    this.name,
    this.review,
  });

  String id;
  String name;
  String review;

  factory NewCustomerReview.fromJson(Map<String, dynamic> json) =>
      NewCustomerReview(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        review: json["review"] == null ? null : json["review"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "review": review == null ? null : review,
      };
}

//
class ResponseCustomerReview {
  ResponseCustomerReview({
    this.error,
    this.message,
    this.customerReviews,
  });

  bool error;
  String message;
  List<CustomerReview> customerReviews;

  factory ResponseCustomerReview.fromJson(Map<String, dynamic> json) =>
      ResponseCustomerReview(
        error: json["error"] == null ? null : json["error"],
        message: json["message"] == null ? null : json["message"],
        customerReviews: json["customerReviews"] == null
            ? null
            : List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "message": message == null ? null : message,
        "customerReviews": customerReviews == null
            ? null
            : List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class CustomerReview {
  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"] == null ? null : json["name"],
        review: json["review"] == null ? null : json["review"],
        date: json["date"] == null ? null : json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "review": review == null ? null : review,
        "date": date == null ? null : date,
      };
}
