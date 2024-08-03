import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Change%20Password%20Screens/set.new.password.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _GetUserEmailState();
}

class _GetUserEmailState extends State<VerifyOTP> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  _verifyOTP() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const SetNewPassword();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedCircle(
            top: -30,
            left: -150,
          ),
          PositionedCircle(
            top: 530,
            right: -150,
          ),
          Form(
              key: _formKey,
              child: CustomContainer(
                child: Column(
                  children: [
                    const HeaderText(text: "Get You Code"),
                    const TitleText(
                      text:
                          "please enter 6 digit code that send to your email address.",
                    ),
                    CustomTextFormField(
                      controller: _otpController,
                      labelText: "OTP",
                      prefixIcon: Icons.pin,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      buttonText: "Verify OTP",
                      onClick: _verifyOTP,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
