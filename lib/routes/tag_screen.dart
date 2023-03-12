import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  final TextfieldTagsController _controller = TextfieldTagsController();
  final textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your fields of interest'),
            const SizedBox(height: 20),
            Builder(builder: (context) {
              final width = MediaQuery.of(context).size.width / 2;
              return SizedBox(
                width: width,
                child: TextFieldTags(
                  textfieldTagsController: _controller,
                  initialTags: const [],
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.small,
                  inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return Column(
                        children: [
                          if (tags.isNotEmpty)
                            SingleChildScrollView(
                              controller: sc,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: tags.map((String tag) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      color: Colors.blue.withOpacity(0.3)),
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          tag,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {
                                          print("$tag selected");
                                        },
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 14.0,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                            ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: tec,
                            focusNode: textFieldFocusNode,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: 'Enter tag...',
                            ),
                            onChanged: onChanged,
                            onSubmitted: onSubmitted,
                          ),
                        ],
                      );
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final tags = _controller.getTags;
                if (tags == null) {
                  return;
                }
                for (var t in tags) {
                  await RepositoryImpl().addTag(t);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
