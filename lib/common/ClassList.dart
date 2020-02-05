class CartData{
  int CartCount;

  CartData({this.CartCount});
}

class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;
  bool IsRecord;

  SaveDataClass({this.Message, this.IsSuccess, this.Data, this.IsRecord});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
      Message: json['Message'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      Data: json['Data'] as String,
      IsRecord: json['IsRecord'] as bool,
    );
  }
}
