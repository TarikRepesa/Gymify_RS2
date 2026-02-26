import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// LOGO
            SizedBox(
              height: 90,
              child: Image.asset(
                'assets/images/gymify_logo.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "GYMIFY",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: gymBlueDark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Dobrodošli!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            /// OBAVIJESTI HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.notifications, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    "OBAVIJESTI (1)",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// OBAVIJEST 1
            _notificationCard(
              date: "15.04.2025",
              text: "Funkcionalni trening planiran za večeras je otkazan.",
              isImportant: true,
            ),

            const SizedBox(height: 14),

            /// OBAVIJEST 2
            _notificationCard(
              date: "28.03.2025",
              text:
                  "Termin pilatesa za sljedeću sedmicu je Uto–Sri–Pet 17:00.",
              isImportant: false,
            ),

            const SizedBox(height: 24),

            /// DRUŠTVO O NAMA
            const Text(
              "Drugo o nama",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            _reviewCard(),

            const SizedBox(height: 30),

            /// FOOTER
            _footer(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _notificationCard({
    required String date,
    required String text,
    required bool isImportant,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isImportant ? Colors.red : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isImportant ? Colors.red : Colors.grey.shade400,
                width: isImportant ? 1.2 : 1,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _reviewCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.person, size: 18),
                SizedBox(width: 6),
                Text(
                  "Simeon Panda",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Jako sam zadovoljan uslugom :)",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _footer() {
    return Column(
      children: const [
        Text(
          "gymifyinfo.com",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 22),
            SizedBox(width: 18),
            Icon(Icons.camera_alt_outlined, size: 22),
            SizedBox(width: 18),
            Icon(Icons.facebook, size: 22),
          ],
        ),
      ],
    );
  }
}