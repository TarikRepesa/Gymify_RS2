import 'package:flutter/material.dart';

Widget NotificationWidget() {
  final List<Map<String, dynamic>> notifications = [
    {
      "date": "15.04.2025",
      "title": "Obavijest",
      "message": "Funkcionalni trening planiran za večeras je otkazan.",
    },
    {
      "date": "28.03.2025",
      "title": "Obavijest",
      "message": "Termini pilatesa za sljedeću sedmicu je Uto-Sri-Pet 17:00.",
    },
    {
      "date": "02.03.2025",
      "title": "Obavijest",
      "message": "Ovaj mjesec pravimo pauzu od kickboxing treninga.",
    },
  ];

  InputDecoration _searchDecoration() {
    return InputDecoration(
      hintText: "Pretraga",
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: const Icon(Icons.search_rounded, size: 18),
      suffixIcon: const Icon(Icons.close_rounded, size: 18),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFF387EFF), width: 1.6),
      ),
    );
  }

  Widget _notificationRow(Map<String, dynamic> n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_none_rounded,
              size: 22, color: Colors.black87),
          const SizedBox(width: 10),

          SizedBox(
            width: 120,
            child: Text(
              (n["title"] ?? "").toString(),
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F2F2F),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: 1,
            height: 26,
            color: Colors.black.withOpacity(0.18),
          ),

          Expanded(
            child: Text(
              (n["message"] ?? "").toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // grupisanje po datumu (kao na slici)
  final Map<String, List<Map<String, dynamic>>> grouped = {};
  for (final n in notifications) {
    final d = (n["date"] ?? "").toString();
    grouped.putIfAbsent(d, () => []);
    grouped[d]!.add(n);
  }
  final dates = grouped.keys.toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    child: Column(
      children: [
        Text(
            "Obavijesti",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        const SizedBox(height: 22),

        // SEARCH + BUTTON ROW
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: _searchDecoration(),
                onChanged: (_) {},
              ),
            ),
            const SizedBox(width: 18),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF387EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                  ),
                child: const Text(
                  "NOVA OBAVIJEST",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // LIST
        Expanded(
          child: ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, i) {
              final date = dates[i];
              final list = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 8, top: 8),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                  ...list.map(_notificationRow).toList(),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
