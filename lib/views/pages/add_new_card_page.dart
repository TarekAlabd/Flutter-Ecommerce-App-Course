import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Add Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
