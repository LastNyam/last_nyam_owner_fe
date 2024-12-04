import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';

class MannerTemperatureBar extends StatefulWidget {
  final double initialValue; // 초기 온도 값
  final double minValue;
  final double maxValue;

  const MannerTemperatureBar({
    required this.initialValue,
    this.minValue = 0.0,
    this.maxValue = 99.0,
    Key? key,
  }) : super(key: key);

  @override
  _MannerTemperatureBarState createState() => _MannerTemperatureBarState();
}

class _MannerTemperatureBarState extends State<MannerTemperatureBar> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  Color? getBarColor() {
    if (currentValue < 20.0) {
      return mannerTemperature['primary'];
    }

    if (currentValue >= 20.0 && currentValue < 35.0) {
      return mannerTemperature['secondary'];
    }

    if (currentValue >= 35.0 && currentValue < 42.0) {
      return mannerTemperature['tertiary'];
    }

    if (currentValue >= 42.0 && currentValue < 50.0) {
      return mannerTemperature['quaternary'];
    }

    if (currentValue >= 50.0 && currentValue < 57.0) {
      return mannerTemperature['quinary'];
    }

    if (currentValue >= 57.0 && currentValue < 65.0) {
      return mannerTemperature['senary'];
    }

    if (currentValue >= 65.0 && currentValue < 80.0) {
      return mannerTemperature['septenary'];
    }

    if (currentValue >= 80.0 && currentValue <= 99.0) {
      return mannerTemperature['octonary'];
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage =
        ((currentValue - widget.minValue) / (widget.maxValue - widget.minValue))
            .clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "냠냠 온도",
                    style: TextStyle(
                      color: defaultColors['black'],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: defaultColors['black'],
                      decorationThickness: 3.0,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Icon(Icons.info_outline, size: 16.0, color: Colors.grey),
                ],
              ),
              Text(
                "${currentValue.toStringAsFixed(1)}°C",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: getBarColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Stack(
            children: [
              // Background bar
              Container(
                height: 8.0,
                decoration: BoxDecoration(
                  color: defaultColors['white'],
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              // Foreground bar
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: getBarColor(),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Slider to adjust the temperature value
        ],
      ),
    );
  }
}
