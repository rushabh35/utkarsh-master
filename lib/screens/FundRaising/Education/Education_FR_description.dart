import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:utkarsh/screens/Donations/donations_home.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';

class EducationFRDescriptive extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const EducationFRDescriptive({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _EducationFRDescriptiveState createState() => _EducationFRDescriptiveState();
}

class _EducationFRDescriptiveState extends State<EducationFRDescriptive> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = widget.documentSnapshot['images'];
    double fundsRaised = widget.documentSnapshot['fundsRaised'].toDouble(); // Example value
    double fundsRequired =
        widget.documentSnapshot['fundsRequired'].toDouble(); // Example value
    double progress = fundsRaised / fundsRequired;

    return Scaffold(
      body: Container(
        color: AppConstantsColors.accentColor,
        child: Container(
          decoration: const BoxDecoration(
            color: AppConstantsColors.brightWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image Slider
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: _buildImageSlider(imageUrls),
              ),
              const SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController,
                count: imageUrls.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.black,
                ),
              ),
              // Information Cards
              _infoCard('Name: ${widget.documentSnapshot['name']}'),
              _infoCard('Age: ${widget.documentSnapshot['age']}'),
              _infoCard('Relation: ${widget.documentSnapshot['relation']}'),
              _infoCard('Mobile Number: ${widget.documentSnapshot['mobile']}'),
              _infoCard(
                  'Description: ${widget.documentSnapshot['description']}'),
              const SizedBox(height: 20),
              _fundsProgress(progress, fundsRaised, fundsRequired),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Donate',
                width: MediaQuery.of(context).size.width * 0.6,
                height: 40,
                buttonColor: AppConstantsColors.accentColor,
                onPressed: () {
                  // Add your donation logic here
                  Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DonationsHome(
                          documentSnapshot: widget.documentSnapshot,
                        ),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<dynamic> imageUrls) {
    return PageView.builder(
      controller: _pageController,
      itemCount: imageUrls.length,
      onPageChanged: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: imageUrls[index],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }

  Widget _infoCard(String text) => Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(
              color: AppConstantsColors.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _fundsProgress(
          double progress, double fundsRaised, double fundsRequired) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Funds Raised: $fundsRaised / $fundsRequired',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 10,
            ),
          ],
        ),
      );

  Widget _infoText(String text) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 20, top: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: AppConstantsColors.accentColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
