import 'package:flutter/material.dart';

class DriverCommissionTypeScreen extends StatefulWidget {
  const DriverCommissionTypeScreen({super.key});

  @override
  State<DriverCommissionTypeScreen> createState() =>
      _DriverCommissionTypeScreenState();
}

class _DriverCommissionTypeScreenState
    extends State<DriverCommissionTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Commission Type Screen"),
      ),
    );
  }
}
