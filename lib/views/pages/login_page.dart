import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/views/widgets/label_with_textfield.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/social_media_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  'Login Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please, login with registered account!',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.grey,
                      ),
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password'),
                  ),
                ),
                const SizedBox(height: 16),
                MainButton(
                  text: 'Login',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Don\'t have an account? Register'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Or using other method',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: AppColors.grey,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SocialMediaButton(
                        text: 'Login with Google',
                        imgUrl:
                            'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      SocialMediaButton(
                        text: 'Login with Facebook',
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
    );
  }
}
