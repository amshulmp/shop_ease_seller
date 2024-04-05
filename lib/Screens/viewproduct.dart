import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_ease_seller/config/configuration.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "M A N A G E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("productid", isEqualTo: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final productData = snapshot.data?.docs;
          if (productData == null || productData.isEmpty) {
            return const Center(child: Text('No product found.'));
          }
          final productDoc = productData.first;
          final documentId = productDoc.id;
          final productMap = productDoc.data() as Map<String, dynamic>;
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: MyConstants.screenHeight(context) * 0.01),
                child: CarouselSlider.builder(
                  itemCount: productMap["imageUrls"].length,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 1,
                    height: MyConstants.screenHeight(context) * 0.4,
                  ),
                  itemBuilder: (BuildContext context, int index, _) {
                    return Image.network(
                      productMap["imageUrls"][index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              ProductAndDescription(
                productName: productMap["productName"] ?? '',
                description: productMap["description"] ?? '',
                price: productMap["price"] ?? '',
                stock: productMap["stock"] ?? '',
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("products").doc(documentId).update({"stock": (productMap["stock"] ?? 0) + 1});
                },
              )
            ],
          );
        },
      ),
    );
  }
}

class ProductAndDescription extends StatelessWidget {
  final String productName;
  final String description;
  final dynamic price;
  final dynamic stock;
  final Function onPressed;
  const ProductAndDescription({super.key, 
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹ $price",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "current stock: $stock",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(onPressed: onPressed as void Function()?, icon: const Icon(Icons.add))
            ],
          ),
        ],
      ),
    );
  }
}
