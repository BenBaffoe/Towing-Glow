import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/signup.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(
                "assets/logo.jfif",
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 28.0),
              child: Text(
                "Towing Glow",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
              ),
            ),
            Image.asset(
              "assets/towing-concept-illustration_114360-5474.jpg",
              height: 240,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              " Towing Services ",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black26),
            ),
            const Text(
              " On Demand ",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black26,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                5,
                28.0,
                0,
                0,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        fixedSize: const Size(345, 66),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(22),
                          ),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 90, 228, 168),
                      ),
                      child: const Text(
                        "Find A Service",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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
