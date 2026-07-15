import 'package:flutter/material.dart';
import 'package:shop_and_drive/components/floating/floating_app_bar.dart';
import 'package:shop_and_drive/components/floating/floating_bottom_bar.dart';
import 'package:shop_and_drive/components/swiper/swiper.dart';
import 'package:shop_and_drive/utils/greetings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    String greeting = getGreetingMessage();
    return Scaffold(
      appBar: FloatingAppBar(
        onFilterPressed: () {
          print("notif ditekan");
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: .start,
                children: [
                  Text(
                    textAlign: .start,
                    '$greeting, ',
                    style: TextStyle(fontSize: 20, fontWeight: .bold),
                  ),
                  Text(
                    textAlign: .start,
                    'Herdiyana',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: .bold,
                      color: const Color.fromARGB(255, 196, 39, 39),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: .only(top: 10),
              decoration: BoxDecoration(
                borderRadius: .circular(20),
                border: .all(
                  color: const Color.fromARGB(255, 221, 172, 159),
                  strokeAlign: 1,
                ),
                color: const Color.fromARGB(137, 240, 183, 165),
              ),
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      minRadius: 30,
                      maxRadius: 30,
                      backgroundColor: const Color.fromARGB(255, 196, 39, 39),
                      child: Icon(
                        Icons.directions_car,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Your Toyota Supra',
                          textAlign: .start,
                          style: TextStyle(fontSize: 16, fontWeight: .w600),
                        ),
                        Text(
                          'Due for service in 10 days',
                          textAlign: .start,
                          style: TextStyle(fontSize: 16, fontWeight: .bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const SumbawaBannerSwiper(),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Menu Utama atau Konten Lainnya..."),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingBottomBar(
        currentIndex: 1,
        notificationCount: 2,
        onTap: (index) {
          print('wll');
        },
      ),
    );
  }
}
