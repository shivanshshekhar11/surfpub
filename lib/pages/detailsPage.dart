import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surfpub/flutterPackage.dart';
import 'package:surfpub/providers.dart';

class DetailsPage extends ConsumerWidget {
  final FlutterPackage package;
  const DetailsPage({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: 500,
        child: ListView(
          children: [
            Image.network(
                'https://pbs.twimg.com/media/FKNlhKZUcAEd7FY?format=jpg&name=900x900'),
            Container(height: 15),
            Text(
              package.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.lightBlue.shade700,
              ),
            ),
            Container(
              height: 15,
            ),
            Text(package.description),
            Container(
              height: 15,
            ),
            Row(
              children: [
                Text('Version ' + package.currentVersion),
                Container(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Icon(Icons.link),
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 85,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {
                        var liked =
                            ref.read(likesProvider).likedMap[package.name];

                        if (liked == true) {
                          ref.read(likesProvider).removeLike(package.name);
                        } else {
                          ref.read(likesProvider).addLike(package.name);
                        }
                      },
                      child: ref.watch(likesProvider).likedMap[package.name] ==
                              true
                          ? Text(
                              "Unlike",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Like",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                ),
                Expanded(
                  flex: 15,
                  child: ref.watch(likesProvider).likedMap[package.name] == true
                      ? Icon(
                          Icons.thumb_up,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        )
                      : Icon(Icons.thumb_down,
                          color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
