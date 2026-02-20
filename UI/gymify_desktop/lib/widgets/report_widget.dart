import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget ReportWidget() {
  final topTrainers = [
    {"name": "Simeon Panda", "count": 120},
    {"name": "David Laid", "count": 90},
    {"name": "Phil Heath", "count": 70},
    {"name": "John Doe", "count": 40},
  ];

  final membershipsYear = [
    {"name": "Gold", "count": 160},
    {"name": "Silver", "count": 95},
    {"name": "Basic", "count": 60},
    {"name": "Student", "count": 35},
  ];

  final totalTrainerVisits = topTrainers.fold<double>(
    0,
    (sum, e) => sum + (e["count"] as int).toDouble(),
  );

  final totalMemberships =
      membershipsYear.fold<int>(0, (s, e) => s + (e["count"] as int));

  final winner = membershipsYear.reduce(
    (a, b) => (a["count"] as int) >= (b["count"] as int) ? a : b,
  );

  final winnerName = winner["name"].toString();
  final winnerCount = winner["count"] as int;
  final winnerPercent =
      totalMemberships == 0 ? 0 : (winnerCount / totalMemberships) * 100;

  final palette = [
    const Color(0xFF3B82F6),
    const Color(0xFF22C55E),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    child: Column(
      children: [
        const Text(
          "Izvjestaji",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
        
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
        
                /// ================= PIE CHART =================
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Najposjećeniji treneri (godina)",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 40,
                            sections:
                                List.generate(topTrainers.length, (i) {
                              final item = topTrainers[i];
                              final percent = totalTrainerVisits == 0
                                  ? 0
                                  : ((item["count"] as int) /
                                          totalTrainerVisits) *
                                      100;
        
                              return PieChartSectionData(
                                color: palette[i % palette.length],
                                value:
                                    (item["count"] as int).toDouble(),
                                radius: 70,
                                title:
                                    "${percent.toStringAsFixed(1)}%",
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
        
                      /// Legenda
                      Column(
                        children: List.generate(topTrainers.length, (i) {
                          final item = topTrainers[i];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color:
                                      palette[i % palette.length],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                      item["name"].toString()),
                                ),
                                Text(item["count"].toString()),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
        
                /// ================= KPI CARD =================
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Najpopularnija članarina (godina)",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 25),
        
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color:
                                  const Color(0xFF22C55E).withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: Color(0xFF16A34A),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
        
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                winnerName,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Aktivacija: $winnerCount",
                                style: TextStyle(
                                    color: Colors.grey.shade700),
                              ),
                              Text(
                                "Udio: ${winnerPercent.toStringAsFixed(1)}%",
                                style: TextStyle(
                                    color: Colors.grey.shade700),
                              ),
                            ],
                          )
                        ],
                      ),
        
                      const SizedBox(height: 25),
        
                      LinearProgressIndicator(
                        value: winnerPercent / 100,
                        minHeight: 8,
                        backgroundColor:
                            const Color(0xFFEFEFEF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFE8E8E8)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 6),
      )
    ],
  );
}