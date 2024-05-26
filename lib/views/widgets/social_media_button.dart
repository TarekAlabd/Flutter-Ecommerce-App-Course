import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class SocialMediaButton extends StatelessWidget {
  final String text;
  final String imgUrl;
  final VoidCallback onTap;

  const SocialMediaButton({
    super.key,
    required this.text,
    required this.imgUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: imgUrl,
                width: 25,
                height: 25,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 16),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
