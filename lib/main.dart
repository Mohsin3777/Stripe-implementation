import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_int/screens/PaymentScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = "pk_test_51IMtIYCIzz5B7On2k2MBzHgwMYwWCci2bLRmUoIURWRvzGmhmJp3TneBYBGGrtja15vdF6adzpOy1Rz62T1aE4pD00SwmyE3b3"; // From Stripe Dashboard
  Stripe.merchantIdentifier = '';
  await Stripe.instance.applySettings();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
   
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PaymentScreen(),
    );
  }
}
