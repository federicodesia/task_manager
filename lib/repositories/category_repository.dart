import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository{

  Future<List<Category>> fetchCategories() async{

    await Future.delayed(Duration(milliseconds: 2000));
    final List<Category> categories = [];

    categories.add(Category(id: null, name: "General", color: cLightGrayColor));
    categories.add(Category(id: "b2d60aa1-27b7-45c3-8f92-39f66ec7ed27", name: "School", color: Color(0xFFFF6B55)));
    categories.add(Category(id: "520b1787-46e5-4aa4-84fe-4a7d267b84a7", name: "Personal", color: Color(0xFF07B9AE)));
    categories.add(Category(id: Uuid().v4(), name: "Design", color: Color(0xFF7F43FF)));
    categories.add(Category(id: Uuid().v4(), name: "Groceries", color: Color(0xFFDDBC10)));

    return categories;
  }
}