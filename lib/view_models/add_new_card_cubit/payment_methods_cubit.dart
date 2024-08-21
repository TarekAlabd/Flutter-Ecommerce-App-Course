import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/checkout_services.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymntMethodsInitial());

  String? selectedPaymentId;
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
      await checkoutServices.setCard(currentUser!.uid, newCard);
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
        final chosenPaymentMethod = paymentCards.firstWhere(
          (element) => element.isChosen,
          orElse: () => paymentCards.first,
        );
        selectedPaymentId = chosenPaymentMethod.id;
        emit(PaymentMethodChosen(chosenPaymentMethod));
      }
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> changePaymentMethod(String id) async {
    selectedPaymentId = id;
    try {
      final currentUser = authServices.currentUser();
      final tempChosenPaymentMethod =
          await checkoutServices.fetchSinglePaymentMethod(
        currentUser!.uid,
        selectedPaymentId!,
      );
      emit(PaymentMethodChosen(tempChosenPaymentMethod));
    } catch (e) {
      emit(FetchPaymentMethodsError(e.toString()));
    }
  }

  Future<void> confirmPaymentMethod() async {
    emit(ConfirmPaymentLoading());
    try {
      final currentUser = authServices.currentUser();
      final previousChosenPayment =
          await checkoutServices.fetchPaymentMethods(currentUser!.uid, true);
      final previousChosenPaymentMethod =
          previousChosenPayment.first.copyWith(isChosen: false);
      var chosenPaymentMethod = await checkoutServices.fetchSinglePaymentMethod(
        currentUser.uid,
        selectedPaymentId!,
      );
      chosenPaymentMethod = chosenPaymentMethod.copyWith(isChosen: true);
      await checkoutServices.setCard(
          currentUser.uid, previousChosenPaymentMethod);
      await checkoutServices.setCard(currentUser.uid, chosenPaymentMethod);
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailure(e.toString()));
    }
  }
}
