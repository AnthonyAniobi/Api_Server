import 'package:flutter/material.dart';

class EndpointsWidget extends StatelessWidget {
  const EndpointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Endpoints'),
              IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Expanded(child: ListView.builder(itemBuilder: ((context, index) {
            return Card(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('howdy ')),
            );
          })))
        ],
      ),
    );
  }
}
