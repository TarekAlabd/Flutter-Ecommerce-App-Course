import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/label_with_textfield_new_card.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWithTextFieldNewCard(
                  label: 'Card Number',
                  controller: _cardNumberController,
                  icon: Icons.credit_card,
                  hintText: 'Enter card number',
                ),
                const SizedBox(height: 20),
                LabelWithTextFieldNewCard(
                  label: 'Card Holder Name',
                  controller: _cardHolderNameController,
                  icon: Icons.person,
                  hintText: 'Enter card holder name',
                ),
                const SizedBox(height: 20),
                LabelWithTextFieldNewCard(
                  label: 'Expiry Date',
                  controller: _expiryDateController,
                  icon: Icons.date_range,
                  hintText: 'Enter expiry date',
                ),
                const SizedBox(height: 20),
                LabelWithTextFieldNewCard(
                  label: 'CVV',
                  controller: _cvvController,
                  icon: Icons.password,
                  hintText: 'Enter cvv',
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is AddNewCardFailure ||
                        current is AddNewCardSuccess,
                    listener: (context, state) {
                      if (state is AddNewCardSuccess) {
                        Navigator.pop(context);
                      } else if (state is AddNewCardFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                          ),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AddNewCardLoading ||
                        current is AddNewCardFailure ||
                        current is AddNewCardSuccess,
                    builder: (context, state) {
                      if (state is AddNewCardLoading) {
                        return const ElevatedButton(
                          onPressed: null,
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.addNewCard(
                              _cardNumberController.text,
                              _cardHolderNameController.text,
                              _expiryDateController.text,
                              _cvvController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Add Card'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
