import 'dart:convert';

/// isError : true
/// code : 1005
/// message : "errors.bad_request"
/// data : {}

CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());

class CommonResponseModel {
  CommonResponseModel({
    bool? isError,
    int? code,
    String? message,
    dynamic data,
  }) {
    _isError = isError;
    _code = code;
    _message = message;
    _data = data;
  }

  CommonResponseModel.fromJson(dynamic json) {
    _isError = json['isError'];
    _code = json['code'];
    _message = json['message'];
    _data = json['data'];
  }

  bool? _isError;
  int? _code;
  String? _message;
  dynamic _data;

  CommonResponseModel copyWith({
    bool? isError,
    int? code,
    String? message,
    dynamic data,
  }) =>
      CommonResponseModel(
        isError: isError ?? _isError,
        code: code ?? _code,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get isError => _isError;

  int? get code => _code;

  String? get message => _message;

  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isError'] = _isError;
    map['code'] = _code;
    map['message'] = _message;
    map['data'] = _data;
    return map;
  }
}
