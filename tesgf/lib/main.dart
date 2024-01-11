import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double result = 0;

  TextEditingController number1 =  TextEditingController();
  TextEditingController number2 =  TextEditingController();

  void _calculate_p(){
    setState(() {
      result = double.parse(number1.text)+ double.parse(number2.text);
    });
  }
  void _calculate_(){
    setState(() {
      if (result%2 != 0 || result%3 != 0 || result%5 != 0 || result%7 != 0 || result%11 != 0 ){
        
      }
    });
  }
  void _calculate_m(){
    setState(() {
      result = double.parse(number1.text)- double.parse(number2.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'กรุณาใส่เลขที่ต้องการ',
            ), Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[
              TextField(
                controller : number1,
              decoration: InputDecoration(
                hintText: "ตัวที่ 1"
              ),
            ),
            TextField(
              controller : number2,
              decoration: InputDecoration(
                hintText: "ตัวที่ 2"
              ),
            ),
            ]),
            
            Text(
              '$result',
              style: Theme.of(context).textTheme.headlineMedium,
            )

            ,Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
            FloatingActionButton(onPressed:_calculate_p
            ,child: const Text("บวก"),),

            
            FloatingActionButton(onPressed:_calculate_m
            ,child: const Text("ลบ"),)])
            
          ],
        ),
      ),
    );
    
  }
}