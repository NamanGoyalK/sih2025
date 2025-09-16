import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 140.h),
                  Container(
                    height: 40.h,
                    width: 320.w,
                    alignment: AlignmentGeometry.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          isDense: false,
                          border: InputBorder.none,
                          hintText: "Enter Mobile No. :",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  InkWell(
                    onTap: () {
                      context.go("/main");
                    },
                    child: Container(
                      height: 30.h,
                      width: 150.w,
                      alignment: AlignmentGeometry.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      context.go("/register");
                    },
                    child: Text(
                      "Haven't registered?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Top overlay design
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 175.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha((0.25 * 255).toInt()),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // SizedBox(height: 30.h,),
                      // SizedBox(height: 10.h,),

                      Lottie.asset(
                        'assets/Sign In.json',
                        height: 120.h,
                      ),
                      // Text(
                      //   "Login",
                      //   style: AppThemes.lightTheme.primaryTextTheme.titleLarge!.copyWith(fontSize: 60.sp, fontWeight: FontWeight.bold, fontFamily: "cursive", color: Colors.grey),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
          ],
        ),
      ),
    );
  }
}
