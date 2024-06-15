import 'dart:io';


class JokiService {
  String gameName;
  String serviceType;
  double price;

  JokiService(this.gameName, this.serviceType, this.price);
}


class Queue {
  int front;
  int rear;
  int maxQueue;
  List<JokiService?> list;

  Queue(this.maxQueue)
      : front = -1,
        rear = -1,
        list = List<JokiService?>.filled(maxQueue, null, growable: false);


  bool isFull() {
    return (rear + 1) % maxQueue == front;
  }

  bool isEmpty() {
    return front == -1;
  }


  void enqueue(JokiService service) {
    if (isFull()) {
      print('antrian telah penuh, tidak menambahkan layanan.');
      return;
    }
    if (isEmpty()) {
      front = 0;
    }
    rear = (rear + 1) % maxQueue;
    list[rear] = service;
    print('Layanan joki berhasil ditambahkan!');
  }


  JokiService? dequeue() {
    if (isEmpty()) {
      print('antrian kosong, mengembalikan null.');
      return null;
    }
    var service = list[front];
    if (front == rear) {
      front = rear = -1;
    } else {
      front = (front + 1) % maxQueue;
    }
    return service;
  }

  List<JokiService> getServices() {
    if (isEmpty()) {
      return [];
    }
    List<JokiService> services = [];
    int i = front;
    while (true) {
      services.add(list[i]!);
      if (i == rear) break;
      i = (i + 1) % maxQueue;
    }
    return services;
  }
}

class JokiManager {
  Queue queue = Queue(10); // maxQueue sesuai kebutuhan


  void addService(String gameName, String serviceType, double price) {
    queue.enqueue(JokiService(gameName, serviceType, price));
  }

  void listServices() {
    var services = queue.getServices();
    if (services.isEmpty) {
      print('Tidak ada layanan joki yang tersedia');
    } else {
      print('Daftar Layanan Joki:');
      for (var i = 0; i < services.length; i++) {
        print(
            '${i + 1}. Game: ${services[i].gameName}, Tipe Layanan: ${services[i].serviceType}, Harga: \$${services[i].price}');
      }
    }
  }

  void removeService() {
    var removedService = queue.dequeue();
    if (removedService != null) {
      print(
          'Layanan joki untuk game ${removedService.gameName} berhasil dihapus');
    }
  }

  void searchService(String gameName) {
    var services = queue.getServices();
    services.sort((a, b) => a.gameName.compareTo(b.gameName));
    int index = binarySearch(services, gameName);
    if (index != -1) {
      var service = services[index];
      print(
          'Layanan ditemukan: Game: ${service.gameName}, Tipe Layanan: ${service.serviceType}, Harga: \$${service.price}');
    } else {
      print('Layanan untuk game $gameName tidak ditemukan');
    }
  }
  int binarySearch(List<JokiService> services, String gameName) {
    int left = 0;
    int right = services.length - 1;

    while (left <= right) {
      int middle = left + (right - left) ~/ 2;
      int comparison = services[middle].gameName.compareTo(gameName);

      if (comparison == 0) {
        return middle;
      } else if (comparison < 0) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }
    return -1; // not found
  }
}

void main() {
  var manager = JokiManager();
  bool running = true;

  while (running) {
    print('\nMenu:');
    print('1. Tambah Layanan Joki');
    print('2. Lihat Layanan Joki');
    print('3. Hapus Layanan Joki');
    print('4. Cari Layanan Joki');
    print('5. Keluar');
    stdout.write('Pilih opsi: ');
    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        stdout.write('Nama Game: ');
        var gameName = stdin.readLineSync() ?? '';
        stdout.write('Tipe Layanan: ');
        var serviceType = stdin.readLineSync() ?? '';
        stdout.write('Harga: \$');
        var price = double.tryParse(stdin.readLineSync() ?? '');
        if (price != null) {
          manager.addService(gameName, serviceType, price);
        } else {
          print('Harga tidak valid');
        }
        break;
      case 2:
        manager.listServices();
        break;
      case 3:
        manager.removeService();
        break;
      case 4:
        stdout.write('Nama Game yang dicari: ');
        var gameName = stdin.readLineSync() ?? '';
        manager.searchService(gameName);
        break;
      case 5:
        running = false;
        print('Terima kasih telah menggunakan sistem manajemen joki game!');
        break;
      default:
        print('Opsi tidak valid');
        break;
}
}
}
