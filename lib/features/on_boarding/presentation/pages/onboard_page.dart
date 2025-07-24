import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gearpizza/features/on_boarding/models/OnBoard.dart';
import 'package:go_router/go_router.dart';

class AppOnBoardPage extends StatefulWidget {
  const AppOnBoardPage({super.key});

  @override
  State<AppOnBoardPage> createState() => _AppOnBoardPageState();
}

class _AppOnBoardPageState extends State<AppOnBoardPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: onboards.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // for image
                    Positioned(
                      top: index == 0 ? 70 : -70,
                      left: 0,
                      right: 0,
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 500),
                        child: Image.asset(
                          onboards[index].image,
                          width: index == 0 ? 300 : 600,
                          height: index == 0 ? 300 : 600,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2.3,
                      child: FadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                onboards[index].text1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                onboards[index].text2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 200,
              left: 25,
              child: FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    ...List.generate(
                      onboards.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 5,
                        width: 50,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.black
                              : Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: SizedBox(
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MaterialButton(
                      onPressed: () {
                        context.go("/restaurants");
                      },
                      color: Color(0xfff95f60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minWidth: MediaQuery.of(context).size.width - 50,
                      child: const Center(
                        child: Text(
                          "Inizia ora",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
