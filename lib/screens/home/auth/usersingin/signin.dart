import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/controller/api/api_methods.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/home/auth/register/register.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/sync/sync_page.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/buttons/custombuttons.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserSignIn extends StatefulWidget {
  @override
  _UserSignInState createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final _formKey = GlobalKey<FormState>();
  final _phonenumController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = true;
  bool _isLoading = false;
  String? _offlineContact;
  String? _offlinePassword;
  Timer? _debounceTimer;


  @override
  void dispose() {
    _debounceTimer?.cancel();
    _phonenumController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006633)),
              ),
              SizedBox(height: 16),
              Text(
                "Signing in...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => SyncPage()),
    );
  }

  void _handleLogin() async {
    if (_debounceTimer?.isActive ?? false) return;

    final loginRes = await APIMethods.login(
      _phonenumController.text.trim(),
      _passwordController.text.trim(),
    );

    if (loginRes["success"]) {
      _navigateToHome();
      Globals().showSnackBar(
        title: "Logged In",
        message: " You are logged in successfully",
      );
    } else {
      Globals().showSnackBar(title: "Login Failed", message: loginRes["error"]);
    }
  }

  bool get _isFormValid {
    return _phonenumController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height - MediaQuery.of(context).padding.vertical,
            child: Column(
              children: [
                _buildTopSection(size),
                Expanded(
                  child: _buildFormSection(size),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF006633),
            Color(0xFF008844),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.agriculture_rounded,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Sign in to continue to your account",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(Size size) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildLoginForm(size),
          SizedBox(height: 32),
          _buildLoginButton(size),
          SizedBox(height: 24),
          _buildForgotPassword(),
          Spacer(),
          _buildRegisterSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLoginForm(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPhoneField(size),
          SizedBox(height: 20),
          _buildPasswordField(size),
        ],
      ),
    );
  }

  Widget _buildPhoneField(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFieldWidget(
        labelText: "Phone number",
        onSubmitted: _handleLogin,
        keyboardType: TextInputType.phone,
        labelStyle: TextStyle(color: Colors.grey[600]),
        controller: _phonenumController,
        readonly: false,
        obscuretext: false,
        prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF006633)),
        validator: (input) =>
        input?.trim().isEmpty ?? true ? 'Phone number is required' : null,
      ),
    );
  }

  Widget _buildPasswordField(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFieldWidget(
        labelText: "Password",
        onSubmitted: _handleLogin,
        keyboardType: TextInputType.visiblePassword,
        labelStyle: TextStyle(color: Colors.grey[600]),
        controller: _passwordController,
        readonly: false,
        obscuretext: _showPassword,
        prefixIcon: Icon(Icons.lock_outline_rounded, color: Color(0xFF006633)),
        suffixIconData: _showPassword ? Icons.visibility : Icons.visibility_off,
        onSuffixButtonClicked: () {
          setState(() => _showPassword = !_showPassword);
        },
        validator: (val) =>
        val?.trim().isEmpty ?? true ? 'Password is required' : null,
      ),
    );
  }

  Widget _buildLoginButton(Size size) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isLoading || !_isFormValid) ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF006633),
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          "Sign In",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _isLoading
            ? null
            : () {
          // Handle forgot password
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF006633),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Register()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: _isLoading ? Colors.grey : Color(0xFF006633),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}