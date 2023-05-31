import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoSubBanner extends HookWidget {
  final String inAppRoute;

  const NoSubBanner({
    Key? key,
    required this.inAppRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.amber,
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 0),
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            inAppRoute,
          );
        },
        child: Stack(
          children: [
            ListTile(
              leading: Image.asset(
                "assets/premium.gif",
                color: Colors.black,
              ),
              title: const Text(
                "Enjoy Premium Experience",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Ad Free & More",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
