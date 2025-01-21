import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;
  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']), // ใช้ชื่อสินค้าบนแถบหัวเรื่อง
        backgroundColor: Color.fromARGB(255, 214, 237, 80),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงชื่อสินค้า
            Text(
              product['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // แสดงรายละเอียดสินค้า
            Text(
              'รายละเอียด: ${product['description']}', // ใช้คำว่า "รายละเอียด" ก่อนคำอธิบาย
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // แสดงราคา
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            // แสดงจำนวนสินค้าในสต็อก
            Text(
              'จำนวน: ${product['quantity']} ',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
