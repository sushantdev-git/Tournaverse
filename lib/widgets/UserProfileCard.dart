import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String heading;
  final String subtitle;
  final Function? onTap;
  final String image;
  const UserProfileCard(
      {required this.heading,
      required this.subtitle,
      required this.onTap,
        required this.image,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.4),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
