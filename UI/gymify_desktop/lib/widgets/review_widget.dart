import 'package:flutter/material.dart';

Widget ReviewWidget() {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Simeon Panda",
      "comment": "Jako sam zadovoljan uslugom :)",
      "stars": 5,
    },
    {
      "name": "David Laid",
      "comment": "Prevelike gužve. Higijena na nivou.",
      "stars": 3,
    },
    {
      "name": "Phil Heath",
      "comment": "Velik izbor sprava i sadržaja.",
      "stars": 4,
    },
  ];

  Widget starRow(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < count ? Icons.star_rounded : Icons.star_border_rounded,
          size: 18,
          color: const Color(0xFFFFC107),
        ),
      ),
    );
  }

  InputDecoration _searchDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
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

  Widget reviewCard(Map<String, dynamic> r) {
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
          const Icon(Icons.person, size: 22, color: Colors.black87),
          const SizedBox(width: 10),

          // ime
          SizedBox(
            width: 150,
            child: Text(
              r["name"] ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F2F2F),
              ),
            ),
          ),

          // divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: 1,
            height: 26,
            color: Colors.black.withOpacity(0.18),
          ),

          // komentar
          const Icon(Icons.chat_bubble_outline_rounded,
              size: 18, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              r["comment"] ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // zvjezdice
          starRow((r["stars"] ?? 0) as int),

          const SizedBox(width: 16),

          // delete
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline_rounded),
              iconSize: 20,
              splashRadius: 18,
              tooltip: "Obriši",
            ),
          ),
        ],
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    child: Column(
      children: [
        Text(
            "Recenzije",
            style: const TextStyle(  
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

        const SizedBox(height: 22),

        // SEARCH ROW
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: _searchDecoration(
                  hint: "Pretraga recenzija po članovima",
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: null,
                decoration: _searchDecoration(
                  hint: "Pretraga po broju zvjezdica",
                ),
                items: const [
                  DropdownMenuItem(value: 5, child: Text("5 zvjezdica")),
                  DropdownMenuItem(value: 4, child: Text("4 zvjezdice")),
                  DropdownMenuItem(value: 3, child: Text("3 zvjezdice")),
                  DropdownMenuItem(value: 2, child: Text("2 zvjezdice")),
                  DropdownMenuItem(value: 1, child: Text("1 zvjezdica")),
                ],
                onChanged: (_) {},
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // LIST
        Expanded(
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, i) => reviewCard(reviews[i]),
          ),
        ),
      ],
    ),
  );
}
