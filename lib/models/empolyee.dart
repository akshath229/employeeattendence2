class Employee {
  final String compcode;
  final String empcode;
  final String empname;
  final int mobileNumber;
  final String checktype;
  final double longitude;
  final double latitude;
  final int floor;
  final String address;
  final String street;
  final String sublocality;
  final String locality;
  final String date;
  final String time;
  final String present;
  final String attday;

  Employee({
    required this.compcode,
    required this.empcode,
    required this.empname,
    required this.mobileNumber,
    required this.checktype,
    required this.longitude,
    required this.latitude,
    required this.floor,
    required this.address,
    required this.street,
    required this.sublocality,
    required this.locality,
    required this.date,
    required this.time,
    required this.present,
    required this.attday,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      compcode: json['compcode'],
      empcode: json['empcode'],
      empname: json['empname'],
      mobileNumber: json['mobile_number'],
      checktype: json['checktype'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      floor: json['floor'],
      address: json['address'],
      street: json['street'],
      sublocality: json['sublocality'],
      locality: json['locality'],
      date: json['date'],
      time: json['time'],
      present: json['present'],
      attday: json['attday'],
    );
  }
}
