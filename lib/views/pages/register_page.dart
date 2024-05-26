import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/views/widgets/label_with_textfield.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/social_media_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start shopping with create your account!',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: 'Username',
                    controller: usernameController,
                    prefixIcon: Icons.person,
                    hintText: 'Enter you username',
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: 'Email',
                    controller: emailController,
                    prefixIcon: Icons.email,
                    hintText: 'Enter you email',
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: 'Password',
                    controller: passwordController,
                    prefixIcon: Icons.password,
                    hintText: 'Enter you password',
                    // TODO: Make this visibility works well
                    obsecureText: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 40),
                  MainButton(
                    text: 'Create Account',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('You have an account? Login'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Or using other method',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: AppColors.grey,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        SocialMediaButton(
                          text: 'Signup with Google',
                          imgUrl:
                              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16),
                        SocialMediaButton(
                          text: 'Signup with Facebook',
                          imgUrl:
                              'https://www.freepnglogos.com/uploads/facebook-logo-icon/facebook-logo-icon-facebook-logo-png-transparent-svg-vector-bie-supply-15.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
