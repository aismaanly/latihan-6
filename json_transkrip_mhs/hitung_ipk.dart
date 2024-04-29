import 'dart:convert'; //Mengimpor package dart:convert untuk mengonversi JSON
import 'dart:io'; //Mengimpor library dart:io untuk operasi input-output

// Mendefinisikan kelas MataKuliah untuk merepresentasikan mata kuliah
class MataKuliah {
  final String kode; // Kode mata kuliah
  final String nama; // Nama mata kuliah
  final int sks; // Jumlah SKS (Satuan Kredit Semester) mata kuliah
  final String nilai; // Nilai yang diperoleh dalam mata kuliah

  // Konstruktor kelas MataKuliah
  MataKuliah(this.kode, this.nama, this.sks, this.nilai);
}

// Mendefinisikan kelas TranskripMahasiswa untuk merepresentasikan transkrip mahasiswa
class TranskripMahasiswa {
  final String nama; // Nama mahasiswa
  final String npm; // NPM mahasiswa
  final String jurusan; // Jurusan mahasiswa
  final List<MataKuliah> mataKuliah; // Daftar mata kuliah dalam transkrip menggunakan list

  // Konstruktor kelas TranskripMahasiswa
  TranskripMahasiswa(this.nama, this.npm, this.jurusan, this.mataKuliah);
}

// Fungsi untuk menghitung IPK berdasarkan transkrip mahasiswa
double hitungIPK(TranskripMahasiswa transkrip) {
  double totalSks = 0; // Variabel untuk menyimpan total SKS
  double totalNilai = 0; // Variabel untuk menyimpan total nilai

  // Iterasi melalui setiap mata kuliah dalam transkrip
  for (var matkul in transkrip.mataKuliah) {
    totalSks += matkul.sks; // Menambahkan jumlah SKS

    // Switch case untuk menghitung nilai total berdasarkan skor nilai
    switch (matkul.nilai) {
      case "A":
        totalNilai += 4.00 * matkul.sks; // Nilai A
        break;
      case "A-":
        totalNilai += 3.75 * matkul.sks; // Nilai A-
        break;
      case "B+":
        totalNilai += 3.50 * matkul.sks; // Nilai B+
        break;
      case "B":
        totalNilai += 3.00 * matkul.sks; // Nilai B
        break;
      case "B-":
        totalNilai += 2.75 * matkul.sks; // Nilai B-
        break;
      case "C+":
        totalNilai += 2.50 * matkul.sks; // Nilai C+
        break;
      case "C":
        totalNilai += 2.00 * matkul.sks; // Nilai C
        break;
      case "C-":
        totalNilai += 1.75 * matkul.sks; // Nilai C-
        break;
      case "D":
        totalNilai += 1.00 * matkul.sks; // Nilai D
        break;
      case "E":
        totalNilai += 0.00 * matkul.sks; // Nilai E
        break;
    }
  }

  // Hitung nilai IPK
  double ipk = totalNilai / totalSks; // Hitung nilai IPK dengan membagi totalNilai dengan totalSks
  return ipk; // Mengembalikan nilai IPK
}

// Fungsi utama
void main() {
  // Membaca transkrip dari file JSON
  String jsonString = File('transkrip.json').readAsStringSync(); // Membaca isi file JSON
  Map<String, dynamic> jsonData = jsonDecode(jsonString); // Mendekode JSON menjadi Map

  // Objek TranskripMahasiswa dari data JSON
  TranskripMahasiswa transkrip = TranskripMahasiswa(
    jsonData['nama'], // Mengambil nilai nama mahasiswa dari data JSON yang telah di-decode
    jsonData['npm'], // Mengambil nilai npm mahasiswa dari data JSON yang telah di-decode
    jsonData['jurusan'], // Mengambil nilai jurusan mahasiswa dari data JSON yang telah di-decode
    (jsonData['mata_kuliah'] as List).map((item) { // Mendapatkan daftar mata kuliah dari JSON
      return MataKuliah(item['kode'], item['nama'], item['sks'], item['nilai']); // Membuat objek MataKuliah dari data JSON
    }).toList(), // Mengonversi hasil pemetaan ke dalam List
  );

  // Mencetak nama, NPM, dan IPK mahasiswa
  print("Nama Mahasiswa: ${transkrip.nama}"); // Cetak nama mahasiswa
  print("NPM Mahasiswa: ${transkrip.npm}"); // Cetak NPM mahasiswa

  double ipkMahasiswa = hitungIPK(transkrip); // Memanggil fungsi hitungIPK()
  print("IPK mahasiswa: ${ipkMahasiswa.toStringAsFixed(3)}"); // Cetak IPK mahasiswa dengan tiga angka di belakang koma
}
