class DataModel {
  int? id;
  String value;

  DataModel(this.value, {this.id});

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      DataModel(json['value'], id: json['id']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
