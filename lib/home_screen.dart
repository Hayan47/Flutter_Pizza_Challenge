import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_challenge/pizza_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _nameController = PageController();
  final PageController _imageController = PageController(
    viewportFraction: 0.85,
  );
  final PageController _detailsController = PageController();
  int selectedSized = 1;
  var _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _imageController.addListener(
      () {
        setState(() {
          _currentPage = _imageController.page!;
        });
        _nameController.jumpTo(_imageController.offset *
            45 /
            (MediaQuery.sizeOf(context).width * 0.85));
        _detailsController.jumpTo(_imageController.offset *
            150 /
            (MediaQuery.sizeOf(context).width * 0.85));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //!app bar
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF0A1529),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Image.asset('assets/menu.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.3,
                color: const Color(0xFF0A1529),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  //!name
                  height: 45,
                  child: PageView.builder(
                    controller: _nameController,
                    itemCount: pizzaList.length,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Text(
                        pizzaList[index].name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                //!image
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: PageView.builder(
                    itemCount: pizzaList.length,
                    controller: _imageController,
                    itemBuilder: (context, index) {
                      var scaleFactor = 0.8;
                      var angle =
                          _currentPage * 90 * (3.1415926535897932 / 180);
                      Matrix4 matrix4 = Matrix4.identity();
                      var currentScale = 0.0;
                      if (index == _currentPage.floor()) {
                        currentScale =
                            1 - (_currentPage - index) * (1 - scaleFactor);
                        matrix4 =
                            Matrix4.diagonal3Values(1.0, currentScale, 1.0);
                      } else if (index == _currentPage.floor() + 1) {
                        currentScale = scaleFactor +
                            (_currentPage - index + 1) * (1 - scaleFactor);
                        matrix4 =
                            Matrix4.diagonal3Values(1.0, currentScale, 1.0);
                      } else if (index == _currentPage.floor() - 1) {
                        currentScale =
                            1 - (_currentPage - index) * (1 - scaleFactor);
                        matrix4 =
                            Matrix4.diagonal3Values(1.0, currentScale, 1.0);
                      } else {
                        currentScale = 0.8;
                        matrix4 =
                            Matrix4.diagonal3Values(1.0, currentScale, 1.0);
                      }
                      return Transform.rotate(
                        angle: angle,
                        child: Transform(
                          transform: matrix4,
                          child: Image.asset(
                            pizzaList[index].image,
                            width: MediaQuery.of(context).size.width,
                            height: 310,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  //!details
                  child: SizedBox(
                    height: 150,
                    child: PageView.builder(
                      itemCount: pizzaList.length,
                      controller: _detailsController,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$${pizzaList[index].price}",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                color: const Color(0xFF0A1529),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              pizzaList[index].description,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  height: 1.2,
                                  color: Colors.grey[500]!,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //!size
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSized = 0;
                            });
                          },
                          child: Container(
                            height: 55,
                            width: 40,
                            decoration: BoxDecoration(
                              color: selectedSized == 0
                                  ? const Color(0xFFB4E0FB)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              border: Border.all(
                                  color: selectedSized == 0
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  width: 1),
                            ),
                            child: Center(
                              child: Text(
                                'S',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: selectedSized == 0
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSized = 1;
                            });
                          },
                          child: Container(
                            height: 55,
                            width: 40,
                            decoration: BoxDecoration(
                              color: selectedSized == 1
                                  ? const Color(0xFFB4E0FB)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              border: Border.all(
                                  color: selectedSized == 1
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  width: 1),
                            ),
                            child: Center(
                              child: Text(
                                'M',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: selectedSized == 1
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSized = 2;
                            });
                          },
                          child: Container(
                            height: 55,
                            width: 40,
                            decoration: BoxDecoration(
                              color: selectedSized == 2
                                  ? const Color(0xFFB4E0FB)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              border: Border.all(
                                  color: selectedSized == 2
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  width: 1),
                            ),
                            child: Center(
                              child: Text(
                                'L',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: selectedSized == 2
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 40, vertical: MediaQuery.sizeOf(context).height * 0.01),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              'Order Now',
              style: GoogleFonts.poppins(
                color: const Color(0xFF0A1529),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
