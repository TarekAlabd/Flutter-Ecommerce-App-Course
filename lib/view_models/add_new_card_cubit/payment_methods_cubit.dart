import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/checkout_services.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymntMethodsInitial());

  String selectedPaymentId = dummyPaymentCards.first.id;
  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> addNewCard(String cardNumber, String cardHolderName,
      String expiryDate, String cvv) async {
    emit(AddNewCardLoading());
    try {
      final newCard = PaymentCardModel(
        id: DateTime.now().toIso8601String(),
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
        cvv: cvv,
      );
      final currentUser = authServices.currentUser();
      await checkoutServices.addNewCard(currentUser!.uid, newCard);
      emit(AddNewCardSuccess());
    } catch (e) {
      emit(AddNewCardFailure(e.toString()));
    }
  }

  Future<void> fetchPaymentMethods() async {
    emit(FetchingPaymentMethods());
    try {
      final currentUser = authServices.currentUser();
      final paymentCards =
          await checkoutServices.fetchPaymentMethods(currentUser!.uid);
      emit(FetchedPaymentMethods(paymentCards));
      if (paymentCards.isNotEmpty) {
        final chosenPaymentMethod = paymentCards[0];
        emit(PaymentMethodChosen(chosenPaymentMethod));
      }
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
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
