class ChurchResponseModel {
  String? id;
  String? name;
  String? description;
  String? address;
  String? coverImageUri;
  String? createdAt;

  ChurchResponseModel(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.coverImageUri,
      this.createdAt});

  ChurchResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    coverImageUri = json['coverImageUri'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['coverImageUri'] = coverImageUri;
    data['createdAt'] = createdAt;
    return data;
  }
}
