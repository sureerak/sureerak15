import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });

        // เรียงลำดับข้อมูลตามราคา จากน้อยไปมาก
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));

        setState(() {
          products = loadedProducts;
        });
        print("จำนวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    // สร้าง TextEditingController สำหรับแต่ละฟิลด์
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController categoryController =
        TextEditingController(text: product['category']);
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController productionDateController =
        TextEditingController(text: product['productionDate']);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวนสินค้า'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: productionDateController,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'category': categoryController.text,
                  'quantity': int.parse(quantityController.text),
                  'price': int.parse(priceController.text),
                  'productionDate': productionDateController.text,
                };

                // อัปเดตข้อมูลใน Firebase
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // โหลดข้อมูลใหม่หลังแก้ไข
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงข้อมูลสินค้า'),
        backgroundColor: const Color.fromARGB(255, 112, 230, 147),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // จำนวนคอลัมน์
                crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
                childAspectRatio: 0.75, // อัตราส่วนความกว้างต่อความสูง
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3, // เพิ่มเงาให้ Card
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // จัดให้อยู่ด้านบน
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // จัดให้อยู่กลางแนวนอน
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 40,
                          color: const Color.fromARGB(255, 235, 226, 105),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'สินค้า: ${product['name']}', // ชื่อสินค้า
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'รายละเอียดสินค้า: ${product['description']}', // รายละเอียดสินค้า
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 5),
                        Text(
                          'ราคา: ${product['price']} บาท', // ราคา
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Spacer(), // เพิ่มระยะห่างยืดหยุ่นระหว่างเนื้อหาและไอคอน
                            Align(
                              alignment: Alignment
                                  .bottomLeft, // ปรับตำแหน่งให้อยู่ซ้ายล่าง
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 8.0), // เพิ่มระยะห่างจากขอบ
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // จัดตำแหน่งให้อยู่ซ้าย
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .blue[50], // พื้นหลังสีฟ้าอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // ฟังก์ชันแก้ไขสินค้า
                                          showEditProductDialog(
                                              product); // เปด Dialog แกไขสินคา
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                        tooltip: 'แก้ไขสินค้า',
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8), // เพิ่มระยะห่างระหว่างไอคอน
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red[50], // พื้นหลังสีแดงอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          showDeleteConfirmationDialog(
                                              product['key'], context);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        tooltip: 'ลบสินค้า',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
