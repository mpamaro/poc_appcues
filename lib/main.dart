import 'package:appcues_flutter/appcues_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'POC Appcues',
      home: const FirstRoute(),
      theme: ThemeData(
        fontFamily: 'NunitoSans',
      ),
    ),
  );
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  String _debugText = 'Não chegou URI!';

  @override
  void initState() {
    super.initState();

    // Initializing Appcues SDK.
    Appcues.initialize('39569', 'bfe534cb-5e28-4fdf-9ff5-1907ea195dc1');

    // Identify an Appcues user.
    Appcues.identify(
      'flutter-user-1',
      {
        'Company': 'Take Blip',
        'Repository': 'https://github.com/mpamaro/poc_appcues',
      },
    );

    // Detect if the app was started by a deeplink
    getInitialUri().then(
      (value) => _handleDeepLink(value),
    );

    // Detect if a new deeplink was sent to the app
    // xcrun simctl openurl booted "appcues-bfe534cb-5e28-4fdf-9ff5-1907ea195dc1://sdk/debugger"
    uriLinkStream.listen(_handleDeepLink);

    Appcues.debug();
  }

  Future<void> _handleDeepLink(Uri? uri) async {
    if (uri != null) {
      // Pass along to Appcues to potentially handle
      final handled = await Appcues.didHandleURL(uri);

      setState(() {
        _debugText = 'Chegou URI: $handled - $uri';
      });
    } else {
      setState(() {
        _debugText = 'Chegou URI, mas está nulo!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Appcues.screen('First Page');

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SelectableText(_debugText),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
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
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    Appcues.screen('Second Page');

    // Appcues.show('64b8a1bb-c774-4303-bfdb-bfcaaa0c034e');

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
