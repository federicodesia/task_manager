import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class MessagingHelper{

  static void autoCloseBlocs({
    required List<BlocBase> blocs,
    Function()? onClosed
  }) async {
    await Future.any(
      blocs.map((bloc) => bloc.stream.first)
    )
    .timeout(const Duration(seconds: 10), onTimeout: () {
      throw TimeoutException("AutoCloseBlocs timeout");
    })
    .then((_){
      autoCloseBlocs(
        blocs: blocs,
        onClosed: onClosed
      );
    })
    .onError((error, _) {
      if(error is TimeoutException)  {
        debugPrint("Auto closing all blocs...");
        
        for (BlocBase bloc in blocs) {
          bloc.close();
        }
        if(onClosed != null) onClosed();
      }
    });
  }
}