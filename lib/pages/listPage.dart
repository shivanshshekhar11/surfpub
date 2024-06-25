import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surfpub/flutterPackage.dart';
import 'package:surfpub/providers.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPage extends ConsumerWidget {
  List<FlutterPackage> packages;
  final bool likedPage;
  ListPage({
    super.key,
    required this.packages,
    required this.likedPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (likedPage) {
      List<FlutterPackage> temp = [];

      for (var i in packages) {
        if (ref.watch(likesProvider).likedMap[i.name] == true) {
          temp.add(i);
        }
      }

      packages = temp;
    }

    if (packages.isEmpty) {
      return Text("No Packages!");
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListComponent(package: packages[index]),
              Container(
                height: 20,
              )
            ],
          );
        },
        itemCount: packages.length,
      ),
    );
  }
}

class ListComponent extends StatelessWidget {
  final FlutterPackage package;
  const ListComponent({
    super.key,
    required this.package,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              package.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.lightBlue.shade700,
              ),
            ),
            Container(
              height: 10,
            ),
            Text(
              package.currentVersion,
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
            Container(
              height: 10,
            ),
            Text(package.description),
            Container(
              height: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                _launchURL(package.homePage);
              },
              child: Text(
                'Home Page',
                style: TextStyle(
                  color: Colors.lightBlue.shade300,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            package.topics.isEmpty
                ? Container(
                    height: 0,
                  )
                : Wrap(
                    children: List.generate(
                    package.topics.length,
                    (i) {
                      return Container(
                        padding: EdgeInsets.only(
                          right: 12,
                          bottom: 12,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.lightBlue.shade700,
                          ),
                          child: Text(
                            package.topics[i],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            Container(
              height: package.topics.isEmpty ? 0 : 10,
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/details', extra: package);
              },
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                padding: EdgeInsets.only(
                  left: 2,
                  right: 2,
                  top: 2,
                  bottom: 2,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

_launchURL(String urlval) async {
  final Uri url = Uri.parse(urlval);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Cannot launch $urlval';
  }
}
