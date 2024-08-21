import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class CheckoutServices {
  Future<void> addNewCard(String userId, PaymentCardModel paymentCard);
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId);
}

class CheckoutServicesImpl implements CheckoutServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addNewCard(String userId, PaymentCardModel paymentCard) async =>
      await firestoreServices.setData(
        path: ApiPaths.paymentCard(userId, paymentCard.id),
        data: paymentCard.toMap(),
      );

  @override
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.paymentCards(userId),
        builder: (data, documentId) => PaymentCardModel.fromMap(data),
      );
}
