import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Change%20Password%20Screens/verify.opt.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class GetUserEmail extends StatefulWidget {
  const GetUserEmail({super.key});

  @override
  State<GetUserEmail> createState() => _GetUserEmailState();
}

class _GetUserEmailState extends State<GetUserEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  _sendEmail() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const VerifyOTP();
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
                    const HeaderText(text: "Email Address Here"),
                    const TitleText(
                      text:
                          "Enter the email address associated with  your account.",
                    ),
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      pattern: r'^[^@]+@[^@]+\.[^@]+$',
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
                      buttonText: "Recover Password",
                      onClick: _sendEmail,
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
