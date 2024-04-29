import 'package:flutter/material.dart'; // Mengimpor package flutter untuk UI
import 'package:http/http.dart' as http; // Mengimpor package http dari Dart untuk melakukan HTTP request
import 'dart:convert'; // Mengimpor package dart:convert untuk mengonversi JSON

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter
}

// Menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Variabel untuk menampung aktivitas
  String jenis; // Variabel untuk menampung jenis aktivitas

  Activity({required this.aktivitas, required this.jenis}); // Constructor kelas Activity

  // Map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengambil aktivitas dari JSON
      jenis: json['type'], // Mengambil jenis aktivitas dari JSON
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat state baru untuk aplikasi
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Menampung hasil pemanggilan API

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity"; // URL untuk melakukan request API

  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Inisialisasi data awal
  }

  // Mengambil data dari API
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Melakukan GET request ke API
    if (response.statusCode == 200) {
      // Jika server mengembalikan status 200 OK
      // Parse JSON
      return Activity.fromJson(jsonDecode(response.body)); // Mendekode JSON dan membuat objek Activity
    } else {
      // Jika server mengembalikan status selain 200 OK
      // Lemparkan exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Inisialisasi futureActivity
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Mengambil data baru ketika tombol ditekan
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Membangun UI berdasarkan futureActivity
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika sudah mendapatkan data
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Menampilkan aktivitas
                      Text("Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error
                return Text('${snapshot.error}'); // Menampilkan pesan error
              }
              // Default: loading spinner.
              return const CircularProgressIndicator(); // Menampilkan spinner saat data sedang dimuat
            },
          ),
        ]),
      ),
    ));
  }
}
