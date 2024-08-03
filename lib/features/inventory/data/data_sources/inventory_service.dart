import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

class InventoryService {
  final FirebaseFirestore _firebaseFirestore;

  InventoryService(this._firebaseFirestore);

  Future<void> addProduct(ProductModel product) async {
    try {
      var documentReference = _firebaseFirestore
          .collection('inventory')
          .doc(product.uid)
          .collection("items")
          .doc();
      product.id = documentReference.id;
      documentReference.set(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firebaseFirestore
          .collection('inventory')
          .doc(product.uid)
          .collection("items")
          .doc(product.id).set(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProductById(String productId, String uid) async {
    try {
      var product = await _firebaseFirestore
          .collection('inventory')
          .doc(uid)
          .collection("items").doc(productId).get();
      if (product.exists) {
        return ProductModel.fromJson(product.data()!);
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getAllProducts(String uid) async {
    try {
      var inventory = await _firebaseFirestore
          .collection('inventory')
          .doc(uid)
          .collection("items")
          .get();
      List<ProductModel> productList = [];
      for (var element in inventory.docs) {
        if (element.exists) {
          productList.add(ProductModel.fromJson(element.data()));
        }
      }
      return productList;
    } catch (e) {
      rethrow;
    }
  }
}
