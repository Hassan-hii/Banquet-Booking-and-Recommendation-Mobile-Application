import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MenuSectionWidget extends StatelessWidget {

  final Widget image;
  final String title, subTitle;
  const MenuSectionWidget({required this.image,
  required this.title,
  required this.subTitle, super.key});

  @override
  Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              Flexible(child: image),
            ],
          ),
          AutoSizeText(
            subTitle,
            softWrap: true,
            maxLines: 5,
            style: const TextStyle(fontSize: 15),
            minFontSize: 10,
          ),
          const SizedBox(height: 5),
        ],
      );
  }
}
