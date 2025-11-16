import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'icon': FontAwesomeIcons.trash,
        'title': 'Jangan Buang Sampah Sembarangan',
        'desc': 'Sampah yang menyumbat saluran air adalah penyebab utama banjir di perkotaan.',
      },
      {
        'icon': FontAwesomeIcons.water,
        'title': 'Bersihkan Selokan Secara Rutin',
        'desc': 'Pastikan air hujan dapat mengalir lancar tanpa hambatan di drainase sekitar rumah.',
      },
      {
        'icon': FontAwesomeIcons.tree,
        'title': 'Tanam Pohon di Sekitar Rumah',
        'desc': 'Pohon membantu menyerap air hujan dan mencegah genangan berlebih.',
      },
      {
        'icon': FontAwesomeIcons.phone,
        'title': 'Laporkan Genangan Air',
        'desc': 'Jika menemukan genangan atau penyumbatan, segera laporkan ke pihak berwenang.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edukasi Banjir',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    tip['icon'] as IconData,
                    color: Colors.blue.shade700,
                    size: 22,
                  ),
                ),
                title: Text(
                  tip['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    tip['desc'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
