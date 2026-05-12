import 'package:flutter/material.dart';
import '../../../core/storage/secret_storage.dart';
import '../../../core/di/injection_container.dart';

class AuthenticatedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AuthenticatedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: sl<SecretStorage>().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        final token = snapshot.data;
        final headers = token != null ? {'Authorization': 'Bearer $token'} : null;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: NetworkImage(imageUrl, headers: headers),
              fit: fit,
            ),
          ),
        );
      },
    );
  }
}
