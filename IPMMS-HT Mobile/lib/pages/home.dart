import 'package:flutter/material.dart';
import 'dart:async';
import 'partials/sidebar.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  int _currentSlide = 0;
  final List<String> _slideshowImages = [
    'assets/images/article1.jpeg',
    'assets/images/article2.jpeg',
    'assets/images/article3.jpeg',
  ];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.offset;
      });
    });

    _pageController = PageController(initialPage: 0);
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentSlide = (_currentSlide + 1) % _slideshowImages.length;
        });
        _pageController.animateToPage(
          _currentSlide,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.home_work_outlined,
              color: Colors.black,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'About') {
                showAboutDialog(
                  context: context,
                  applicationName: 'Aplikasi Organisasi',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(Icons.info_outline),
                  children: [
                    Text(
                        'Aplikasi ini dibuat untuk mengelola data anggota organisasi.'),
                  ],
                );
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'About',
                  child: Text('Tentang Aplikasi'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[200]!, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/Logo1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'IPMMS-HT',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Organisasi Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) adalah organisasi kekeluargaan dan wadah pembelajaran untuk mendukung Studi Mahasiswa Maba Sangaji yang terhimpun di Kota Ternate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSlideshow(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top:
                                    16), // Menghapus margin kiri dengan tidak mendefinisikan left
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Artikel Lainnya',
                              style: theme.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._buildMemberActivities(context, theme),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '© 2024 IPMMS-HT. Semua Hak Dilindungi.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Kontak: info@organisasi.com',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildOverlayFocus(),
        ],
      ),
      drawer: Sidebar(),
    );
  }

  Widget _buildSlideshow() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSlide = index;
                });
              },
              itemCount: _slideshowImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    _slideshowImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slideshowImages.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentSlide == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index
                      ? Colors.blueAccent
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMemberActivities(BuildContext context, ThemeData theme) {
    final activities = [
      {
        'image': 'assets/images/article1.jpeg',
        'title': 'Musyawarah Besar Ke-V IPMMS-HT',
        'description':
            'Berita terbaru tentang musyawarrah besar ke-V yang dilakukan oleh anggota organisasi di sekretariat IPMMS-HT',
        'detail': 'Sekretariat IPMMS-HT Ternate, 10 Juli 2024 - Sekretariat Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) menjadi saksi perhelatan penting yang berlangsung dalam suasana penuh semangat dan kebersamaan. Dengan mengusung tema "Reaktualisasi Organisasi; Membangun Solidaritas Wujudkan Kepemimpinan IPMMS-HT yang Progresif dan Berintegritas", Musyawarah Besar Ke-V menjadi momentum strategis untuk menentukan arah gerak organisasi di masa depan.\n '
            'Musyawarah Besar (Mubes) Ke-V IPMMS-HT ini dihadiri oleh seluruh anggota aktif, pengurus, serta beberapa tokoh alumni yang turut memberikan masukan berharga. Acara dimulai dengan sambutan Ketua Panitia, yang menekankan pentingnya Mubes sebagai ruang evaluasi dan konsolidasi.\n'
            'Ketua Umum IPMMS-HT periode sebelumnya dalam pidato pembukaannya menyampaikan, “Reaktualisasi organisasi bukan hanya sekadar jargon, tetapi sebuah langkah konkret untuk menyesuaikan visi dan misi IPMMS-HT dengan tantangan zaman. Solidaritas adalah kunci keberhasilan kita untuk tetap relevan dan berkontribusi bagi masyarakat.”\n'
            'Setelah melalui serangkaian pembahasan intensif, Mubes Ke-V berhasil menghasilkan beberapa keputusan penting:\n'
            '1. Ketua Umum Terpilih: Saudara Abdullah Muhammad terpilih sebagai Ketua Umum baru dengan perolehan suara mayoritas. Dalam pidato kemenangannya, ia menyatakan komitmennya untuk membawa IPMMS-HT ke arah yang lebih progresif dan inklusif.\n'
            '2. Revisi AD/ART: Beberapa pasal dalam AD/ART disesuaikan untuk memberikan fleksibilitas dalam menjalankan program kerja.\n'
            'Musyawarah Besar Ke-V IPMMS-HT tidak hanya menjadi forum evaluasi, tetapi juga momentum untuk memperkuat solidaritas dan merumuskan strategi masa depan. Dengan semangat reaktualisasi organisasi, diharapkan IPMMS-HT mampu menghadirkan kepemimpinan yang progresif, berintegritas, dan memberikan dampak positif bagi anggotanya serta masyarakat luas.\n'
            'Segenap anggota IPMMS-HT kini siap melangkah ke babak baru dengan tekad yang lebih kuat untuk mencapai visi bersama.\n'
            '\nPenulis: Tim Humas IPMMS-HT'
      },
      {
        'image': 'assets/images/article2.jpeg',
        'title': 'Dialog Publik',
        'description': 'Membangun Perspektif Baru di Benteng Orange Ternate',
        'detail': 'Benteng Orange Ternate, 10 November 2024 - Dalam suasana yang penuh antusiasme, Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) sukses menyelenggarakan Dialog Publik bertempat di Benteng Orange, Ternate. Acara ini mengangkat tema "Perspektif Kritis Generasi Muda dalam Membangun Masa Depan Halmahera Timur", yang bertujuan memfasilitasi diskusi terbuka dan membangun kesadaran kolektif tentang tantangan dan potensi daerah.\n'
            'Para peserta, yang sebagian besar adalah mahasiswa, turut aktif mengajukan pertanyaan dan menyampaikan pandangan mereka. Salah satu peserta, Siti Aminah, menyampaikan kekhawatirannya tentang minimnya perhatian terhadap infrastruktur pendidikan di daerah.\n'
            '“Kami berharap ada kebijakan yang lebih memprioritaskan pembangunan sekolah dan fasilitas pendidikan di wilayah Halmahera Timur,” katanya, yang langsung direspons oleh narasumber dengan diskusi yang mendalam.\n'
            'Dialog Publik IPMMS-HT di Benteng Orange Ternate bukan hanya sekadar forum diskusi, tetapi juga momentum penting untuk merumuskan langkah konkret dalam membangun Halmahera Timur. Ketua IPMMS-HT, Ahmad Fauzi, dalam pidato penutupnya menyampaikan, “Kami berharap dialog ini menjadi awal dari perubahan nyata yang dipelopori oleh generasi muda. Mari kita wujudkan masa depan Halmahera Timur yang lebih cerah dan berdaya saing.”\n'
            'Acara ini ditutup dengan foto bersama dan deklarasi komitmen untuk terus berkontribusi bagi pembangunan daerah. Semangat kolaborasi dan kepedulian yang terpancar dari acara ini menjadi bukti bahwa generasi muda Halmahera Timur siap menghadapi tantangan masa depan.\n'
            '\nPenulis: Tim Humas IPMMS-HT'
      },
      {
        'image': 'assets/images/article3.jpeg',
        'title': 'Latihan Dasar Kepemimpinan',
        'description': 'Membina karakter generasi IPMMS-HT yang berintelektual',
        'detail': 'Pantai Tobololo Ternate, 21 September 2024 - Dalam upaya membentuk karakter generasi muda yang intelektual dan berjiwa kepemimpinan, Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) sukses menyelenggarakan kegiatan Latihan Dasar Kepemimpinan (LDK) di Pantai Tobololo, Ternate. Kegiatan ini dirancang sebagai langkah strategis untuk mempersiapkan kader-kader yang mampu menjadi pemimpin visioner bagi masa depan organisasi dan daerah.\n'
            'Ketua panitia, Abdullah Muhammad, dalam sambutannya menyatakan, “Kegiatan ini bukan sekadar pelatihan, tetapi proses membangun pondasi kepemimpinan yang kokoh bagi generasi muda IPMMS-HT. Kami ingin menciptakan pemimpin yang tidak hanya cerdas, tetapi juga berakhlak mulia.”\n'
            'Peserta yang hadir, terdiri dari pelajar dan mahasiswa anggota IPMMS-HT, menunjukkan antusiasme tinggi sepanjang kegiatan. Salah satu peserta, Ahmad Rizki, mengungkapkan kesannya, “LDK ini memberikan saya banyak pelajaran berharga tentang bagaimana menjadi pemimpin yang baik. Saya merasa lebih percaya diri dan siap untuk berkontribusi lebih banyak bagi organisasi.”\n'
            'Kegiatan ini berhasil membangun semangat dan optimisme di kalangan peserta. Dari hasil evaluasi, terlihat peningkatan pemahaman peserta tentang konsep kepemimpinan dan penguatan karakter mereka sebagai calon pemimpin. Ketua IPMMS-HT, Abdullah Muhammad, dalam pidato penutupnya menyampaikan, “Kami percaya bahwa masa depan organisasi dan Halmahera Timur ada di tangan kalian. Jadilah pemimpin yang tidak hanya mementingkan diri sendiri, tetapi juga mampu memberikan manfaat bagi masyarakat.”\n'
            'Latihan Dasar Kepemimpinan ini menjadi langkah awal yang penting bagi IPMMS-HT dalam mencetak pemimpin-pemimpin masa depan yang intelektual dan berintegritas. Dengan semangat yang terbangun dari Pantai Tobololo, generasi muda IPMMS-HT siap menghadapi tantangan dan membawa perubahan positif untuk daerah mereka.\n'
            '\nPenulis: Tim Humas IPMMS-HT'
      },
      {
        'image': 'assets/images/article4.jpeg',
        'title': 'Upgrading Kepengurusan',
        'description':
            'Meningkatkan Kompetensi untuk Kepemimpinan yang Lebih Baik',
        'detail': 'Sekretariat IPMMS-HT Ternate, 05 September 2024 - Dalam upaya memperkuat struktur organisasi dan meningkatkan kapasitas kepemimpinan, Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) menggelar kegiatan Upgrading Kepengurusan. Acara ini berlangsung di Sekretariat IPMMS-HT dengan penuh antusiasme dari seluruh jajaran pengurus baru maupun yang sedang menjabat.\n'
            'Ketua Umum IPMMS-HT, Abdullah Muhammad, menyampaikan dalam pidato pembukaannya, “Upgrading kepengurusan ini bukan hanya tentang meningkatkan kemampuan teknis, tetapi juga membangun semangat kebersamaan dan tanggung jawab untuk mencapai visi organisasi yang lebih besar.”\n'
            'Para pengurus baru dan lama menunjukkan semangat yang luar biasa dalam mengikuti setiap sesi. Salah satu peserta, Nurul Fadillah, mengatakan, “Kegiatan ini sangat bermanfaat karena kami tidak hanya belajar secara teori, tetapi juga mempraktikkan langsung apa yang diajarkan. Saya merasa lebih siap menjalankan amanah ini.”\n'
            'Upgrading Kepengurusan IPMMS-HT ini menjadi langkah penting dalam memperkuat fondasi organisasi. Dengan semangat baru dan keterampilan yang telah diasah, para pengurus diharapkan mampu membawa IPMMS-HT ke tingkat yang lebih tinggi, tidak hanya sebagai organisasi mahasiswa, tetapi juga sebagai agen perubahan di Halmahera Timur.\n'
            '\nPenulis: Tim Humas IPMMS-HT'
      },
      {
        'image': 'assets/images/article5.jpeg',
        'title': 'Pelantikan dan Rapat Kerja',
        'description': 'Langkah Awal Menuju Program Kerja yang Inovatif',
        'detail': 'Kantor Desa Maba Sangaji, 04 Agustus 2024 - Ikatan Pelajar Mahasiswa Maba Sangaji Halmahera Timur (IPMMS-HT) menggelar acara Pelantikan dan Rapat Kerja untuk kepengurusan baru periode 2024-2025 di Kantor Desa Maba Sangaji. Kegiatan ini menjadi momen penting untuk memperkenalkan struktur kepengurusan baru sekaligus merancang program kerja strategis guna mewujudkan visi organisasi.\n'
            'Acara dimulai dengan prosesi pelantikan yang berlangsung khidmat. Ketua IPMMS-HT terpilih, Risdi, bersama jajaran pengurus resmi dilantik oleh perwakilan tokoh masyarakat setempat. Dalam sambutannya, Risdi menekankan pentingnya kolaborasi dan dedikasi dalam menjalankan amanah.\n'
            'Acara Pelantikan dan Rapat Kerja IPMMS-HT ini menjadi tonggak awal yang penting bagi kepengurusan baru untuk melangkah dengan semangat baru. Dengan program kerja yang telah dirancang, IPMMS-HT diharapkan dapat terus memberikan kontribusi nyata bagi pengembangan sumber daya manusia dan kemajuan Halmahera Timur.\n'
            'Ketua panitia, Rudi Hartono, menutup acara dengan penuh optimisme, “Kita semua memiliki tanggung jawab bersama untuk mewujudkan visi IPMMS-HT. Mari bekerja dengan semangat dan kebersamaan.”\n'
            '\nPenulis: Tim Humas IPMMS-HT'
      },
    ];

    return activities.asMap().entries.map((entry) {
      final index = entry.key;
      final activity = entry.value;

      final isFocused = (_scrollPosition >= index * 320.0 &&
          _scrollPosition < (index + 1) * 320.0);

      return Opacity(
        opacity: isFocused ? 1.0 : 0.5,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  title: activity['title']!,
                  image: activity['image']!,
                  detail: activity['detail']!,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: isFocused ? 8 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      activity['image']!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title']!,
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight:
                                isFocused ? FontWeight.bold : FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          activity['description']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildOverlayFocus() {
    final screenHeight = MediaQuery.of(context).size.height;

    return IgnorePointer(
      child: Positioned.fill(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight / 2 - 100,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
