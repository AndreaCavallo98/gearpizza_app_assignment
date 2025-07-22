import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gearpizza/core/di/injection.dart';
import 'package:gearpizza/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:gearpizza/router/app_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Gear Pizza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 👉 Header NON scrollabile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "La tua posizione",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Via Centallo 121",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: -5,
                        top: -8,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Color(0xfff95f60),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "0",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Trova la migliore pizza per te!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -.4,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 👉 Scrollabile solo la lista delle RestaurantCard
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                itemCount: 4, // o restaurants.length
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RestaurantCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
