import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/text_util.dart';

class OrderScreen extends StatefulWidget {
  final String barcode;
  final int total;

  const OrderScreen({
    super.key,
    required this.barcode,
    required this.total,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextUtil(
              text: 'Order Created!',
              color: textColor,
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: buildBarcode(
                Barcode.code128(),
                widget.barcode,
                width: 250,
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            TextUtil(
              text: 'Total',
              color: textColor,
            ),
            Text(
              'Rp ${widget.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBarcode(
  Barcode bc,
  String data, {
  double? width,
  double? height,
  double? fontHeight,
}) {
  final svg = bc.toSvg(
    data,
    width: width ?? 250,
    height: height ?? 80,
    fontHeight: fontHeight,
  );

  return Container(
    color: Colors.white,
    child: SizedBox(
      width: width ?? 250,
      height: height ?? 80,
      child: SvgPicture.string(svg),
    ),
  );
}
