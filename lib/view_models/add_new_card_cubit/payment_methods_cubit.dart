import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymntMethodsInitial());

  String selectedPaymentId = dummyPaymentCards.first.id;

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
          final chosenPaymentMethod = dummyPaymentCards.firstWhere(
            (paymentCards) => paymentCards.isChosen == true,
            orElse: () => dummyPaymentCards.first,
          );
          emit(FetchedPaymentMethods(dummyPaymentCards));
          emit(PaymentMethodChosen(chosenPaymentMethod));
        } else {
          emit(FetchPaymentMethodsError('No payment methods found'));
        }
      },
    );
  }

  void changePaymentMethod(String id) {
    selectedPaymentId = id;
    var tempChosenPaymentMethod = dummyPaymentCards
        .firstWhere((paymentCard) => paymentCard.id == selectedPaymentId);
    emit(PaymentMethodChosen(tempChosenPaymentMethod));
  }

  void confirmPaymentMethod() {
    emit(ConfirmPaymentLoading());
    Future.delayed(
      const Duration(seconds: 1),
      () {
        var chosenPaymentMethod = dummyPaymentCards
            .firstWhere((paymentCard) => paymentCard.id == selectedPaymentId);
        var previousPaymentMethod = dummyPaymentCards.firstWhere(
          (paymentCard) => paymentCard.isChosen == true,
          orElse: () => dummyPaymentCards.first,
        );
        previousPaymentMethod = previousPaymentMethod.copyWith(isChosen: false);
        chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
        final previousIndex = dummyPaymentCards.indexWhere(
            (paymentCard) => paymentCard.id == previousPaymentMethod.id);
        final chosenIndex = dummyPaymentCards.indexWhere(
            (paymentCard) => paymentCard.id == chosenPaymentMethod.id);
        dummyPaymentCards[previousIndex] = previousPaymentMethod;
        dummyPaymentCards[chosenIndex] = chosenPaymentMethod;
        emit(ConfirmPaymentSuccess());
      },
    );
  }
}
