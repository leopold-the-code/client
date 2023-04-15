import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textfield_tags/textfield_tags.dart';

class Tag {
  final String name;
  bool isSelected;

  Tag({
    required this.name,
    this.isSelected = false,
  });
}

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  final TextfieldTagsController _controller = TextfieldTagsController();
  final textFieldFocusNode = FocusNode();

  List<Tag> tags = [
    Tag(name: "boardgames"),
    Tag(name: "art"),
    Tag(name: "gaming"),
    Tag(name: "hiking"),
    Tag(name: "photography"),
    Tag(name: "travel"),
    Tag(name: "cooking"),
    Tag(name: "movies"),
    Tag(name: "books"),
    Tag(name: "politics"),
    Tag(name: "pets"),
  ];

  static List<Color> lightColors = [
    const Color.fromRGBO(255, 221, 221, 1.0), // Light pink
    const Color.fromRGBO(255, 244, 221, 1.0), // Pale yellow
    const Color.fromRGBO(221, 255, 237, 1.0), // Pale green
    const Color.fromRGBO(221, 236, 255, 1.0), // Pale blue
    const Color.fromRGBO(249, 221, 255, 1.0), // Lavender
    const Color.fromRGBO(255, 221, 234, 1.0), // Pale pink
    const Color.fromRGBO(255, 241, 221, 1.0), // Beige
    const Color.fromRGBO(221, 255, 247, 1.0), // Aqua
    const Color.fromRGBO(238, 221, 255, 1.0), // Lilac
    const Color.fromRGBO(221, 255, 221, 1.0), // Pale green
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validToSubmit() {
    return true;
  }

  int _choosenTags() {
    int cnt = 0;
    for (Tag t in tags) {
      if (t.isSelected) {
        cnt++;
      }
    }
    return cnt;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          child: SvgPicture.asset(
            'assets/back_btn.svg',
            fit: BoxFit.scaleDown,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Text(
                'Enter your fields of interest',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'or choose at least 2 tags',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  return TextFieldTags(
                    textfieldTagsController: _controller,
                    initialTags: const [],
                    textSeparators: const [' ', ','],
                    letterCase: LetterCase.small,
                    inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                      return ((context, sc, tagValues, onTagDelete) {
                        return Column(
                          children: [
                            if (tagValues.isNotEmpty)
                              SingleChildScrollView(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: tagValues.map((String tag) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: FilterChip(
                                      avatar: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      label: Text(tag, style: const TextStyle(color: Colors.white)),
                                      showCheckmark: false,
                                      selected: true,
                                      selectedColor: const Color(0xFF1976D2),
                                      onSelected: (isSelected) {
                                        onTagDelete(tag);
                                      },
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
                                hintText: 'Enter your tag',
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _submitTag,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _validToSubmit() ? const Color(0xFF1976D2) : null,
                    border: !_validToSubmit() ? Border.all(color: const Color(0xFF1976D2)) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: _validToSubmit() ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Stack(
                children: [
                  Container(
                    width: width,
                    height: width,
                    color: Colors.transparent,
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: _tag(0),
                  ),
                  Positioned(
                    left: 120,
                    top: 80,
                    child: _tag(1),
                  ),
                  Positioned(
                    left: 200,
                    top: 10,
                    child: _tag(2),
                  ),
                  Positioned(
                    left: 190,
                    top: 150,
                    child: _tag(3),
                  ),
                  Positioned(
                    left: 50,
                    top: 200,
                    child: _tag(4),
                  ),
                  Positioned(
                    left: 210,
                    top: 220,
                    child: _tag(5),
                  ),
                  Positioned(
                    left: 100,
                    top: 270,
                    child: _tag(6),
                  ),
                  Positioned(
                    left: 220,
                    top: 80,
                    child: _tag(7),
                  ),
                  Positioned(
                    left: 40,
                    top: 120,
                    child: _tag(8),
                  ),
                  Positioned(
                    left: 250,
                    top: 300,
                    child: _tag(9),
                  ),
                  Positioned(
                    left: 20,
                    top: 320,
                    child: _tag(10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(int index) {
    return FilterChip(
      avatar: tags[index].isSelected
          ? const Icon(
              Icons.close,
              color: Colors.white,
            )
          : null,
      label: Text(tags[index].name,
          style: TextStyle(color: tags[index].isSelected ? Colors.white : null)),
      showCheckmark: false,
      selected: tags[index].isSelected,
      backgroundColor: lightColors[index % 10],
      selectedColor: const Color(0xFF1976D2),
      onSelected: (isSelected) {
        setState(() {
          tags[index].isSelected = isSelected;
        });
      },
    );
  }

  Future _submitTag() async {
    if (!_controller.hasTags && _choosenTags() == 0) {
      return;
    }
    final textFieldTags = _controller.getTags ?? [];

    for (Tag t in tags) {
      if (t.isSelected) {
        textFieldTags.add(t.name);
      }
    }
    for (var t in textFieldTags) {
      await RepositoryImpl().addTag(t);
    }
    Navigator.of(context).pop();
  }
}
