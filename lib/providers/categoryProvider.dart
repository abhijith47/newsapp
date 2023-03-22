import 'package:flutter/material.dart';
import 'package:newsapp/models/categoryModel.dart';

class CategoryProvider with ChangeNotifier {
  CategoryModel _categoryData = CategoryModel();
  List<CategoryModel> categoryList = [];

  List<CategoryModel> get categoryData {
    return categoryList;
  }

  void addCategoryData(CategoryModel obj) {
    _categoryData = obj;
    categoryList.add(_categoryData);
    notifyListeners();
  }

  void removeItem(docId) {
    categoryList.removeWhere((item) => item.CategoryId == docId);

    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
