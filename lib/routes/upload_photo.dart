import 'package:client/routes/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _localImageStore = [];
  List<Uint8List> _loadedFiles = [];
  // XFile? _chosenImage;

  Future<List<Uint8List>> _load() async {
    _loadedFiles = [];
    _localImageStore.forEach((element) async {
      //
      _loadedFiles.add(await element.readAsBytes());
    });
    return _loadedFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              height: 500,
              child: FutureBuilder<List<Uint8List>>(
                future: _load(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    // maxCrossAxisExtent: 400,
                    children: snapshot.data!.map(
                      (e) {
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.memory(e),
                        );
                      },
                    ).toList(),
                  );
                }),
              ),
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('pick photo'),
                    onPressed: () async {
                      final _chosenImage = await _picker.pickImage(source: ImageSource.gallery);
                      _localImageStore.add(_chosenImage!);
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text('clear'),
                    onPressed: () async {
                      //
                      _localImageStore.clear();
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text('next'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => FeedScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
