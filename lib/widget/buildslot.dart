import 'package:flutter/material.dart';

class BuildSlots extends StatelessWidget {
  final int status;
  // final int index;

  const BuildSlots({
    super.key,
    required this.status,
    // required this.index
  });

  @override
  Widget build(BuildContext context) {
    return status == 0 ? Container() : 
           status == 1 ? Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: Container(
                                  // child: Text(index.toString()),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),                             
                                ),
                              ) : 
                  Padding(
                    padding: const EdgeInsets.all(2.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(255, 235, 18, 2),
                                  ),                             
                                ),
                                );
                      
  }
}