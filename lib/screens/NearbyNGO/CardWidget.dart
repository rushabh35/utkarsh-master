import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';

class CardNearby extends StatefulWidget {
  final String ngoName;
  final String ngoAddress;
  final String distance;
  final String? website; // Optional website URL

  const CardNearby({
    super.key, 
    required this.ngoName, 
    required this.ngoAddress, 
    required this.distance,
    this.website, // Add the website as an optional parameter
  });

  @override
  State<CardNearby> createState() => _CardNearbyState();
}

class _CardNearbyState extends State<CardNearby> {
  @override
  Widget build(BuildContext context) {
    Color shadowColor = Colors.grey.withOpacity(0.5);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        shadowColor: shadowColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.home_filled, color: AppConstantsColors.purpleColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.ngoName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstantsColors.purpleColor)),
                        const SizedBox(height: 5),
                        Text(widget.ngoAddress, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.navigation_rounded, color: AppConstantsColors.accentColor, size: 20),
                            const SizedBox(width: 5),
                            Text('${widget.distance} km away', style: const TextStyle(color: AppConstantsColors.accentColor)),
                            if (widget.website != null) ...[
                              const Spacer(), // Use Spacer to push the icon to the right
                              IconButton(
                                icon: const Icon(Icons.open_in_new, color: AppConstantsColors.accentColor),
                                onPressed: () => _launchURL(widget.website!),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
