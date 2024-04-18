// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum OrderStatus { active, complete }

class PositionDbModel {
  String? name;
  int? amount;
  double? cost;
  int? order_id;

  PositionDbModel({
    this.name,
    this.amount,
    this.cost,
  });

  PositionDbModel copyWith({
    String? name,
    int? amount,
    double? cost,
  }) {
    return PositionDbModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'cost': cost,
      'order_id': order_id
    };
  }

  factory PositionDbModel.fromMap(Map<String, dynamic> map) {
    return PositionDbModel(
      name: map['name'] != null ? map['name'] as String : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
      cost: map['cost'] != null ? map['cost'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PositionDbModel.fromJson(String source) =>
      PositionDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Position(name: $name, amount: $amount, cost: $cost)';

  @override
  bool operator ==(covariant PositionDbModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.amount == amount && other.cost == cost;
  }

  @override
  int get hashCode => name.hashCode ^ amount.hashCode ^ cost.hashCode;
}

class HistoryDbModel {
  int? id;
  DateTime? date_time;
  double? totalcost;
  OrderStatus? status;
  List<PositionDbModel>? positions = [];
  HistoryDbModel(
      {this.date_time, this.totalcost, this.status, this.positions, this.id});

  HistoryDbModel copyWith({
    DateTime? date_time,
    double? totalcost,
    OrderStatus? status,
  }) {
    return HistoryDbModel(
      date_time: date_time ?? this.date_time,
      totalcost: totalcost ?? this.totalcost,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date_time': date_time?.millisecondsSinceEpoch,
      'totalcost': totalcost,
      'status': status?.toString(),
    };
  }

  factory HistoryDbModel.fromMap(Map<String, dynamic> map) {
    return HistoryDbModel(
      date_time: map['date_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date_time'] as int)
          : null,
      totalcost: map['totalcost'] != null ? map['totalcost'] as double : null,
      status: map['status'] != null
          ? OrderStatus.values
              .firstWhere((e) => (e.toString() == map['status']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryDbModel.fromJson(String source) =>
      HistoryDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HistoryDbModel(date_time: $date_time, totalcost: $totalcost, status: $status)';

  @override
  bool operator ==(covariant HistoryDbModel other) {
    if (identical(this, other)) return true;

    return other.date_time == date_time &&
        other.totalcost == totalcost &&
        other.status == status;
  }

  @override
  int get hashCode => date_time.hashCode ^ totalcost.hashCode ^ status.hashCode;
}
