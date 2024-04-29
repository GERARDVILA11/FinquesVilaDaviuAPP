//BOTTOMAPPBAR
import 'package:flutter/material.dart';
import 'widget_icona_text.dart';

class WidgetBottomAppBar extends StatelessWidget {
  const WidgetBottomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/home", (route) => false);
              },
              child: const WidgetIconaText(
                text: "Inici",
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/favorits", (route) => false);
              },
              child: const WidgetIconaText(
                text: "Favorits",
                icon: Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/signout", (route) => false);
              },
              child: const WidgetIconaText(
                text: "Perfil",
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
