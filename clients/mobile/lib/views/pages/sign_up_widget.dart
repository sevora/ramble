import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/button.dart';

import './login_widget.dart';
import 'base_widget.dart';
import 'loading_screen.dart';

class SignUpWidget extends StatefulWidget {
  final UserController userController;
  const SignUpWidget({super.key, required this.userController});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late UserController _userController;
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _passwordVisibility1 = true;
  bool _passwordVisibility2 = true;

  @override
  void initState() {
    _userController = widget.userController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightModeTheme().secondaryBackground,
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500.0,
            ),
            decoration: BoxDecoration(
              color: LightModeTheme().secondaryBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 120.0,
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Sign-up',
                                textAlign: TextAlign.start,
                                style:
                                    TypographyTheme().headlineLarge.override(
                                          fontFamily: 'Roboto',
                                          letterSpacing: 0.0,
                                        ),
                              ),
                              Text(
                                'now',
                                style:
                                    TypographyTheme().headlineLarge.override(
                                          fontFamily: 'Roboto',
                                          color: LightModeTheme().orangePeel,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                validator: (text) {
                                  if (text != null && text.isNotEmpty) {
                                    return "Email is required";
                                  }
                                  return null;
                                },

                                onChanged: (text) {
                                  setState(() {
                                    _email = text;
                                  });
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  labelText: 'Email',
                                  alignLabelWithHint: false,
                                  hintStyle:
                                      TypographyTheme().labelMedium.override(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                ),
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                validator: (text) {
                                  if (text != null && text.isNotEmpty) {
                                    return "Username is required";
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    _username = text;
                                  });
                                },
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  labelText: 'Username',
                                  alignLabelWithHint: false,
                                  hintStyle:
                                      TypographyTheme().labelMedium.override(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                ),
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(

                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    _password = text;
                                  });
                                },
                                validator: (text) {
                                  if (text != null && text.isNotEmpty) {
                                    return "Password is required";
                                  }
                                  return null;
                                },
                                autofocus: true,
                                obscureText: _passwordVisibility1,
                                decoration: InputDecoration(
                                  isDense: false,
                                  labelText: 'Password',
                                  alignLabelWithHint: false,
                                  hintStyle:
                                      TypographyTheme().labelMedium.override(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                  suffixIcon: InkWell(
                                    onTap: () => safeSetState(
                                      () => _passwordVisibility1 =
                                          !_passwordVisibility1,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _passwordVisibility1
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    _confirmPassword = text;
                                  });
                                },
                                validator: (text) {
                                  if (text != _password) {
                                    return "Passwords must match";
                                  }
                                  return null;
                                },
                                autofocus: true,
                                obscureText: _passwordVisibility2,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintStyle:
                                      TypographyTheme().labelMedium.override(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 0.0,
                                          ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: LightModeTheme().error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                  suffixIcon: InkWell(
                                    onTap: () => safeSetState(
                                      () => _passwordVisibility2 =
                                          !_passwordVisibility2,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _passwordVisibility2
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: ButtonWidget(

                                onPressed: () async {
                                  if (_username.isEmpty || _email.isEmpty || _password.isEmpty || _password != _confirmPassword) {
                                    return null;
                                  }

                                  // can add loading page here
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadingScreen()));
                                  await _userController.signUp(username: _username, email: _email, password: _password);

                                  if (context.mounted && _userController.loggedIn) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                            animation2) =>
                                            BaseWidget(
                                              userController: _userController,),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration
                                            .zero,
                                      ),
                                    );
                                  } else {
                                    // failed to sign up
                                  }
                                },
                                text: 'Sign-up',
                                options: ButtonOptions(
                                  width:
                                      MediaQuery.sizeOf(context).width * 1.0,
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      30.0, 0.0, 30.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: LightModeTheme().orangePeel,
                                  textStyle:
                                      TypographyTheme().titleSmall.override(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 10.0)),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TypographyTheme()
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto',
                                        color: LightModeTheme().secondaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1, animation2) => LogInWidget(userController: _userController,),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Log-in',
                                    style: TypographyTheme()
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Roboto',
                                          color: LightModeTheme().orangePeel,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ].divide(const SizedBox(width: 5.0)),
                            ),
                          ),
                        ],
                      ),
                    ].divide(const SizedBox(height: 20.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
