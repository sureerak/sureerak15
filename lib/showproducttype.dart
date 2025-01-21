import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onlineapp_ging/productdetail.dart';

class ShowProductType extends StatelessWidget {
  final List<String> categories = ['Electronics', 'Clothing', 'Food', 'Books'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประเภทสินค้า'),
        backgroundColor: const Color.fromARGB(255, 112, 230, 147),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // จำนวนคอลัมน์
          crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
          childAspectRatio: 1.2, // อัตราส่วนระหว่างความกว้างและความสูง
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: InkWell(
              onTap: () {
                // เมื่อคลิกที่ประเภทสินค้า จะไปที่หน้าแสดงสินค้าของประเภทนั้น
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductCategoryPage(category: category),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Icon(
                    Icons.shopping_cart, // เปลี่ยนเป็นไอคอนรถเข็น
                    size: 30,
                    color: Colors.blueAccent,
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

class ProductCategoryPage extends StatefulWidget {
  final String category;
  ProductCategoryPage({required this.category});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  // ฟังก์ชันดึงข้อมูลสินค้า
  Future<void> fetchProductsByCategory() async {
    try {
      final snapshot = await dbRef
          .orderByChild('category') // กรองข้อมูลตาม 'category'
          .equalTo(widget.category) // ตรวจสอบให้ตรงกับประเภทที่เลือก
          .get(); // ดึงข้อมูล

      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          loadedProducts.add(product);
        });

        setState(() {
          products = loadedProducts; // อัพเดตข้อมูลสินค้าใน state
        });
      } else {
        print("ไม่พบสินค้าของประเภท ${widget.category}");
        setState(() {
          products = []; // ถ้าไม่มีสินค้าให้แสดงข้อมูลเป็น empty
        });
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
    fetchProductsByCategory(); // เรียกใช้ฟังก์ชันเมื่อหน้าถูกโหลด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Products'),
        backgroundColor: Color.fromARGB(255, 238, 155, 83),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      // เมื่อคลิกที่สินค้าจะไปยังหน้ารายละเอียดสินค้า
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(
                            product:
                                product, // ส่งข้อมูลสินค้าไปที่หน้ารายละเอียด
                          ),
                        ),
                      );
                    },
                    leading: Icon(Icons.shopping_cart,
                        size: 40, color: const Color.fromARGB(255, 204, 145, 145)),
                    title: Text(product['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('ราคา: ${product['price']} บาท'),
                  ),
                );
              },
            ),
    );
  }
}
