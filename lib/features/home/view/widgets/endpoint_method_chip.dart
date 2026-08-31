import 'package:flutter/material.dart';

import 'package:api_server/core/constants/request_type.dart';

class EndpointMethodChip extends StatelessWidget {
  const EndpointMethodChip({super.key, required this.type});

  final String type;

  Color get _color {
    switch (type) {
      case RequestType.get:
        return Colors.green;
      case RequestType.post:
        return Colors.orangeAccent;
      case RequestType.delete:
        return Colors.deepOrange;
      case RequestType.put:
        return Colors.purple;
      case RequestType.patch:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
