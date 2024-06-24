class StudentModel {
  int? id;
  String name;
  String fName;
  String village;
  String fees;
  String joinDate;
  String image;
  String pendingFee;
  String paidFee;

  StudentModel({
    required this.name,
    required this.fName,
    required this.village,
    required this.image,
    required this.joinDate,
    required this.fees,
    required this.pendingFee,
    required this.paidFee,
    this.id,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'fName': fName,
      'village': village.toString(),
      'fee': fees.toString(),
      'joinDate': joinDate.toString(),
      'image': image,
      'pendingFee': pendingFee,
      'paidFee': paidFee
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
        id: map['id'],
        name: map['name'],
        fName: map['fName'],
        village: map['village'].toString(),
        fees: map['fee'].toString(),
        joinDate: map['joinDate'].toString(),
        image: map['image'],
        pendingFee: map['pendingFee'].toString(),
        paidFee: map['paidFee'].toString());
  }
}
