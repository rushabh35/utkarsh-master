import 'package:flutter/material.dart';
import 'package:utkarsh/services/auth.dart';
import 'package:utkarsh/widgets/TextFieldWidget.dart';
import '../../../../utils/ui/ClickableText.dart';
import '../../../../utils/ui/CustomButton.dart';
import '../../../../utils/ui/CustomTextWidget.dart';
import '../../../../widgets/PasswordTextField.dart';
import '../../constants/app_constants_colors.dart';
import '../../utils/ui/CustomBoldText.dart';
import '../../widgets/LoginTextField.dart';
import '../Home/Navbar.dart';
import 'UsersSignIn.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passWordController = TextEditingController();
  // TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  bool _isNotValid = false;

  @override
  void dispose() {
    _passWordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            sizeHeight * 0.05), // Set the desired app bar height
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              color: AppConstantsColors.blackColor,
            ),
          ),
          centerTitle: true,
          elevation: 0, // Remove the app bar shadow
          backgroundColor: Colors.white, // Set the background color
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // SizedBox(height: sizeHeight * 0.2),
              CustomBoldText(
                text: 'Create Account',
                fontSize: sizeHeight * 0.05,
                textColor: AppConstantsColors.accentColor,
              ),
        
              // LoginTextFieldWidget(controller: _nameController, hintText: 'Name'),
              LoginTextFieldWidget(
                controller: _emailController,
                hintText: 'Email',
                errorText: _isNotValid ? "Enter Email Field" : null,
              ),
              TextFieldWidget(controller: _nameController, hintText: 'Name',
                errorText : _isNotValid ? "Enter Name Field" : null,
              ),
              TextFieldWidget(controller: _numberController, hintText: 'PhoneNumber', keyboardType: TextInputType.number,
                errorText : _isNotValid ? "Enter Number Field" : null,
              ),
              PasswordTextField(
                controller: _passWordController,
                hintText: 'Password',
                errorText: _isNotValid ? "Enter Password Field" : null,
              ),
        
              CustomButton(
                buttonColor: AppConstantsColors.accentColor,
                text: 'SIGN UP',
                onPressed: () async {
                  try{
                    // if(_formKey.currentState!.validate()){
                      await context.read<AuthenticationServices>().signUp(
                        email: _emailController.text.trim(),
                        password: _passWordController.text.trim(),
                        name: _nameController.text.trim(),
                        number: _numberController.text.trim(),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BottomNavBar(),
                        ),
                      );
                    // } else {
                      //todo: show toast
                    // }
                  } catch(e){
                    debugPrint(e.toString());
                  }

                  // _register(),
                  // if (_emailController.text.isEmpty ||
                  //     _passWordController.text.isEmpty)
                  //   {
                  //     setState(() {
                  //       _isNotValid = true;
                  //       return;
                  //     })
                  //   }
                  // else
                  //   {
                  //     setState(() {
                  //       _isNotValid = false;
                  //     }),
                  //     FirebaseAuth.instance
                  //     .createUserWithEmailAndPassword(
                  //         email: _emailController.text,
                  //         password: _passWordController.text)
                  //     .then((value) {
                  //   print("Created New Account");
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const BottomNavBar()),
                  //   );
                  // }).catchError((e) {
                  //   String errorMessage =
                  //       "An error occurred email already registered";
                  //   if (e.code == 'weak-password') {
                  //     errorMessage = 'The password provided is too weak.';
                  //   } else if (e.code == 'email-already-in-use') {
                  //     errorMessage = 'The account already exists for that email.';
                  //   }
                  //   // Display error message in the UI
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return AlertDialog(
                  //         title: const Text('Sign Up Error'),
                  //         content: Text(errorMessage),
                  //         actions: [
                  //           ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor: AppConstantsColors.accentColor,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //             child: const Text('OK'),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // })
                  //   },
                  
                  
                },
                width: sizeWidth * 0.92,
                height: sizeHeight * 0.06,
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: sizeWidth * 0.25,
                    height: 1, // Adjust the height as needed
                    color: AppConstantsColors.grey, // Set the color here
                  ),
                  const CustomTextWidget(
                    text: 'Or continue with',
                    textColor: AppConstantsColors.grey,
                  ),
                  Container(
                    width: sizeWidth * 0.25,
                    height: 1, // Adjust the height as needed
                    color: AppConstantsColors.grey, // Set the color here
                  ),
                ],
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomTextWidget(
                    text: 'Already have an account? ',
                    textColor: AppConstantsColors.blackColor,
                  ),
                  ClickableText(
                    text: 'Sign In',
                    textColor: AppConstantsColors.redColor,
                    fontSize: 14,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserSignIn()));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
