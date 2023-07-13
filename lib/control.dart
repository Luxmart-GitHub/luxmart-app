import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {

  final _controller = TextEditingController();

  double _currentSliderValue = 0;
  bool _loading = false;

  void handleSubmit() async {
    try {
      setState(() { _loading = true; });
      final response = await http.post(
        Uri.parse('http://${_controller.text}'),
        headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'value': _currentSliderValue.round().toString()
        }
      ).timeout(const Duration(seconds: 4));

      if(response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 247, 44, 64),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: const Text(
                'Request Failed.',
                style: TextStyle(color: Colors.white),
              ),
            )
          ),
        );
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 247, 44, 64),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: const Text(
                'Request Failed. ESP unreachable at specified address',
                style: TextStyle(color: Colors.white),
              ),
            )
          ),
      );
    }
    finally {
      setState(() { _loading = false; });
    }
  }

  void handleReset() async {
    await http.post(
      Uri.parse('http://${_controller.text}/reset')
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ESP')
      ),
      body: Center(
        child: _loading ? const Text('Loading...') : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'ESP IP Address'
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                    value: _currentSliderValue,
                    max: 255,
                    divisions: 255,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    child: const Text('Submit'),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: handleReset,
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.red))
                ),
                child: const Text('Reset ESP'),
              )
            ],
          ),
        ),
      ),
    );
  }
}