import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../themes/themes.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: AppThemes.darkTheme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          isDense: false,
                          border: InputBorder.none,
                          hintText: "Enter Mobile No. :",
                          hintStyle: AppThemes.darkTheme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    height: 40.h,
                    width: 320.w,
                    alignment: AlignmentGeometry.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: AppThemes.darkTheme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          isDense: false,
                          border: InputBorder.none,
                          hintText: "Create Password :",
                          hintStyle: AppThemes.darkTheme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
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
                      child: Text(
                        "Register",
                        style: AppThemes.lightTheme.textTheme.displayMedium!.copyWith(fontSize: 16.sp),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppThemes.warmIvory,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      context.go("/login");
                    },
                    child: Text(
                      "Already registered? Login",
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
            // Bottom overlay design
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 175.h,
                width: double.infinity,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Lottie.asset('assets/Sign In.json', height: 120.h),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}