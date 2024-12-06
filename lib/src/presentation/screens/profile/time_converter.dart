import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TimeConverterPage extends StatefulWidget {
  const TimeConverterPage({Key? key}) : super(key: key);

  @override
  State<TimeConverterPage> createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  DateTime _currentTime = DateTime.now();
  String _selectedZone = 'WIB'; // Zona waktu default

  @override
  void initState() {
    super.initState();
    // Memperbarui waktu setiap detik
    _updateCurrentTime();
  }

  void _updateCurrentTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
    Future.delayed(const Duration(seconds: 1), _updateCurrentTime);
  }

  String _getConvertedTime() {
    switch (_selectedZone) {
      case 'WIB':
        return DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(_currentTime.add(Duration(hours: 7)));
      case 'WITA':
        return DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(_currentTime.add(Duration(hours: 8)));
      case 'WIT':
        return DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(_currentTime.add(Duration(hours: 9)));
      default:
        return DateFormat('yyyy-MM-dd HH:mm:ss').format(_currentTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Time in ${_selectedZone}:',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _getConvertedTime(),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              DropdownButton<String>(
                value: _selectedZone,
                items: <String>['WIB', 'WITA', 'WIT']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedZone = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
