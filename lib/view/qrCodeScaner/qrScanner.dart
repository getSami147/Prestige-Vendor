import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/view/categories/catageries.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamra = false;
  MobileScannerController mobileScannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("reBuild");
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          StatefulBuilder(builder: (context, changeState) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    isFlashOn = !isFlashOn;
                    changeState(() {});
                    mobileScannerController.toggleTorch();
                  },
                  icon: Icon(
                    Icons.flash_on,
                    color: isFlashOn ? colorPrimary : Colors.grey,
                  ),
                ),

                // Switch camera....
                IconButton(
                  onPressed: () {
                    isFrontCamra = !isFrontCamra;
                    changeState(() {});
                    mobileScannerController.switchCamera();
                  },
                  icon: isFrontCamra
                      ? const Icon(
                          Icons.switch_camera_outlined,
                          color: colorPrimary,
                        )
                      : const Icon(
                          Icons.camera_alt,
                          color: colorPrimary,
                        ),
                )
              ],
            );
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                children: [
                  Text(
                    "Place the QR Code in The Area",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:textSizeLargeMedium,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Scanning will the Start Automatically"),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: mobileScannerController,
                    onDetect: (barcode) {
                      if (!isScanCompleted) {
                        if (kDebugMode) {
                          print("Scan is not Completed");
                        }
                         var code =
                              barcode.raw[0]['rawValue'].toString() ?? '...';
                        if (kDebugMode) {
                          print("Code: $code");
                        }

                        isScanCompleted = true;
                        if (kDebugMode) {
                          print("Scan Completed");
                        }
                        HomeViewModel().sandOtpBeforeOrder(context, code); 
                      } else {
                        if (kDebugMode) {
                          print("else");
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.white,
                    borderColor: colorPrimary,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Expanded(child: Text("Prestige+ Reward")),
          ],
        ),
      ),
    );
  }
}
