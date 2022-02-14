import 'package:flutter/material.dart';

class ContextService {
  
  BuildContext? _context;
  void setContext(BuildContext c) => _context = c;

  BuildContext? get context => _context;
}