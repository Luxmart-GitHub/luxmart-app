import 'package:flutter/material.dart';
import 'package:luxmart/setup_form.dart';
import 'package:http/http.dart' as http;

class Setup extends StatefulWidget {

  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {

  bool _loading = true;
  bool _unreachable = false;

  void reachEsp() async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1')).timeout(const Duration(seconds: 10));
      print(response);
      if(response.statusCode != 200) {
        setState(() { _unreachable = true; });
      } else {
        setState(() { _unreachable = false; });
      }
    } catch (e) {
      print(e);
      setState(() {
        _unreachable = true;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }    
  }

  

  @override
  void initState() {
    reachEsp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('ESP')
      ),
      body: _loading ? const Center(child: Text('Loading...')) : (_unreachable ? UnreachableError(onPressed: reachEsp) : const SetupForm()),
    );
  }
}

class UnreachableError extends StatelessWidget {
  final VoidCallback onPressed;

  const UnreachableError({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('ESP UNREACHABLE'),
          ElevatedButton(
            onPressed: onPressed, 
            child: const Text('Try Again')
          )
        ],
      ),
    );
  }

}