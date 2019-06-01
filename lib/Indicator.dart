import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int currentPage;
  final int length;

  Indicator(this.currentPage, this.length);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildIndicator(),
    );
  }

  _buildIndicator() {
    List<Widget> indicatorList = [];
    for (var i = 0; i < length; i++) {
      indicatorList
          .add(i == currentPage ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  Widget _indicator(bool isActive) {
    return Expanded(
      child: Container(
        height: 10.0,
        width: 30.0,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Color(0xff3e4750),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
      ),
    );
  }
}
