import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
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
                  SizedBox(height: 20.h),
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
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          isDense: false,
                          border: InputBorder.none,
                          hintText: "Create Password :",
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
                        "Register",
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
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Lottie.asset('assets/Sign In.json', height: 120.h),
                    ],
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
