class save_data_class {
  String Message;
  bool IsSuccess;
  String Data;
  bool IsRecord;

  save_data_class({this.Message, this.IsSuccess, this.Data, this.IsRecord});

  factory save_data_class.fromJson(Map<String, dynamic> json) {
    return save_data_class(
      Message: json['Message'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      Data: json['Data'] as String,
      IsRecord: json['IsRecord'] as bool,
    );
  }
}
