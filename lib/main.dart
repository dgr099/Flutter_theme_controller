import 'package:flutter/material.dart';
import 'package:tfg_app/utils/themes.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _themeManager.removeListener(themeListener);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeManager.addListener(themeListener);
  }

  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _themeManager.themeData, // Provide light theme.
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //bool isDark = Theme.of(context).brightness ==
    //    Brightness.dark; //esto es para saber si está modo oscuro o no
    bool isDark = _themeManager.isDark;
    return Scaffold(
        appBar: AppBar(
          title: Text(isDark ? "Dark Mode" : "Light Mode"),
          actions: const [],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          //Que ocupe todo el ancho que pueda
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text("prueba de texto"),
            const SizedBox(
              height: 24,
            ),
            IconButton(
                icon: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
                onPressed: () {
                  print("change type");
                  _themeManager.changeType(); //cambiamos de oscuro a claro
                  isDark = !isDark; //cambiamos el modo en que nos encontramos
                }),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      _themeManager.changeColor(Colors.red.value);
                    },
                    child: const Text("Rojo")),
                OutlinedButton(
                    autofocus: true,
                    onPressed: () {
                      _themeManager.changeColor(Colors.blue.value);
                    },
                    child: const Text("Azul")),
                OutlinedButton(
                    onPressed: () {
                      _themeManager.changeColor(Colors.green.value);
                    },
                    child: const Text("Verde")),
                OutlinedButton(
                    onPressed: () {
                      _themeManager.changeColor(Color(0xFF643B7D).value);
                    },
                    child: const Text("Violeta")),
              ],
            )
          ]),
        ));
  }
}
