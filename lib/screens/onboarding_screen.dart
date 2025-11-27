import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import 'home_screen.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/banners/onboarding.png",
      "title": "Selamat datang di SushiOrder",
      "subtitle": "Nikmati promo terbaik dan pesan sushi favoritmu dengan mudah"
    },
    {
      "image": "assets/images/banners/onboarding2.png",
      "title": "Promo Setiap Hari 🎉",
      "subtitle": "Dapatkan diskon dan penawaran eksklusif hanya untuk kamu"
    },
    {
      "image": "assets/images/banners/onboarding3.png",
      "title": "Pesan Cepat & Praktis 🍣",
      "subtitle": "Pilih menu favoritmu dan checkout dalam hitungan detik"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          pages[index]["image"]!,
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          pages[index]["title"]!,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// ✅ Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.black
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ✅ Button Section
              Column(
                children: [
                  AppButton(
                    text: currentIndex == pages.length - 1 ? "Mulai" : "Lanjut",
                    onPressed: () {
                      if (currentIndex == pages.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    ),
                    child: const Text('Sudah punya akun? Masuk'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
