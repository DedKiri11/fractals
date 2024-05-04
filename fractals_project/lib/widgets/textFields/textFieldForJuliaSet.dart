import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldForJuliaSet extends StatefulWidget {
  const TextFieldForJuliaSet({super.key, required this.onTextChanged});

  final Function(String, String, String) onTextChanged;

  @override
  State<TextFieldForJuliaSet> createState() => _TextFieldForJuliaSetState();
}

class _TextFieldForJuliaSetState extends State<TextFieldForJuliaSet> {
  final String hintImaginary = "Imaginary part...";
  final String hintReal = "Real part...";
  final String hintIterations = "Iterations...";

  final TextEditingController _controllerForImaginaryPart =
      TextEditingController();
  final TextEditingController _controllerForRealPart = TextEditingController();
  final TextEditingController _controllerForIterations = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerForImaginaryPart,
                decoration: InputDecoration(
                  hintText: hintImaginary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerForRealPart,
                decoration: InputDecoration(
                  hintText: hintReal,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controllerForIterations,
                decoration: InputDecoration(
                  hintText: hintIterations,
                ),
              ),
            ),
          ),
          Expanded(
              child: FilledButton(
                onPressed: () {
                  widget.onTextChanged(
                      _controllerForImaginaryPart.text, _controllerForRealPart.text, _controllerForIterations.text);
                },
                child: Text("Generate"),
          ))
        ],
      ),
    );
  }


  @override
  void dispose() {
    _controllerForImaginaryPart.dispose();
    _controllerForRealPart.dispose();
    super.dispose();
  }
}
