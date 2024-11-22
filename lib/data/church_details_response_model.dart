class ChurchDetailsResponseModel {
  Church? church;
  bool? isJoined;
  int? joinedCount;
  Volunteer? isVolunteer;
  String? chatHash;

  ChurchDetailsResponseModel({this.church, this.isJoined});

  ChurchDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    church = json['church'] != null ? Church.fromJson(json['church']) : null;
    isJoined = json['isJoined'];
    joinedCount = json['joinedCount'];
    isVolunteer = json.containsKey("isVolunteer")
        ? json['isVolunteer'] != null
            ? Volunteer.fromJson(json['isVolunteer'])
            : null
        : null;

    chatHash = json.containsKey("chatHash")
        ? json['chatHash']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (church != null) {
      data['church'] = church!.toJson();
    }
    if (isVolunteer != null) {
      data['isVolunteer'] = isVolunteer?.toJson();
    }
    data['isJoined'] = isJoined;
    data['joinedCount'] = joinedCount;
    data['chatHash'] = chatHash;
    return data;
  }
}

class Church {
  String? id;
  String? name;
  String? description;
  String? address;
  String? coverImageUri;
  String? createdAt;
  List<String>? imagesUri;

  Church(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.coverImageUri,
      this.imagesUri,
      this.createdAt});

  Church.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    coverImageUri = json['coverImageUri'];
    createdAt = json['createdAt'];
    imagesUri = json['imagesUri'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['coverImageUri'] = coverImageUri;
    data['createdAt'] = createdAt;
    data['imagesUri'] = imagesUri;
    return data;
  }
}

class Volunteer {
  String? userId;
  String? churchId;
  String? status;

  Volunteer({
    this.userId,
    this.churchId,
    this.status,
  });

  Volunteer.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    churchId = json['churchId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['churchId'] = churchId;
    data['status'] = status;

    return data;
  }
}
