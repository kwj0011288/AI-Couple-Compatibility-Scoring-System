import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissing_booth/component/custom_button.dart';
import 'package:kissing_booth/theme/font.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlusButton extends StatefulWidget {
  final Uint8List? imageBytes;
  final ValueChanged<Uint8List> onImageSelected;
  final VoidCallback onImageDeleted;
  final bool isMe;
  final bool isCouple;

  const PlusButton({
    Key? key,
    required this.imageBytes,
    required this.onImageSelected,
    required this.onImageDeleted,
    required this.isMe,
    this.isCouple = false,
  }) : super(key: key);

  @override
  State<PlusButton> createState() => _PlusButtonState();
}

class _PlusButtonState extends State<PlusButton> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Only start fade animation if image is present
    if (widget.imageBytes != null) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(PlusButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the image has been set, start fade-in animation
    if (widget.imageBytes != null && oldWidget.imageBytes == null) {
      _fadeController.forward();
    }
    // If the image has been removed, start fade-out animation
    if (widget.imageBytes == null && oldWidget.imageBytes != null) {
      _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> simulateLoadingAndCompress(Uint8List byteData) async {
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    File? compressedFile;

    // 압축 작업 실행
    compressedFile = await compressImage(byteData);

    setState(() {
      _isLoading = false;
      _progress = 0.0; // 진행률 초기화
    });

    if (compressedFile != null) {
      print("ttttttt: ${compressedFile.lengthSync()} bytes");
      widget.onImageSelected(await compressedFile.readAsBytes());
    }
  }

  Future<File?> compressImage(Uint8List byteData,
      {int initialQuality = 50}) async {
    // Decode the image data
    img.Image? decodedImage = img.decodeImage(byteData);
    if (decodedImage == null) {
      print("Unable to decode the image.");
      return null;
    }

    File tempFile;
    int quality = initialQuality;

    do {
      // 현재 압축 단계의 진행률 계산
      double progressStep = 10.0 / initialQuality; // 10번 반복 기준으로 계산
      await Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _progress += progressStep;
        });
      });

      // 압축 수행
      Uint8List compressedData =
          Uint8List.fromList(img.encodeJpg(decodedImage, quality: quality));

      // Create a temporary file
      tempFile = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');
      tempFile.writeAsBytesSync(compressedData);

      print(
          "Compressed image saved at: ${tempFile.path} with size: ${tempFile.lengthSync()} bytes");

      // Check if the compressed image size is below 0.5MB
      if (tempFile.lengthSync() <= 0.5 * 1024 * 1024) {
        return tempFile;
      }

      // Reduce quality for the next iteration
      quality -= 10;
      if (quality < 10) {
        print("Quality is too low, stopping further compression.");
        break;
      }

      print(
          "Compressed size is still too large, reducing quality to $quality.");
    } while (true);
    print("Compression completed. Final file path: ${tempFile.path}");
    print("Final file size: ${tempFile.lengthSync()} bytes");
    return tempFile;
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();

    try {
      // Check if the platform is iOS and source is gallery
      if (defaultTargetPlatform == TargetPlatform.iOS &&
          source == ImageSource.gallery) {
        // Directly open the photo album for iOS
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null && mounted) {
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          await simulateLoadingAndCompress(imageBytes);
        }
        return;
      }

      // Default behavior for other platforms or sources
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        await simulateLoadingAndCompress(imageBytes);
      }
    } catch (e) {
      // Handle exceptions
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> getImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        await simulateLoadingAndCompress(imageBytes);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  List<String> getTips(BuildContext context) {
    return [
      "",
      'tip_1'.tr(),
      "",
      'tip_2'.tr(),
      "",
      'tip_3'.tr(),
      "",
      'tip_4'.tr(),
    ];
  }

  Future<void> showAlertAndProceed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSecondTimeUser = prefs.getBool('isSecondTimeUser') ?? false;

    if (!isSecondTimeUser)
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            icon: Icon(
              FeatherIcons.alertTriangle,
              color: Colors.redAccent,
              size: 45,
            ),
            title: Text(
              'Tips',
              textAlign: TextAlign.center,
              style: AppFonts.title(context),
            ),
            content: Text(
              getTips(context).map((tip) => '$tip\n').join(),
              textAlign: TextAlign.center,
              style: AppFonts.contentWarning(context),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            actions: <Widget>[
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 55,
                  width: MediaQuery.of(context).size.width - 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'confirm',
                        style: AppFonts.button(
                            Theme.of(context).colorScheme.background, context),
                      ).tr(),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      );

    // Update `isFirstTimeVisit` to true after showing the dialog
    if (!isSecondTimeUser) {
      await prefs.setBool('isSecondTimeUser', true);
    }

    print(isSecondTimeUser);

    // Proceed with picking or deleting an image
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: (kIsWeb)
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height * 0.28,
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Handle on top
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(height: 17),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await getImage(context, ImageSource.gallery);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FeatherIcons.image,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('select_image',
                                style: AppFonts.button2(context))
                            .tr(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await getImageFromCamera(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FeatherIcons.camera,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('open_camera',
                                style: AppFonts.button2(context))
                            .tr(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.trash2,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('cancel',
                                style: AppFonts.cancelButton(context))
                            .tr(),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),
              Text('beta', style: AppFonts.warning(context)).tr(),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await showAlertAndProceed(context),
      child: Container(
        height: 55,
        width: 260,
        decoration: BoxDecoration(
          color: widget.isCouple
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isLoading) // 로딩 중일 때 애니메이션과 텍스트 표시
              Stack(
                children: [
                  // 배경 컨테이너
                  Container(
                    height: 55,
                    width: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[300],
                    ),
                  ),
                  // 진행률 애니메이션
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 55,
                    width: 260 * _progress,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                  ),
                  // 텍스트
                  Center(
                    child: Text(
                      'compressing_photo',
                      style: AppFonts.button(
                          Theme.of(context).colorScheme.background, context),
                    ).tr(),
                  ),
                ],
              ),
            if (!_isLoading && widget.imageBytes != null)
              FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    widget.imageBytes!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            if (!_isLoading && widget.imageBytes == null)
              Text(
                widget.isCouple
                    ? 'add_couple_photo'
                    : widget.isMe
                        ? 'add_my_photo'
                        : 'add_partner_photo',
                style: AppFonts.button(
                    (widget.isCouple)
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.outline,
                    context),
              ).tr(),
          ],
        ),
      ),
    );
  }
}
