import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/product_service.dart';
import 'package:ufc_mobile/models/animal_type_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

part "product_future_riverpod.g.dart";

@Riverpod(keepAlive: true)
Future<ProductModel> getProductDetails(Ref ref, final int productId) async {
  return await ProductService().getProductDetails(productId);
}

@Riverpod(keepAlive: true)
Future<List<AnimalTypeModel>> getProductSubtypes(Ref ref) async {
  return ProductService().getProductSubtypes();
}
