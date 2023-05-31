import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerApp extends HookWidget {
  final String image;
  final int imageType;
  final bool forceColor;
  final Color color;
  final String title;
  final String subtitle;
  final Function() onClick;

  const ContainerApp({
    Key? key,
    required this.image,
     this.forceColor = true,
    this.imageType = 0,
    this.color = Colors.green,
    required this.title,
    required this.subtitle,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return () {};
    }, []);
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10.0),
      width: 1.sw,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            width: 1.sw,
            height: 72.h,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned(
                  right: 50,
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(right: 50.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.45),
                          spreadRadius: 50.0,
                          offset: const Offset(0, 0),
                          blurRadius: 100.0,
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            child: BlurryContainer(
              width: 1.sw,
              height: 72.h,
              blur: 1,
              elevation: 1,
              color: Colors.white.withOpacity(0.09),
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: Center(
                child: ListTile(
                  onTap: onClick,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: imageType == 0
                          ? CachedNetworkImage(
                              imageUrl: image,
                              color: Colors.white,
                              height: 30,
                              width: 30,
                            )
                          : Image.asset(
                              image,
                              color: forceColor ? Colors.white : null,
                              height: 30,
                              width: 30,
                            ),
                    ),
                  ),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
