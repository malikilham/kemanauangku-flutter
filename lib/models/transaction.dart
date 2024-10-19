enum TransactionType {
  income,
  expense,
}

class TransactionModel {
  String name;
  TransactionType type;
  int amount;
  DateTime date;
  String description;

  TransactionModel({
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type == TransactionType.income ? 'income' : 'expense',
        'amount': amount,
        'date': date.toIso8601String(),
        'description': description,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      name: json['name'],
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
