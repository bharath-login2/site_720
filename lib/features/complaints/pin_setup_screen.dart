import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:site_720/core/constants/routes.dart';
import 'package:site_720/core/utilities/shared_preferences.dart';
import 'package:site_720/data/models/extraworklist/successResponseModelMain.dart';
import 'package:site_720/data/services/http_services.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  List<String> pinDigits = List.filled(4, '');
  int currentIndex = 0;
  bool isLoading = false;
  bool showError = false;
  String errorMessage = '';

  final Color primaryColor = const Color(0xFFC24B68); // Your primary color
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  void _onDigitPressed(String digit) {
    if (currentIndex < 4) {
      setState(() {
        pinDigits[currentIndex] = digit;
        _pinController.text = pinDigits.join();
        currentIndex++;
        showError = false;
        errorMessage = '';
      });

      if (currentIndex == 4) {
        _submitPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pinDigits[currentIndex] = '';
        _pinController.text = pinDigits.join();
        showError = false;
        errorMessage = '';
      });
    }
  }

  void _clearPin() {
    setState(() {
      pinDigits = List.filled(4, '');
      currentIndex = 0;
      _pinController.clear();
      showError = false;
      errorMessage = '';
    });
    _pinFocusNode.requestFocus();
  }

  Future<void> _submitPin() async {
    String enteredPin = pinDigits.join();
    if (enteredPin.length != 4 || int.tryParse(enteredPin) == null) {
      if (!mounted) return;
      setState(() {
        showError = true;
        errorMessage = 'Please enter a valid 4-digit PIN';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
      showError = false;
      errorMessage = '';
    });

    try {
      // Make sure HttpServices has the verifyPin function
      SuccessResponseMain result = await HttpServices.verifyPin(enteredPin);

      if (!mounted) return;

      // Check if result.status is true
      if (result.status == true) {
        /// SAVE PIN
        await saveSharedPreference("pin", enteredPin);
        await saveSharedPreference("is_pin_set", "true");

        // print("PIN SAVED : $enteredPin");

        String? testPin = await getSharedPreference("pin");

        // print("PIN FROM STORAGE : $testPin");

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        // PIN verification failed
        setState(() {
          isLoading = false;
          showError = true;
          errorMessage = result.message ?? 'Invalid PIN';
          _clearPin();
        });
      }
    } on http.ClientException catch (e) {
      // Handle HTTP-specific errors
      if (!mounted) return;
      setState(() {
        isLoading = false;
        showError = true;
        errorMessage = 'Network error: ${e.message}';
        _clearPin();
      });
    } catch (e) {
      // Handle any other errors
      if (!mounted) return;
      setState(() {
        isLoading = false;
        showError = true;
        errorMessage = 'An error occurred. Please try again.';
        _clearPin();
      });

      // Log the error for debugging
      print('PIN verification error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo - Update with your actual logo asset
                    Container(
                      margin: const EdgeInsets.only(bottom: 40, top: 20),
                      child: Image.asset(
                        "assets/images/logo.png", // Your logo path
                        height: 120,
                        width: 120,
                      ),
                    ),

                    Text(
                      'Set Up Your PIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Create a 4-digit PIN for security',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Hidden text field for PIN input
                    Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        keyboardType: TextInputType.none,
                        maxLength: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),

                    // PIN dots display
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: index < currentIndex
                                    ? primaryColor
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                index < currentIndex ? '●' : '',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Error message
                    if (showError)
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Loading indicator
                    if (isLoading)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Setting up PIN...',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Numeric keypad
                    Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [1, 2, 3].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [4, 5, 6].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [7, 8, 9].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.clear_outlined,
                                onPressed: _clearPin,
                                color: Colors.orange,
                              ),
                              _buildNumberButton('0'),
                              _buildActionButton(
                                icon: Icons.backspace_outlined,
                                onPressed: _onBackspacePressed,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Verify button (when PIN is complete)
                    const SizedBox(height: 30),
                    if (currentIndex == 4 && !isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitPin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'SET PIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onDigitPressed(number),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color:
                onPressed != null ? color.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 28,
              color: onPressed != null ? color : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }
}
