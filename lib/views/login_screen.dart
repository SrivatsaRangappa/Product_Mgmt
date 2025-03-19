import 'package:flutter/material.dart';
import 'package:product_mgmt_app/views/product_management_screen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rememberMe = false;

  void _attemptLogin(BuildContext context) async {
    String username = mobileController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username & Password cannot be empty"),
         
        ),
      );
      return;
    }

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    bool success = await authVM.login(username, password);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ProductManagementScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
       
          Image.asset(
            "assets/background.png",
            fit: BoxFit.cover,
          ),

      
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              
                  Image.asset(
                    "assets/logo.png",
                    height: 80,
                  ),
                  const SizedBox(height: 60),

                
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),

                          /// 🔹 Username Field
                          TextField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 15),

                       
                          TextField(
                            controller: passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                        
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          const SizedBox(height: 15),

                     
                          Consumer<AuthViewModel>(
                            builder: (context, authVM, child) {
                              return authVM.isLoading
                                  ? const CircularProgressIndicator()
                                  : GestureDetector(
                                      onTap: () => _attemptLogin(context),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade900,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
