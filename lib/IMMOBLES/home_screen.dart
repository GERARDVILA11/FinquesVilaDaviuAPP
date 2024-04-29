import 'dart:async';
import 'package:finques_viladaviu_app/APP/immobles_filtrats2.dart';
import 'package:finques_viladaviu_app/dades/filters_data.dart';
import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottomnavigationbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? _user;
  String? selectedOperacio;
  String? selectedTipus;
  String? selectedPoblacio;
  double minPrice = 0;
  double maxPrice = 0;
  double minM2 = 0;
  double maxM2 = 0;
  List<String> selectedHabitaciones = [];
  List<String> selectedFeatures = [];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imatgesOficina = [
      "assets/oficina1.jpg",
      "assets/oficina3.jpg",
      "assets/oficina4.jpg",
      "assets/oficina5.jpg"
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                "assets/logo.png",
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 20,
              ),
              SelectionWidget(
                onOptionSelected: (value) {
                  setState(() {
                    selectedOperacio = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SelectorTipusImmoble(
                filtersData,
                onOptionSelected: (value) {
                  setState(() {
                    selectedTipus = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SelectorPoblacio(
                filtersData,
                onOptionSelected: (value) {
                  setState(() {
                    selectedPoblacio = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              busquedaImmobles(
                selectedOperacio,
                selectedTipus,
                selectedPoblacio,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Visita'ns",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: ImageRotator(imageLinks: imatgesOficina),
                onTap: () {
                  final Uri url =
                      Uri.parse("https://maps.app.goo.gl/NSArdvRNHe3bZfDE8");
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WidgetBottomAppBar(),
    );
  }

  Widget busquedaImmobles(
    String? operacio,
    String? tipus,
    String? poblacio,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateToFilteredProperties(context);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(56, 172, 36, 1),
        ),
        // Ajuste del ancho
        child: const Center(
          child: Text(
            "Cerca",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _navigateToFilteredProperties(BuildContext context) {
    if (selectedOperacio != null &&
        selectedTipus != null &&
        selectedPoblacio != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImmoblesFiltrats2(
            userId: _user!,
            operacioSeleccionat: selectedOperacio!,
            tipusSeleccionat: selectedTipus!,
            poblacioSeleccionat: selectedPoblacio!,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minSurface: minM2,
            maxSurface: maxM2,
            numHabs: selectedHabitaciones,
            features: selectedFeatures,
          ),
        ),
      );
    } else {
      _showErrorDialog(context, "Algún dels camps no està seleccionat");
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ImageRotator extends StatefulWidget {
  final List<String> imageLinks;

  const ImageRotator({Key? key, required this.imageLinks}) : super(key: key);

  @override
  State<ImageRotator> createState() => _ImageRotatorState();
}

class _ImageRotatorState extends State<ImageRotator> {
  late int _currentIndex;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imageLinks.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 3), (i) => i),
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              widget.imageLinks[_currentIndex],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class SelectionWidget extends StatefulWidget {
  final Function(String)? onOptionSelected;

  const SelectionWidget({
    super.key,
    this.onOptionSelected,
  });

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOption = "Venda";
                  widget.onOptionSelected!(_selectedOption);
                });
              },
              child: Container(
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedOption == "Venda"
                      ? ColorFinques.verd // Color cuando seleccionado
                      : Colors.white,
                ),
                // Ajuste del ancho
                child: Center(
                  child: Text(
                    "Venda",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedOption == "Venda"
                          ? Colors.white // Color del texto cuando seleccionado
                          : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOption = "Lloguer";
                  widget.onOptionSelected!(_selectedOption);
                });
              },
              child: Container(
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedOption == "Lloguer"
                      ? ColorFinques.verd // Color cuando seleccionado
                      : Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Lloguer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedOption == "Lloguer"
                          ? Colors.white // Color del texto cuando seleccionado
                          : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SelectorTipusImmoble extends StatefulWidget {
  final List<Map<String, dynamic>> dadesFiltres;
  final Function(String)? onOptionSelected;

  const SelectorTipusImmoble(this.dadesFiltres,
      {super.key, this.onOptionSelected});

  @override
  State<SelectorTipusImmoble> createState() => _SelectorTipusImmobleState();
}

class _SelectorTipusImmobleState extends State<SelectorTipusImmoble> {
  String? tipusImmobleSeleccionat;

  @override
  Widget build(BuildContext context) {
    List<String> tipusImmoble = widget.dadesFiltres
        .firstWhere((filtre) => filtre["name"] == "Tipus")["value"]
        .cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 50,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: tipusImmobleSeleccionat,
              onChanged: (String? newValue) {
                setState(() {
                  tipusImmobleSeleccionat = newValue;
                  widget.onOptionSelected!(tipusImmobleSeleccionat!);
                });
              },
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
              items: tipusImmoble.map<DropdownMenuItem<String>>((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      valor,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Tipus d'immoble",
                  style: TextStyle(
                      color: tipusImmobleSeleccionat == null
                          ? Colors.black
                          : Colors.black),
                ),
              ),
              dropdownColor: Colors.white,
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectorPoblacio extends StatefulWidget {
  final List<Map<String, dynamic>> filtersData;
  final Function(String)? onOptionSelected;

  const SelectorPoblacio(this.filtersData, {super.key, this.onOptionSelected});

  @override
  State<SelectorPoblacio> createState() => _SelectorPoblacioState();
}

class _SelectorPoblacioState extends State<SelectorPoblacio> {
  String? selectedPoblacion;

  @override
  Widget build(BuildContext context) {
    List<String> poblaciones = widget.filtersData
        .firstWhere((filter) => filter["name"] == "Població")["value"]
        .cast<String>();

    return Container(
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: 50,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPoblacion,
          onChanged: (String? newValue) {
            setState(() {
              selectedPoblacion = newValue;
              // Verificar si onOptionSelected no es nulo antes de llamarlo
              if (widget.onOptionSelected != null) {
                widget.onOptionSelected!(selectedPoblacion!);
              }
            });
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.arrow_drop_down, color: Colors.black),
          ),
          items: poblaciones.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Població",
              style: TextStyle(
                  color:
                      selectedPoblacion == null ? Colors.black : Colors.black),
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
