import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KALKULATOR BMI",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KalkulatorScreen(),
    );
  }
}

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen>
    with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double? _bmiResult;
  String _bmiInterpretation = "Masukkan berat dan tinggi badan Anda.";
  String _gender = "Laki-laki";
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  void _calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double heightInCM = double.tryParse(_heightController.text) ?? 0;

    if (weight <= 0 || heightInCM <= 0) {
      setState(() {
        _bmiResult = null;
        _bmiInterpretation = "Masukkan data yang valid!";
      });
      return;
    }

    final double heightInM = heightInCM / 100;
    final double bmi = weight / (heightInM * heightInM);

    setState(() {
      _bmiResult = bmi;
      _controller.forward(from: 0);

      if (_gender == "Laki-laki") {
        if (bmi < 18.5) {
          _bmiInterpretation = "Kekurangan berat badan";
        } else if (bmi < 25) {
          _bmiInterpretation = "Berat badan ideal";
        } else if (bmi < 30) {
          _bmiInterpretation = "Kelebihan berat badan";
        } else {
          _bmiInterpretation = "Obesitas";
        }
      } else {
        if (bmi < 18) {
          _bmiInterpretation = "Kekurangan berat badan";
        } else if (bmi < 24) {
          _bmiInterpretation = "Berat badan ideal";
        } else if (bmi < 29) {
          _bmiInterpretation = "Kelebihan berat badan";
        } else {
          _bmiInterpretation = "Obesitas";
        }
      }
    });
  }

  void _resetFields() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = null;
      _bmiInterpretation = "Masukkan berat dan tinggi badan Anda.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2FEFA),
              Color(0xFF0ED2F7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "💪 Kalkulator BMI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),

                // Pilih Jenis Kelamin
                _buildCard(
                  child: Column(
                    children: [
                      const Text(
                        "Pilih Jenis Kelamin",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text("Laki-laki"),
                            selected: _gender == "Laki-laki",
                            onSelected: (v) => setState(() => _gender = "Laki-laki"),
                            selectedColor: Colors.teal.shade300,
                            backgroundColor: Colors.grey.shade200,
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Perempuan"),
                            selected: _gender == "Perempuan",
                            onSelected: (v) => setState(() => _gender = "Perempuan"),
                            selectedColor: Colors.pink.shade300,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                _buildTextField(
                    controller: _weightController,
                    label: "Berat Badan (kg)",
                    icon: Icons.monitor_weight),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _heightController,
                    label: "Tinggi Badan (cm)",
                    icon: Icons.height),

                const SizedBox(height: 30),

                // Tombol Hitung & Reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _calculateBMI,
                      icon: const Icon(Icons.calculate),
                      label: const Text("Hitung"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _resetFields,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                const Text(
                  "Hasil Perhitungan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 16),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCard(
                    color: Colors.white.withOpacity(0.85),
                    child: Column(
                      children: [
                        Text(
                          _bmiResult != null
                              ? _bmiResult!.toStringAsFixed(1)
                              : '--',
                          style: const TextStyle(
                              fontSize: 52, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _bmiInterpretation,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "($_gender)",
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, Color? color}) {
    return Card(
      color: color ?? Colors.white.withOpacity(0.9),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
