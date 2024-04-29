import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Sobre Finques Vila Daviu",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                quiSom(),
                const SizedBox(
                  height: 20,
                ),
                queOferim(),
                const SizedBox(
                  height: 20,
                ),
                imatge(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }

  Widget quiSom() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Qui som?",
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Som el Jaume Vila Costa i la Sílvia Ayats Daviu, professionals qualificats amb més de trenta anys d’experiència en el sector immobiliari. Formem un equip dinàmic i la nostra prioritat és satisfer els interesos dels nostres clients, sempre amb un tracte honest, seriós i discret. \n Tenim una àmplia cartera i és per aixó que hem decidit crear aquesta nova empresa i poder-los oferir els millors serveis. \n Us esperem a les nostres oficines, situades al centre de Tàrrega, carrer del Carme 25, en planta baixa, facilitat d’accés i despatx discret.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }

  Widget queOferim() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Què oferim?",
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        SizedBox(
          height: 10,
        ),
        WidgetIconaText(
            text:
                "Serveis de lloguer i compra-venda de tot tipus d’immobles, locals, solars i finques rústiques."),
        WidgetIconaText(
            text:
                "Tramitem totes les transaccions ajudant-te a aconseguir el cent per cent de la financiació."),
        WidgetIconaText(
            text:
                "T’assessorem professionalment de totes les despeses fiscals, ( compra-venda, herències, donacions… )"),
        WidgetIconaText(
            text:
                "Administrem el teu lloguer i t’assegurem el cent per cent en cas d’impagats."),
        WidgetIconaText(
            text: "Tramitem cèdules d’habitabilitat i certificats energètics."),
        WidgetIconaText(text: "Valorem i taxem la teva propietat.")
      ],
    );
  }

  Widget imatge() {
    return Image.asset("assets/API.png");
  }
}

class WidgetIconaText extends StatelessWidget {
  final String text;
  const WidgetIconaText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            margin: const EdgeInsets.only(top: 6.0, right: 8.0),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
