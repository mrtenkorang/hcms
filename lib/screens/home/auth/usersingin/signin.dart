import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:hcms_revived2/screens/home/auth/register/register.dart';
import 'package:hcms_revived2/screens/home/index.dart';
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

  // State variables
  bool _showPassword = true;
  bool _isLoading = false;
  String? _offlineContact;
  String? _offlinePassword;

  // Debounce timer to prevent multiple rapid clicks
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _preloadCredentials();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _phonenumController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Preload credentials in background
  void _preloadCredentials() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLogCredentials();
    });
  }

  // Optimized credential loading with caching
  Future<void> _getLogCredentials() async {
    try {
      final db = await DBHelper.database();
      final result = await db.rawQuery('SELECT * FROM first_time_user LIMIT 1');

      if (result.isNotEmpty) {
        setState(() {
          _offlineContact = result[0]['contact']?.toString();
          _offlinePassword = result[0]['password']?.toString();
        });
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  // Optimized loading dialog
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

  // Optimized offline login check
  void _attemptOfflineLogin() {
    if (_offlineContact != null &&
        _offlinePassword != null &&
        _phonenumController.text == _offlineContact &&
        _passwordController.text == _offlinePassword) {

      Navigator.of(context).pop(); // Close loading dialog

      final provider = Provider.of<PersonalFarmerProvider>(context, listen: false);
      provider.setPersistData(
          "0", "notfirst", "Offline User", "offline", "active", "in",
          _offlineContact!, _offlinePassword!
      );

      _navigateToHome();
      overlayNotification('Offline login successful.', "positive");
    } else {
      Navigator.of(context).pop();
      overlayNotification('Invalid offline credentials', "negative");
    }
  }

  // Optimized API login
  Future<void> _attemptApiLogin() async {
    try {
      final response = await http.get(Uri.parse(
          "$stageBaseUrl/enumeratorlogin/?contact=${_phonenumController.text}&password=${_passwordController.text}"
      )).timeout(Duration(seconds: 30));

      final data = json.decode(response.body);
      print('Login response: ${response.body}');

      if (data["status"] == "success") {
        Navigator.of(context).pop();

        final provider = Provider.of<PersonalFarmerProvider>(context, listen: false);
        provider.setPersistData(
            "0", "notfirst", data["name"] ?? "", data["staff_code"].toString() ?? "",
            data["status"] ?? "", "in", _phonenumController.text, _passwordController.text
        );

        _navigateToHome();
        overlayNotification('Login successful.', "positive");
      } else {
        Navigator.of(context).pop();
        overlayNotification(
            data["status"] == "not_found"
                ? 'Account does not exist. Please register.'
                : 'Please check credentials and try again.',
            "negative"
        );
      }
    } on SocketException {
      Navigator.of(context).pop();
      _attemptOfflineLogin();
    } on TimeoutException {
      Navigator.of(context).pop();
      overlayNotification('Connection timeout. Please try again.', "negative");
    } catch (e, stackTrace) {
      Navigator.of(context).pop();
      overlayNotification('Login failed. Please try again.', "negative");
      print('Login error: $e');
      debugPrint('Login error: $stackTrace');
    }
  }

  // Optimized navigation
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => IndexPage(userContact: _phonenumController.text),
      ),
    );
  }

  // Debounced login handler
  void _handleLogin() {
    if (_debounceTimer?.isActive ?? false) return;

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      if (!(_formKey.currentState?.validate() ?? false)) return;

      setState(() => _isLoading = true);
      _showLoadingDialog();

      await _attemptApiLogin();
      setState(() => _isLoading = false);
    });
  }

  // Form validation helpers
  bool get _isFormValid {
    return _phonenumController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.vertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(theme),
                SizedBox(height: size.height * 0.06),
                _buildLoginForm(size),
                SizedBox(height: size.height * 0.04),
                _buildLoginButton(size),
                SizedBox(height: size.height * 0.03),
                _buildRegisterSection(),
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
          "Please sign in to proceed",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: fPrimaryColour,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Enter your credentials to continue",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPhoneField(size),
          SizedBox(height: size.height * 0.025),
          _buildPasswordField(size),
        ],
      ),
    );
  }

  Widget _buildPhoneField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel( "Phone number"),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleLogin,
          keyboardType: TextInputType.phone,
          labelStyle: TextStyle(),
          controller: _phonenumController,
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

  Widget _buildPasswordField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldLabel( "Password"),
        TextFieldWidget(
          labelText: "",
          onSubmitted: _handleLogin,
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
          validator: (val) => val?.trim().isEmpty ?? true
              ? 'Password is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildLoginButton(Size size) {
    return LoadingHardButton(
      title: "Sign In",
      color: _isLoading || !_isFormValid ? disabledTextColour : primaryColour,
      loadingTrigger: _isLoading,
      onPress: (_isLoading || !_isFormValid) ? null : _handleLogin,
    );
  }

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New here?",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: _isLoading ? null : () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Register()),
            );
          },
          child: Text(
            "REGISTER",
            style: TextStyle(
              color: _isLoading ? Colors.grey : Color(0xFF006633),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
