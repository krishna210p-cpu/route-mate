import 'package:flutter/material.dart';
import 'main.dart';
import 'vehicle_selection.dart';

// Import the smooth route function
class AuthScreen extends StatefulWidget {
  final String role;
  
  AuthScreen({required this.role});
  
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;
  
  String? emailError;
  String? passwordError;
  String? phoneError;
  String? nameError;
  String? confirmPasswordError;
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  
  bool validateEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value);
  }
  
  bool validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegex.hasMatch(value);
  }
  
  bool validatePhone(String value) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(value);
  }
  
  void submitForm() async {
    setState(() {
      isLoading = true;
      emailError = null;
      passwordError = null;
      phoneError = null;
      nameError = null;
      confirmPasswordError = null;
    });
    
    bool hasError = false;
    
    if (isLogin) {
      if (!validateEmail(emailController.text)) {
        emailError = 'Please enter a valid email address (e.g., user@example.com)';
        hasError = true;
      }
      if (passwordController.text.isEmpty) {
        passwordError = 'Password is required';
        hasError = true;
      }
    } else {
      if (nameController.text.isEmpty) {
        nameError = 'Name is required';
        hasError = true;
      }
      if (!validateEmail(emailController.text)) {
        emailError = 'Please enter a valid email address (e.g., user@example.com)';
        hasError = true;
      }
      if (!validatePhone(phoneController.text)) {
        phoneError = 'Please enter a valid 10-digit Indian mobile number';
        hasError = true;
      }
      if (!validatePassword(passwordController.text)) {
        passwordError = 'Password must include uppercase, lowercase, number & special character';
        hasError = true;
      }
      if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
        hasError = true;
      }
    }
    
    if (hasError) {
      setState(() => isLoading = false);
      return;
    }
    
    await Future.delayed(Duration(seconds: 1));
    
    setState(() => isLoading = false);
    
    Navigator.pushReplacement(
      context,
      createSmoothRoute(
        widget.role == "Driver"
            ? VehicleSelectionScreen(role: "Driver")
            : CustomerDashboard(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final roleColor = widget.role == "Customer" ? Colors.blue : Colors.green;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              roleColor.shade50,
              roleColor.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shadowColor: roleColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/design.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      "${widget.role} ${isLogin ? 'Login' : 'Sign Up'}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      isLogin ? 'Login to continue' : 'Create your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Login/Signup Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isLogin ? roleColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: isLogin ? Colors.white : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isLogin ? roleColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: !isLogin ? Colors.white : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Name Field (Signup only)
                    if (!isLogin) ...[
                      _buildTextField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        errorText: nameError,
                        roleColor: roleColor,
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    // Email Field
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      errorText: emailError,
                      roleColor: roleColor,
                    ),
                    SizedBox(height: 16),
                    
                    // Phone Field (Signup only)
                    if (!isLogin) ...[
                      _buildTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        errorText: phoneError,
                        roleColor: roleColor,
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    // Password Field
                    _buildTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      errorText: passwordError,
                      roleColor: roleColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Confirm Password (Signup only)
                    if (!isLogin) ...[
                      _buildTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        errorText: confirmPasswordError,
                        roleColor: roleColor,
                      ),
                      SizedBox(height: 24),
                    ] else ...[
                      SizedBox(height: 24),
                    ],
                    
                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [roleColor.shade400, roleColor.shade600],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: isLoading ? null : submitForm,
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.login, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        isLogin ? 'Login' : 'Sign Up',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color? roleColor,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: errorText != null ? Colors.red : roleColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4),
          Text(
            errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
