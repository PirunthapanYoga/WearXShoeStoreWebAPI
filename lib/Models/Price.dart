class Price {
  String amount;
  String currency;

  Price({
    required this.amount,
    required this.currency
  });

  factory Price.fromJason(Map<String , dynamic> json) => Price(
      amount: json['amount'],
      currency: json['currency']
  );
}