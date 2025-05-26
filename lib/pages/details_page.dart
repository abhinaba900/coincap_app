import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> coinData;
  const DetailsPage({super.key, required this.coinData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final key = coinData.keys.elementAt(index).toUpperCase();
            final value = coinData.values.elementAt(index).toString();
            return ListTile(
              title: Row(
                children: [
                  Text(
                    "$key: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "$value USD",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: coinData.length,
        ),
      ),
    );
  }
}
