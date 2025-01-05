import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:bankimoon/data/Models/password.model.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool isPasswordCreated = false;
  final TextEditingController pinController = TextEditingController();
  final TextEditingController createPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  bool isLoading = false; 

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  Future<void> _initialize() async {
    bool passwordExists = await PasswordModel().checkIfPasswordExistsInSQLite();
    setState(() {
      isPasswordCreated = passwordExists; 
    });
  }
  

  void navigateToHome() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.push("/home");
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  void createPin() async {
    if (createPinController.text == confirmPinController.text &&
        createPinController.text.length == 4) {
      setState(() {
        isLoading = true;
      });

      try {
        await PasswordModel().savePasswordToSQLite(createPinController.text, context);
        setState(() {
          isPasswordCreated = true;
          isLoading = false;
        });
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        }

        navigateToHome();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating PIN: $e'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match or are not 4 digits'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void validatePin() async {
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN must be 4 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool isValid = await PasswordModel().validatePassword(pinController.text, context);
      setState(() {
        isLoading = false;
      });

      if (isValid) {
        navigateToHome();
      } else {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid PIN'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error validating PIN: $e'),
          backgroundColor: Colors.red,
        ),
      );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/img.png',
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  const Text(
                    "Bankimoon",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isPasswordCreated) ...[
                    _buildPinField(pinController, "Enter PIN"),
                    _buildButton(
                      size,
                      "Go to Vault",
                      validatePin,
                    ),
                  ] else ...[
                    _buildPinField(createPinController, "Create PIN"),
                    _buildPinField(confirmPinController, "Confirm PIN"),
                    _buildButton(
                      size,
                      "Create PIN",
                      createPin,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 4,
        obscureText: true,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(Size size, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? const SpinKitWave(size: 25, color: Colors.white)
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
