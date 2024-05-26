class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  PaymentCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });
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
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'John Doe',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '3',
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'Tim Smith',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '2',
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'John Doe',
    expiryDate: '12/23',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '3',
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'Tim Smith',
    expiryDate: '12/23',
    cvv: '123',
  ),
];
