import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surfpub/flutterPackage.dart';
import 'package:surfpub/pages/aboutPage.dart';
import 'package:surfpub/pages/detailsPage.dart';
import 'package:surfpub/pages/listPage.dart';
import 'package:surfpub/providers.dart';

final _router = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => LogIn(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => MyHomePage(title: 'SurfPub'),
  ),
  GoRoute(
    path: '/details',
    builder: (context, state) {
      FlutterPackage package = state.extra as FlutterPackage;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('SurfPub'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: Text(
                  'Log Out',
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: DetailsPage(
            package: package,
          ),
        ),
      );
    },
  ),
]);

void main() {
  runApp(ProviderScope(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'SurfPub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.lightBlue.shade700,
        ),
        useMaterial3: true,
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var username = '';
  var password = '';
  var error = '';
  TextEditingController _controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 200,
        height: 300,
        child: Column(
          children: [
            const Text('Login to SurfPub',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            Container(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (value) => username = value,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: "username",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) => password = value,
                decoration: InputDecoration(
                    hintText: 'password',
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  if (username == 'testuser01') {
                    if (password == 'test01') {
                      context.go('/home');
                    } else {
                      setState(() {
                        error = 'Wrong Password';
                        _controller = TextEditingController(text: '');
                      });
                    }
                  } else {
                    setState(() {
                      error = 'Invalid Username';
                      _controller = TextEditingController(text: '');
                    });
                  }
                },
                child: Text('Log In'),
              ),
            ),
            Text(
              error,
            ),
          ],
        ),
      )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = Container();
    switch (currentIndex) {
      case 0:
        currentWidget = Center(
          child: Consumer(
            builder: (context, ref, child) {
              final AsyncValue<List<FlutterPackage>> packages =
                  ref.watch(packagesProvider);

              return Center(
                child: switch (packages) {
                  AsyncData(:final value) => ListPage(
                      packages: value,
                      likedPage: false,
                    ),
                  AsyncError(:final error) => Text(error.toString()),
                  _ => const CircularProgressIndicator(),
                },
              );
            },
          ),
        );
        break;

      case 1:
        currentWidget = Center(
          child: Consumer(
            builder: (context, ref, child) {
              final AsyncValue<List<FlutterPackage>> packages =
                  ref.watch(packagesProvider);

              return Center(
                child: switch (packages) {
                  AsyncData(:final value) => ListPage(
                      packages: value,
                      likedPage: true,
                    ),
                  AsyncError(:final error) => Text(error.toString()),
                  _ => const CircularProgressIndicator(),
                },
              );
            },
          ),
        );
        break;

      case 2:
        currentWidget = Center(child: AboutPage());
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text(
                'Log Out',
              ),
            ),
          )
        ],
      ),
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
                currentIndex = value;
              }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "List",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              label: "Liked",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "About",
            ),
          ]),
    );
  }
}
