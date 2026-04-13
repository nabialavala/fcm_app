import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';
  String tokenText = 'Fetching token...';

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    await  _fcmService.initialize(onData: (message) {
      setState(() {
        statusText = message.notification?.title ?? 'Payload received';
        imagePath = 'assets/images/${message.data['asset'] ?? 'default'}.png';
      });
    });

    final token = await _fcmService.getToken();

    setState(() {
      tokenText = token ?? 'Token not avaiable';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  errorBuilder: (context, error, StackTrace) {
                    return const Text(
                      'Image not found.',
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'FCM Token:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(
              tokenText, 
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}