import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository{

  Future<List<Category>> fetchCategories() async{

    await Future.delayed(Duration(milliseconds: 500));
    final List<Category> categories = [];

    categories.add(Category(uuid: Uuid().v4(), name: "School", color: Color(0xFFFF6B55)));
    categories.add(Category(uuid: Uuid().v4(), name: "Personal", color: Color(0xFF07B9AE)));
    categories.add(Category(uuid: Uuid().v4(), name: "Design", color: Color(0xFF7F43FF)));
    categories.add(Category(uuid: Uuid().v4(), name: "Groceries", color: Color(0xFFDDBC10)));

    return categories;
  }
}