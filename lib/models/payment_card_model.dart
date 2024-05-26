class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final bool isChosen;

  PaymentCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.isChosen = false,
  });

  PaymentCardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    bool? isChosen,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isChosen: isChosen ?? this.isChosen,
    );
  }
}

List<PaymentCardModel> dummyPaymentCards = [
  PaymentCardModel(
    id: '1',
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'Tarek Alabd',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '2',
    cardNumber: '1234 5678 9012 3466',
    cardHolderName: 'John Doe',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '3',
    cardNumber: '1234 5678 9012 3477',
    cardHolderName: 'Tim Smith',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '4',
    cardNumber: '1234 5678 9012 3488',
    cardHolderName: 'John Doe',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '5',
    cardNumber: '1234 5678 9012 3499',
    cardHolderName: 'Tim Smith',
    expiryDate: '12/23',
    cvv: '123',
  ),
];
