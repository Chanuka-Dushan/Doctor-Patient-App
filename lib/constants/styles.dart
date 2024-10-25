import 'package:flutter/material.dart';

const TextStyle titleStyle = TextStyle(
  color: Color.fromARGB(255, 58, 171, 197),
  fontSize: 35,
  fontWeight: FontWeight.w900,
  fontFamily: 'Poppins',
);

const TextStyle inputTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);

const TextStyle labelStyle = TextStyle(
  fontSize: 14,
  color: Colors.black54,
);

const TextStyle linkTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.blue,
);

const TextStyle dividerTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);