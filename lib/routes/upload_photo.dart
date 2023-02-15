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
  final List<XFile> _localImageStore = [];
  final List<Uint8List> _loadedFiles = [];

  Future<List<Uint8List>> _load() async {
    _loadedFiles.clear();
    for (var img in _localImageStore) {
      _loadedFiles.add(await img.readAsBytes());
    }
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
                    children: [
                      ...snapshot.data!.map(
                        (e) {
                          return _Wrapper(child: Image.memory(e));
                        },
                      ).toList(),
                      _Wrapper(child: _PickImageButton(
                        onTap: () async {
                          final _chosenImage = await _picker.pickImage(source: ImageSource.gallery);
                          if (_chosenImage == null) return;
                          _localImageStore.add(_chosenImage!);
                          setState(() {});
                        },
                      )),
                    ],
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

class _PickImageButton extends StatelessWidget {
  const _PickImageButton({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.add,
        size: 48,
      ),
    );
  }
}

class _Wrapper extends StatelessWidget {
  const _Wrapper({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: child,
    );
  }
}
