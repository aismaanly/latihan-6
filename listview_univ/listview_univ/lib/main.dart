import 'package:flutter/material.dart'; // Mengimpor package flutter/material untuk membuat UI
import 'package:http/http.dart' as http; // Mengimpor package http dari http untuk mengirim permintaan HTTP
import 'dart:convert'; // Mengimpor package dart:convert untuk mengonversi JSON
import 'package:url_launcher/url_launcher.dart'; // Mengimpor package url_launcher untuk membuka URL

class University {
  String name; // Nama universitas
  String website; // Situs web universitas
  University({required this.name, required this.website}); // Konstruktor Universitas
}

class UniversityList {
  List<University> universities = []; // List untuk menyimpan data universitas

  UniversityList(List<dynamic> json) {
    for (var uni in json) { // Iterasi melalui data JSON
      universities.add(University( // Menambahkan universitas ke dalam list
        name: uni['name'], // Nama universitas
        website: uni['web_pages'][0], // Alamat situs web universitas
      ));
    }
  }
}

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat instance dari MyAppState
  }
}

class MyAppState extends State<MyApp> {
  late Future<UniversityList> futureUniversityList; // Future untuk daftar universitas

  String url = "http://universities.hipolabs.com/search?country=Indonesia"; // URL endpoint untuk data universitas Indonesia

  // Fungsi untuk mengambil data universitas dari API
  Future<UniversityList> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Mengirim permintaan GET ke API

    if (response.statusCode == 200) { // Jika permintaan berhasil
      return UniversityList(jsonDecode(response.body)); // Mengembalikan instance UniversityList dengan data dari response
    } else {
      throw Exception('Failed to load universities'); // Jika gagal, lempar exception
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversityList = fetchData(); // Mengambil data universitas saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universitas', // Judul aplikasi
      home: Scaffold(
        appBar: AppBar(
          title: Text('Universitas di Indonesia'), // Judul appbar
        ),
        body: Center(
          child: FutureBuilder<UniversityList>(
            future: futureUniversityList, // Menggunakan futureUniversityList sebagai sumber data
            builder: (context, snapshot) {
              if (snapshot.hasData) { // Jika data tersedia
                return ListView.builder( // Membangun ListView untuk menampilkan data universitas
                  itemCount: snapshot.data!.universities.length,
                  itemBuilder: (context, index) {
                    return Card( // Menampilkan data universitas dalam bentuk card
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: () {
                          _launchURL(snapshot.data!.universities[index].website); // Ketika card ditekan, buka situs web universitas
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(
                            snapshot.data!.universities[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(snapshot.data!.universities[index].website),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) { // Jika terjadi error saat memuat data
                return Text('${snapshot.error}'); // Tampilkan pesan error
              }
              return CircularProgressIndicator(); // Tampilkan indicator loading jika masih memuat data
            },
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) { // Jika URL dapat diluncurkan
      await launch(url); // Buka URL
    } else {
      throw 'Could not launch $url'; // Jika gagal, lempar exception
    }
  }
}
