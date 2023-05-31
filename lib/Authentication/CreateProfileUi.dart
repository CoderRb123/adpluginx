import 'package:adpluginx/Authentication/Widget/CustomInputField.dart';
import 'package:adpluginx/adpluginx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CreateProfileUi extends HookWidget {
  final Function(String name, String email) onAuthCompleted;
  final Function(String message) onAuthFailed;
  final Function() onAuthCancel;

  const CreateProfileUi({
    Key? key,
    required this.onAuthCompleted,
    required this.onAuthFailed,
    required this.onAuthCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final nameController = useTextEditingController();
    final formKey = useState(GlobalKey<FormState>());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            onAuthCancel();
          },
          icon: const Icon(Icons.clear),
          color: Colors.black,
        ),
        title: const Text(
          "Create your Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: formKey.value,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomInputField(
                    label: "Name",
                    hint: "Enter your Name",
                    validate: (value) {
                      if (value == null) {
                        return "Please Enter Valid Name";
                      }
                      if (value.length < 4) {
                        return "Please Enter More than 4 word";
                      }
                      return null;
                    },
                    maxLines: 1,
                    controller: nameController,
                  ),
                  CustomInputField(
                    label: "Email",
                    hint: "Enter your Email",
                    validate: (value) {
                      if (value == null) {
                        return "Please Enter Valid Email";
                      }
                      if (!value.isValidEmail()) {
                        return "Please Enter Valid Email";
                      }
                      return null;
                    },
                    maxLines: 1,
                    controller: emailController,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: SignInWithAppleButton(
                  onPressed: () {
                    if (formKey.value.currentState!.validate()) {
                      // Do Staff
                      Navigator.pop(context);
                      onAuthCompleted(
                        nameController.text,
                        emailController.text,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
