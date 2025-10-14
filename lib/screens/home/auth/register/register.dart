import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/buttons/custombuttons.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _fNameController = TextEditingController();
  final _sNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  bool _showPassword = true;
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fNameController.dispose();
    _sNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Optimized loading dialog - cached and efficient
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006633)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Creating your account...",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Optimized API call with better error handling and performance
  Future<void> _registerUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _isLoading = false);
      return;
    }

    _showLoadingDialog();

    try {
      final url = "$stageBaseUrl/registerenumerator/";
      final body = {
        "contact_number": _phoneController.text,
        "password": _passwordController.text,
        "fname": _fNameController.text.toUpperCase(),
        "sname": _sNameController.text.toUpperCase(),
        "email": _emailController.text
      };

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      _handleRegistrationResponse(response);

    } on SocketException {
      _handleError('Please check your internet connection and try again.');
    } on TimeoutException {
      _handleError('Connection timeout. Please try again.');
    } catch (e) {
      _handleError('Registration failed. Please try again.');
      print('Registration error: $e');
    }
  }

  // Efficient response handling
  void _handleRegistrationResponse(http.Response response) {
    Navigator.of(context).pop(); // Close loading dialog

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final status = data["status"];

      switch (status) {
        case "created":
          _handleSuccess();
          break;
        case "exist":
          _handleError('User account already exists.');
          break;
        default:
          _handleError('Registration failed. Please try again.');
      }
    } else {
      _handleError('Registration failed. Please try again.');
    }
  }

  void _handleSuccess() {
    overlayNotification(
        'Account created successfully. Please sign in.',
        "positive"
    );

    // Use pushReplacement for better navigation performance
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => UserSignIn()),
    );
  }

  void _handleError(String message) {
    setState(() => _isLoading = false);
    overlayNotification(message, "negative");
  }

  // Debounced registration to prevent multiple submissions
  void _handleRegistration() {
    if (_debounceTimer?.isActive ?? false) return;

    _registerUser();

    // _debounceTimer = Timer(Duration(milliseconds: 500), () {
    //   setState(() => _isLoading = true);
    //   _registerUser();
    // });
  }

  // Form validation helper
  bool get _isFormValid {
    return _fNameController.text.trim().isNotEmpty &&
        _sNameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.vertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(theme),
                SizedBox(height: size.height * 0.04),
                _buildRegistrationForm(size),
                SizedBox(height: 24),
                _buildRegisterButton(size),
                SizedBox(height: 24),
                _buildSignInSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create Enumerator Account",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: fPrimaryColour,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Please fill in all required details",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField("First name", _fNameController, Icons.person),
          SizedBox(height: 16),
          _buildNameField("Surname", _sNameController, Icons.person),
          SizedBox(height: 16),
          _buildPhoneField(),
          SizedBox(height: 16),
          _buildEmailField(),
          SizedBox(height: 16),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildNameField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel(width: double.infinity, label),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleRegistration,
          keyboardType: TextInputType.name,
          labelStyle: TextStyle(),
          controller: controller,
          readonly: false,
          obscuretext: false,
          prefixIcon: Icon(icon, color: fPrimaryColour),
          validator: (input) => input?.trim().isEmpty ?? true
              ? '$label is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel(width: double.infinity, "Phone number"),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleRegistration,
          keyboardType: TextInputType.phone,
          labelStyle: TextStyle(),
          controller: _phoneController,
          readonly: false,
          obscuretext: false,
          prefixIcon: Icon(Icons.phone_outlined, color: fPrimaryColour),
          validator: (input) => input?.trim().isEmpty ?? true
              ? 'Phone number is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel(width: double.infinity, "Email"),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleRegistration,
          keyboardType: TextInputType.emailAddress,
          labelStyle: TextStyle(),
          controller: _emailController,
          readonly: false,
          obscuretext: false,
          prefixIcon: Icon(Icons.email_outlined, color: fPrimaryColour),
          validator: (input) {
            if (input?.trim().isEmpty ?? true) {
              return 'Email is required';
            }
            // Basic email validation
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel(width: double.infinity, "Password"),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleRegistration,
          keyboardType: TextInputType.visiblePassword,
          labelStyle: TextStyle(),
          controller: _passwordController,
          readonly: false,
          obscuretext: _showPassword,
          prefixIcon: Icon(Icons.lock_outline_rounded, color: fPrimaryColour),
          suffixIconData: _showPassword ? Icons.visibility : Icons.visibility_off,
          onSuffixButtonClicked: () {
            setState(() => _showPassword = !_showPassword);
          },
          validator: (val) {
            if (val?.trim().isEmpty ?? true) {
              return 'Password is required';
            }
            if (val!.length < 6) {
              return 'Password should be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton(Size size) {
    return LoadingHardButton(
      title: "Create Account",
      color: _isLoading || !_isFormValid ? disabledTextColour : primaryColour,
      loadingTrigger: _isLoading,
      onPress: (_isLoading || !_isFormValid) ? null : _handleRegistration,
    );
  }

  Widget _buildSignInSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already registered?",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: _isLoading ? null : () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => UserSignIn()),
            );
          },
          child: Text(
            "SIGN IN",
            style: TextStyle(
              color: _isLoading ? Colors.grey : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}