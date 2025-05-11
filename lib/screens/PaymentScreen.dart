import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  Future<void> _pay() async {
    setState(() => _isLoading = true);
    
    try {
      // 1. Create Payment Intent
      final response = await http.post(
        Uri.parse('http://192.168.18.72:4242/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': 1000, 'currency': 'usd'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent');
      }

      final data = json.decode(response.body);


      log('[DATA]  ${response.body}');
      
      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['clientSecret'],
          merchantDisplayName: 'My Store',
          billingDetails: const BillingDetails(
            email: 'customer@example.com',
            phone: '+15555555555',
            address: Address(
              city: 'San Francisco',
              country: 'US',
              line1: '510 Townsend St',
              postalCode: '94103',
              state: 'California', line2: '',
            ),
          ),
        ),
      );
      
      // 3. Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      // Payment succeeded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total: \$10.00', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _pay,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Pay with Card'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}