import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0E1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 72,
              color: Color(0xFF00D4AA),
            ),
            SizedBox(height: 16),
            Text(
              'Spendly',
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFF00D4AA),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
