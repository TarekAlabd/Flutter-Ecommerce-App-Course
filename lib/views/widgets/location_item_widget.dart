import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class LocationItemWidget extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;
  final LocationItemModel location;
  const LocationItemWidget({
    super.key,
    this.borderColor = AppColors.grey,
    required this.onTap,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${location.city}, ${location.country}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.grey,
                        ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: borderColor,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      location.imgUrl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
