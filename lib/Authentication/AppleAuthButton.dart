import 'dart:convert';

import 'package:adpluginx/Authentication/AppAuth.dart';
import 'package:adpluginx/Authentication/CreateProfileUi.dart';
import 'package:adpluginx/Model/UserModel.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthButton extends HookWidget {
  final Function(Map user) onAuthCompleted;
  final Function(String message) onAuthFailed;
  final Function() onAuthCancel;

  const AppleAuthButton({
    Key? key,
    required this.onAuthCompleted,
    required this.onAuthFailed,
    required this.onAuthCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(onPressed: () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.email == null) {
        // User is PreRegister with App
        UserModel? userModel = await AppAuthProvider.getUserByAppleId(credential.userIdentifier!);
        if (userModel != null) {
          // User Fetched
          String userRaw = json.encode(userModel.toJson());
          preferences.setString("appleUser", userRaw);
          onAuthCompleted(userModel.toJson());
        } else {
          // User Not Founded
          userModel = UserModel(id: 1,appPackage: PackageInfoX().packageName,email: "random@gmail.com");
          String userRaw = json.encode(userModel.toJson());
          preferences.setString("appleUser", userRaw);
          onAuthCompleted(userModel.toJson());
        }
        return;
      }
      // User is New To App
      await AppAuthProvider.setAppleId(
        appleId: credential.userIdentifier ?? "",
        email: credential.email ?? "",
        onComplete: () async {
          UserModel? userModel = await AppAuthProvider.getUser();
          if (userModel != null) {
            String userRaw = json.encode(userModel.toJson());
            preferences.setString("appleUser", userRaw);
            onAuthCompleted(userModel.toJson());
          } else {
            onAuthFailed("No User Founded");
          }
        },
      );
    });
  }
}
