import 'package:finques_viladaviu_app/APP/immobles_filtrats2.dart';
import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final User userId;
  final String operacioSeleccionat;
  final String tipusSeleccionat;
  final String poblacioSeleccionat;
  const FilterScreen(
      {Key? key,
      required this.userId,
      required this.operacioSeleccionat,
      required this.tipusSeleccionat,
      required this.poblacioSeleccionat})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Variables para almacenar los valores de los filtros seleccionados
  double minPrice = 10000.0;
  double maxPrice = 500000.0;
  double minM2 = 20;
  double maxM2 = 900;
  List<String> selectedHabitaciones = ["1", "2", "3", "4", "Més de 4"];
  List<String> selectedFeatures = [];

  // Función para realizar la búsqueda con los filtros seleccionados
  void performSearch() {
    /*  print(minPrice);
    print(maxPrice);
    print(minM2);
    print(maxM2);
    print(selectedHabitaciones);
    print(selectedFeatures); */
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ImmoblesFiltrats2(
          userId: widget.userId,
          operacioSeleccionat: widget.operacioSeleccionat,
          tipusSeleccionat: widget.tipusSeleccionat,
          poblacioSeleccionat: widget.poblacioSeleccionat,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minSurface: minM2,
          maxSurface: maxM2,
          numHabs: selectedHabitaciones,
          features: selectedFeatures,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.operacioSeleccionat,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              "${widget.tipusSeleccionat == 'Qualsevol' ? 'Qualsevol tipus' : widget.tipusSeleccionat} a ${widget.poblacioSeleccionat == 'Totes' ? 'Totes les poblacions' : widget.poblacioSeleccionat}",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            FilterPrice(
              onOptionSelected: (min, max) {
                setState(() {
                  minPrice = min;
                  maxPrice = max;
                });
              },
            ),
            const SizedBox(height: 20),
            FilterSuperficie(
              onOptionSelected: (min, max) {
                setState(() {
                  minM2 = min;
                  maxM2 = max;
                });
              },
            ),
            const SizedBox(height: 20),
            FilterHabs(
              onChanged: (selectedValues) {
                setState(() {
                  selectedHabitaciones = selectedValues;
                });
              },
            ),
            const SizedBox(height: 20),
            FilterFeatures(
              onChanged: (selectedValues) {
                setState(() {
                  selectedFeatures = selectedValues;
                });
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 360,
        child: FloatingActionButton.extended(
          isExtended: true,
          backgroundColor: ColorFinques.verd,
          onPressed: performSearch,
          label: const Row(
            children: [
              Text(
                "Cercar resultats",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterPrice extends StatefulWidget {
  final Function(double, double)? onOptionSelected;

  const FilterPrice({Key? key, this.onOptionSelected}) : super(key: key);

  @override
  State<FilterPrice> createState() => _FilterPriceState();
}

class _FilterPriceState extends State<FilterPrice> {
  double _minPrice = 10000.0;
  double _maxPrice = 500000.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: RangeSlider(
            activeColor: Colors.green,
            values: RangeValues(_minPrice, _maxPrice),
            min: 10000,
            max: 500000,
            divisions: 20,
            labels: RangeLabels(' ${_minPrice.toInt().toString()}€',
                '${_maxPrice.toInt().toString()}€'),
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
                _upgradeSelection(_minPrice,
                    _maxPrice); // Llamar a _upgradeSelection cuando cambia el valor del slider
              });
            },
          ),
        ),
      ],
    );
  }

  void _upgradeSelection(double minPrice, double maxPrice) {
    widget.onOptionSelected?.call(minPrice,
        maxPrice); // Llamar a la función proporcionada por el widget padre con los nuevos valores
  }
}

class FilterSuperficie extends StatefulWidget {
  final Function(double, double)? onOptionSelected;

  const FilterSuperficie({Key? key, this.onOptionSelected}) : super(key: key);

  @override
  State<FilterSuperficie> createState() => _FilterSuperficieState();
}

class _FilterSuperficieState extends State<FilterSuperficie> {
  double _minm2 = 20;
  double _maxm2 = 900;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Superfície",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: RangeSlider(
            activeColor: Colors.green,
            values: RangeValues(_minm2, _maxm2),
            min: 20,
            max: 900,
            divisions: 20,
            labels: RangeLabels(' ${_minm2.toInt().toString()} m²',
                '${_maxm2.toInt().toString()} m²'),
            onChanged: (RangeValues values) {
              setState(() {
                _minm2 = values.start;
                _maxm2 = values.end;
                _upgradeSelection(_minm2, _maxm2);
              });
            },
          ),
        ),
      ],
    );
  }

  void _upgradeSelection(double minPrice, double maxPrice) {
    widget.onOptionSelected?.call(minPrice,
        maxPrice); // Llamar a la función proporcionada por el widget padre con los nuevos valores
  }
}

class FilterHabs extends StatefulWidget {
  final Function(List<String>)? onChanged;

  const FilterHabs({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FilterHabs> createState() => _FilterHabsState();
}

class _FilterHabsState extends State<FilterHabs> {
  List<bool> _selectedValues = [];
  List<String> numHabitacions = ["1", "2", "3", "4", "Més de 4"];

  @override
  void initState() {
    super.initState();

    _selectedValues = List<bool>.filled(numHabitacions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Habitacions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Wrap(
            direction: Axis.vertical,
            children: List.generate(numHabitacions.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: _selectedValues[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedValues[index] = value!;
                        _updateSelection();
                      });
                    },
                  ),
                  Text(numHabitacions[index]),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  void _updateSelection() {
    List<String> selectedValues = [];
    for (int i = 0; i < _selectedValues.length; i++) {
      if (_selectedValues[i]) {
        selectedValues.add(numHabitacions[i]);
      }
    }
    widget.onChanged!(selectedValues);
  }
}

class FilterFeatures extends StatefulWidget {
  final Function(List<String>)? onChanged;
  const FilterFeatures({super.key, this.onChanged});

  @override
  State<FilterFeatures> createState() => _FilterFeaturesState();
}

class _FilterFeaturesState extends State<FilterFeatures> {
  List<bool> _selectedValues = [];
  List<String> features = [
    "Parking",
    "Jardí",
    "Ascensor",
    "Piscina",
    "Traster"
  ];
  @override
  void initState() {
    super.initState();

    _selectedValues = List<bool>.filled(features.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Característiques",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Wrap(
            direction: Axis.vertical,
            children: List.generate(features.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: _selectedValues[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedValues[index] = value!;
                        _updateSelection();
                      });
                    },
                  ),
                  Text(features[index]),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  void _updateSelection() {
    List<String> selectedValues = [];
    for (int i = 0; i < _selectedValues.length; i++) {
      if (_selectedValues[i]) {
        selectedValues.add(features[i]);
      }
    }
    widget.onChanged!(selectedValues);
  }
}
