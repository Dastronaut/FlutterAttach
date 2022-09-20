import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final double width;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    required this.width,
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.7,
      height: widget.width * 0.13,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: widget.width * 0.7,
              height: widget.width * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: MyColors.MajorelleBlue),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.width * 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: widget.width * 0.05),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: widget.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: MyColors.Quartz,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: widget.width * 0.35,
              height: widget.width * 0.13,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [MyColors.SteelPink, MyColors.MajorelleBlue]),
                shape: BoxShape.rectangle,
                border: Border.all(color: MyColors.MajorelleBlue),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.width * 0.1)),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: widget.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: MyColors.Platinum),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
