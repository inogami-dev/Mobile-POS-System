import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/themes/theme_state/color_palette.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/authentication/presentation/register_account.dart';
import 'package:pos_system/features/authentication/presentation/widgets/layout_material.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // mainly for login
  late TextEditingController emailController;
  late FocusNode emailFocusNode;
  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;
  // mainly for signup
  late TextEditingController confirmPasswordController;
  // Page
  String appName = "Daten";
  late ColorScheme myColorScheme;

  // error notifier
  late Color emailFieldColor;
  late Color passwordFieldColor;

  // FocusNode confirmPasswordFocusNode = FocusNode();

  bool isGoingToSignUp = false;
  double animatedContainerHeight = 0;
  double rotationAngle = 0;
  int animationDuration = 300;

  // for triggering a loading animation on the Login button
  bool isLoggingIn = false;

  // FOR LOGIN
  Future<void> signInWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      print("LOGGED IN: $userCredential");
    } on FirebaseAuthException catch (e) {
      print("Error during login: ${e.message}");
      // stop the button's loading nimation
      setState(() => isLoggingIn = false);

      // If error was caused by internect connectivity failure
      if (e.message.toString().contains("A network error")) {
        showMyAnimatedSnackBar(
          context: context,
          dataToDisplay:
              "A network error occured. Please check your internet connection and try again.",
        );
      }
      // Incorrect credentials
      else {
        showMyAnimatedSnackBar(
          // ignore: use_build_context_synchronously
          context: context,
          dataToDisplay: "The email or password is incorrect.",
        );
      }
    }
  }

  // FOR EMAIL INPUT FIELD VALIDATION
  void _latestValueOnEmailControllerListener() {
    if ((!emailController.text.contains('@') ||
            (emailController.text.contains('@') &&
                emailController.text.length < 6)) &&
        emailController.text.isNotEmpty) {
      setState(() => emailFieldColor = myColorScheme.onError);
    } else {
      setState(() => emailFieldColor = myColorScheme.primaryFixed);
    }
  }

  // FOR PASSWORD INPUT FIELDS VALIDATION
  void _latestValueOnPasswordListener() {
    if (passwordController.text.trim().length < 6 &&
        passwordController.text.isNotEmpty) {
      setState(() {
        passwordFieldColor = Colors.redAccent;
      });
      print("PASSWORDS DOES NOT MATCH!");
    } else {
      setState(() {
        passwordFieldColor = MyColorPalette.borderColor;
        print("PASSWORDS MATCH!");
      });
    }
  }

  // FOR PASSWORD INPUT FIELDS VALIDATION
  void _latestValueOnConfirmPasswordListener() {
    if (confirmPasswordController.text.trim() !=
            passwordController.text.trim() ||
        confirmPasswordController.text.length < 6) {
      setState(() {
        passwordFieldColor = Colors.redAccent;
      });
      print("PASSWORDS DOES NOT MATCH!");
    } else {
      setState(() {
        passwordFieldColor = MyColorPalette.borderColor;
        print("PASSWORDS MATCH!");
      });
    }
  }

  // to initialize before after usage
  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    emailController.addListener(_latestValueOnEmailControllerListener);
    emailFocusNode = FocusNode();

    passwordController = TextEditingController();
    passwordController.addListener(_latestValueOnPasswordListener);
    passwordFocusNode = FocusNode();

    confirmPasswordController = TextEditingController();
    confirmPasswordController.addListener(
      _latestValueOnConfirmPasswordListener,
    );
  }

  // to clean after usage
  @override
  void dispose() {
    super.dispose();
    emailController.removeListener(_latestValueOnEmailControllerListener);
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.removeListener(_latestValueOnPasswordListener);
    passwordController.dispose();
    passwordFocusNode.dispose();

    confirmPasswordController.removeListener(
      _latestValueOnConfirmPasswordListener,
    );
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myColorScheme = Theme.of(context).colorScheme;
    emailFieldColor = myColorScheme.primaryFixed;
    passwordFieldColor = myColorScheme.primaryFixed;

    return Scaffold(
      backgroundColor: myColorScheme.surface,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: MyDimensions.getWidth(context),
            height: MyDimensions.getHeight(context),
            // color: Colors.amber.shade200,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // MyLayoutMaterial(
                //   distanceFromTop: 0,
                //   heightPercentage: 0.40,
                //   color: myColorScheme.surface,
                // ),
                MyLayoutMaterial(
                  color: myColorScheme.surfaceContainer,
                  distanceFromTop: 130,
                  isSquare: true,
                  isSquareSize: MyDimensions.getHeight(context) * .65,
                  borderRadius: 120,
                  rotationAngle: -4,
                ),
                // This is where the main content is
                MyLayoutMaterial(
                  color: myColorScheme.surfaceContainer,
                  distanceFromTop: 320,
                  heightPercentage: 0.7,
                  isRotatable: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loginContentArea(),

                      SizedBox(height: 20),
                      (isGoingToSignUp) ? confirmSignUpButton() : loginButton(),
                      SizedBox(height: 5),
                      (isGoingToSignUp) ? cancelSignUpButton() : signUpButton(),
                    ],
                  ),
                ),

                // this is where the logo will be placed, and be animated if possible
                Positioned(
                  top: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(15),
                    child: AnimatedContainer(
                      width: 150,
                      height: 150,
                      transformAlignment: Alignment.center,
                      transform: Matrix4.rotationZ(rotationAngle),
                      // color: Colors.blue.shade300,
                      duration: Duration(milliseconds: animationDuration),
                      // onEnd: () {},
                      child: Image.asset("assets/images/isagi.jpg"),
                      // child: Image.network(
                      //   "data:image/png;base64,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",
                      // ),
                    ),
                  ),
                ),

                Positioned(
                  top: 280,
                  // child: MyTextFormatter.h3(text: "WanderHuman", fontsize: 32),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: Duration.zero,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        appName,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          // color: Colors.blue.shade400,
                        ),
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade100,
                          // Colors.white,
                          Colors.blue.shade200,
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                          Colors.blue.shade500,
                          Colors.blue.shade400,
                        ],
                        speed: Duration(milliseconds: 500),
                      ),
                      // RotateAnimatedText(
                      //   "WanderHuman",
                      //   textStyle: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 32,
                      //     color: Colors.blue.shade400,
                      //   ),
                      // ),
                      FadeAnimatedText(
                        appName,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                // App version number
                // Positioned(bottom: 5, child: SafeArea(child: MyAppVersion())),
                Positioned(
                  bottom: 5,
                  child: SafeArea(child: const MyText(text: "1.0.0")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loginContentArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        MyTextfield(
          textController: emailController,
          // prefixIcon: Icons.person_rounded,
          prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMail01),
          labelText: "Email",
          hintText: "inogami@gmail.com",
          textInputType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          borderRadius: 10,
          // color: emailFieldColor,
          borderColor: emailFieldColor,
          activeBorderColor: emailFieldColor,
        ),
        invalidInputVisuals(
          conditionToTriggerWarning:
              (!emailController.text.contains('@') &&
              emailController.text.isNotEmpty &&
              !emailFocusNode.hasFocus),
          warningText: "Please enter a valid email address.",
        ),
        invalidInputVisuals(
          conditionToTriggerWarning:
              (emailController.text.contains('@') &&
              emailController.text.length < 6 &&
              !emailFocusNode.hasFocus),
          warningText: "Invalid email",
        ),
        SizedBox(height: 10),

        MyTextfield(
          textController: passwordController,
          // prefixIcon: Icons.key_rounded,
          prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedKey01),
          labelText: "Password",
          borderRadius: 10,
          focusNode: passwordFocusNode,
          isPasswordField: true,
          borderColor: passwordFieldColor,
          activeBorderColor: passwordFieldColor,
        ),
        invalidInputVisuals(
          conditionToTriggerWarning:
              (passwordController.text.length < 6 &&
              passwordController.text.isNotEmpty),
          warningText: "Invalid password length, at least 6 characters.",
        ),

        AnimatedContainer(
          // width: 0,
          height: animatedContainerHeight,
          margin: EdgeInsets.only(top: 10),
          duration: Duration(milliseconds: animationDuration),
          child: MyTextfield(
            textController: confirmPasswordController,
            // prefixIcon: Icons.key_rounded,
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedKey01),
            prefixIconColor: (animatedContainerHeight == 50 && isGoingToSignUp)
                ? myColorScheme.onSurfaceVariant
                : Colors.transparent,
            suffixIconColor: (animatedContainerHeight == 50 && isGoingToSignUp)
                ? myColorScheme.onSurfaceVariant
                : Colors.transparent,
            labelText: "Confirm Password",
            borderRadius: 10,
            borderWidth: (animatedContainerHeight == 50 && isGoingToSignUp)
                ? 1
                : 0,
            borderColor: (animatedContainerHeight == 50 && isGoingToSignUp)
                ? passwordFieldColor
                : Colors.transparent,
            activeBorderColor: passwordFieldColor,
            isPasswordField: true,
          ),
        ),
        invalidInputVisuals(
          conditionToTriggerWarning:
              (passwordController.text.trim() !=
                  confirmPasswordController.text.trim() &&
              confirmPasswordController.text.isNotEmpty &&
              !passwordFocusNode.hasFocus),
          warningText: "Passwords does not match.",
        ),
      ],
    );
  }

  Widget invalidInputVisuals({
    required bool conditionToTriggerWarning,
    required String warningText,
  }) {
    if (conditionToTriggerWarning) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1),
          MyText(
            text: warningText,
            fontSize: kDefaultFontSize - 4,
            color: myColorScheme.error,
            maxLines: 2,
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget loginButton() {
    return (isLoggingIn)
        ? const MyProgressIndicator()
        : MyCustButton(
            onTap: () async {
              setState(() => isLoggingIn = true);
              await signInWithEmailAndPassword();
              // print("LOGIN BUTTON PRESSEDDDDDDDDDDDDDDDDDDDDDDDDDD");

              FocusManager.instance.primaryFocus?.unfocus();
            },
            buttonText: "LOGIN",
            color: myColorScheme.primary,
            buttonTextFontWeight: FontWeight.w700,
            buttonTextColor: myColorScheme.onPrimary,
            borderColor: myColorScheme.onPrimary,

            // borderColor: Colors.cyan,
          );
  }

  MyCustButton confirmSignUpButton() {
    return MyCustButton(
      onTap: () {
        // if Passwords does not match
        if (passwordController.text.trim() !=
            confirmPasswordController.text.trim()) {
          showMyAnimatedSnackBar(
            context: context,
            dataToDisplay:
                "Passwords does not match. Please make sure it matches.",
          );
        }
        // if Password does not have 6 or more characters
        else if (passwordController.text.length < 6) {
          showMyAnimatedSnackBar(
            context: context,
            dataToDisplay: "Password length must at least 6 characters.",
          );
        }
        // if everything is complied, then proceed
        else {
          bottomModalSheetOfSignUp(
            context: context,
            email: emailController.text,
            password: passwordController.text,
            myColorScheme: myColorScheme,
          );
        }
      },
      buttonText: "REGISTER ACCOUNT",
      color: Colors.blue,
      buttonTextFontWeight: FontWeight.w700,
      buttonTextColor: Colors.white,
      buttonTextSpacing: 1,
      buttonWidth: 200,
    );
  }

  MyCustButton signUpButton() {
    return MyCustButton(
      onTap: () {
        setState(() {
          // if it is 0, move to 50
          if (animatedContainerHeight == 0 && isGoingToSignUp == false) {
            animatedContainerHeight = 50;
            isGoingToSignUp = true;
          }
          // if it is 50, revert back to 0
          else {
            animatedContainerHeight = 0;
            isGoingToSignUp = false;
          }
        });
      },
      buttonText: "SIGNUP",
      color: myColorScheme.surfaceContainer,
      buttonTextFontWeight: FontWeight.w400,
      buttonTextColor: myColorScheme.onSurface,
      enableShadow: false,
      borderWidth: 0.5,
      borderColor: myColorScheme.surfaceContainer,
    );
  }

  MyCustButton cancelSignUpButton() {
    return MyCustButton(
      onTap: () {
        setState(() {
          // requestFocus() para mabalhin ang focus sa textfield before sya ma render out.
          passwordFocusNode.requestFocus();
          passwordFocusNode.unfocus();
          isGoingToSignUp = !isGoingToSignUp;
          animatedContainerHeight = 0;
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        });
      },
      buttonText: "CANCEL",
      color: myColorScheme.surfaceContainer,
      buttonTextFontWeight: FontWeight.w400,
      buttonTextColor: myColorScheme.onSurface,
      enableShadow: false,
      borderWidth: 0.35,
      widthPercentage: 0.35,
      height: 45,
      borderColor: Colors.transparent,
    );
  }
}
