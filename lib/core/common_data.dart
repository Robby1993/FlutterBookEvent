

class DeleteReasonModel {
  String? name;
  String? image;
  bool isChecked;

  DeleteReasonModel({
    this.name,
    this.image,
    this.isChecked = false,
  });
}

class Height {
  int? index;
  String? height;

  Height({
    this.index,
    this.height,
  });
}

class DOBModel {
  bool isDay;
  bool isMonth;
  bool isYear;
  bool is18Year;

  DOBModel({
    required this.isDay,
    required this.isMonth,
    required this.isYear,
    required this.is18Year,
  });
}

class UserData {
  String name;
  String information;
  String intro;
  List<String> userImages;
  List<String> interesting;

  UserData(this.name, this.information, this.intro, this.userImages,
      this.interesting);
}

const chat1Image = 'https://images.pexels.com/photos/1308881/pexels-photo-1308881.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
const chat2Image = 'https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
const myProfileImage = 'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
const myProfileName = 'James';

class CommonData {

  static List<Height> heightList = List<Height>.generate(
      400, (int index) => Height(index: index, height: "${150 + index}"),
      growable: true);
  static const List categoriesList = [
    "Books",
    "Music",
    "Audio Story",
    "Daily Scripture",
    "Quizes",
  ];

  static const List bookmarksCategoriesList = [
    "Books",
    "Music",
    "Audio Story",
  ];

  static const List eventsList = [
    "Today’s",
    "Upcoming",
    "Past Events",
  ];

}
