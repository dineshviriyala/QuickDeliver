import 'package:flutter/material.dart';

class ExpandableLocationRow extends StatefulWidget {
  final String location;

  const ExpandableLocationRow({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  _ExpandableLocationRowState createState() => _ExpandableLocationRowState();
}

class _ExpandableLocationRowState extends State<ExpandableLocationRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 23, color: Colors.grey),
              const SizedBox(width: 5),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.location,
                        maxLines: isExpanded ? null : 1,
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 17, fontFamily: 'Latefont'),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isExpanded && widget.location.length < 50)
            const Padding(
              padding: EdgeInsets.only(left: 30.0, top: 5),
              child: Text(
                'No additional location details',
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
