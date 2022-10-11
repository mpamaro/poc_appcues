import 'package:appcues_flutter/appcues_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Appcues SDK.
  await Appcues.initialize('39569', 'APPCUES_APPLICATION_ID');

  // Identify an Appcues user.
  await Appcues.identify(
    'flutter-user-1',
    {
      'Company': 'Take Blip',
      'Repository': 'https://github.com/mpamaro/poc_appcues',
    },
  );

  // Detect if a new deeplink was sent to the app
  // xcrun simctl openurl booted "appcues-APPCUES_APPLICATION_ID://sdk/debugger"
  uriLinkStream.listen(
    (Uri? uri) async {
      if (uri != null) {
        // Pass along to Appcues to potentially handle
        await Appcues.didHandleURL(uri);
      }
    },
  );

  runApp(
    const MaterialApp(
      title: 'POC Appcues',
      home: FirstRoute(),
    ),
  );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    Appcues.screen('First Page');

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Appcues.track('Open button was clicked');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecondRoute(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    Appcues.screen('Second Page');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Appcues.track('Back button was clicked');
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
