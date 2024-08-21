import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class CheckoutServices {
  Future<void> setCard(String userId, PaymentCardModel paymentCard);
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId,
      [bool chosen = false]);
  Future<PaymentCardModel> fetchSinglePaymentMethod(
      String userId, String paymentId);
}

class CheckoutServicesImpl implements CheckoutServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> setCard(String userId, PaymentCardModel paymentCard) async =>
      await firestoreServices.setData(
        path: ApiPaths.paymentCard(userId, paymentCard.id),
        data: paymentCard.toMap(),
      );

  @override
  Future<List<PaymentCardModel>> fetchPaymentMethods(String userId,
          [bool chosen = false]) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.paymentCards(userId),
        builder: (data, documentId) => PaymentCardModel.fromMap(data),
        queryBuilder:
            chosen ? (query) => query.where('isChosen', isEqualTo: true) : null,
      );

  @override
  Future<PaymentCardModel> fetchSinglePaymentMethod(
          String userId, String paymentId) async =>
      await firestoreServices.getDocument(
        path: ApiPaths.paymentCard(userId, paymentId),
        builder: (data, documentId) => PaymentCardModel.fromMap(data),
      );
}
