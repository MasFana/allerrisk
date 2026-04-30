import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'result_controller.dart';

class ResultShareView extends GetView<ResultController> {
  const ResultShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ResultShareView')),
      body: const Center(
        child: Text(
          'ResultShareView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
