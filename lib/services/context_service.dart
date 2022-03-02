import 'package:flutter/material.dart';

class ContextService {
  
  BuildContext? _context;
  void init(BuildContext context) => _context = context;

  BuildContext? get context => _context;
}