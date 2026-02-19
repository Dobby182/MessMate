import 'package:flutter/material.dart';
import 'food_screen.dart';


void main() {
  runApp(MessMateApp());
}

class MessMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessMate',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController rollController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.green[100],

      appBar: AppBar(
        title: Text("MessMate Login"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Center(

        child: Padding(

          padding: EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                Icons.restaurant,
                size: 100,
                color: Colors.green,
              ),

              SizedBox(height: 20),

              Text(
                "Welcome to MessMate",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              TextField(
                controller: rollController,
                decoration: InputDecoration(
                  labelText: "Roll Number",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodScreen(),
                    ),
                  );

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),

                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18),
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
