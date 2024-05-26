import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymntMethodsInitial());

  void addNewCard(
      String cardNumber, String cardHolderName, String expiryDate, String cvv) {
    emit(AddNewCardLoading());
    final newCard = PaymentCardModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () {
        dummyPaymentCards.add(newCard);
        emit(AddNewCardSuccess());
      },
    );
  }

  void fetchPaymentMethods() {
    emit(FetchingPaymentMethods());
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (dummyPaymentCards.isNotEmpty) {
          emit(FetchedPaymentMethods(dummyPaymentCards));
        } else {
          emit(FetchPaymentMethodsError('No payment methods found'));
        }
      },
    );
  }
}
