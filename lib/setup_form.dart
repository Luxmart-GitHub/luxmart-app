import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetupForm extends StatefulWidget {
  const SetupForm({super.key});

  @override
  State<SetupForm> createState() => _SetupFormState();
}

class WifiData {
  final String ssid;
  final String password;
  final String ip;
  final String gateway;

  const WifiData({
    required this.ssid, 
    required this.password, 
    required this.ip, 
    required this.gateway
  });
}

class _SetupFormState extends State<SetupForm> {

  final _formKey = GlobalKey<FormState>();
  final _ssidFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _ipFieldControler = TextEditingController();
  final _gatewayFieldControler = TextEditingController();

  void submitForm (WifiData data) async {
    await http.post(
      Uri.parse('http://192.168.4.1'),
      headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'ssid': data.ssid,
        'pass': data.password,
        'ip': data.ip,
        'gateway': data.gateway
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _ssidFieldController,
              decoration: const InputDecoration(
                hintText: 'Wifi SSID'
              ),
            ),
            TextFormField(
              controller: _passwordFieldController,
              decoration: const InputDecoration(
                hintText: 'Wifi Password'
              )
            ),
            TextFormField(
              controller: _ipFieldControler,
              decoration: const InputDecoration(
                hintText: 'IP Address'
              ),
            ),
            TextFormField(
              controller: _gatewayFieldControler,
              decoration: const InputDecoration(
                hintText: 'Gateway Address'
              ),
            ),
            ElevatedButton(
              onPressed: () {
                submitForm(WifiData(
                  ssid: _ssidFieldController.text, 
                  password: _passwordFieldController.text, 
                  ip: _ipFieldControler.text, 
                  gateway: _gatewayFieldControler.text
                ));
                _ssidFieldController.text = "";
                _passwordFieldController.text = "";
                _ipFieldControler.text = "";
                _gatewayFieldControler.text = "";
              }, 
              child: const Text('Submit')
            )
          ],
        ),
      ),
    );
  }
}