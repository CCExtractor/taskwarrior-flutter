import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:pem/pem.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class PemWidget extends StatelessWidget {
  const PemWidget({
    required this.storage,
    required this.pem,
    super.key,
    required this.optionString,
    required this.listTileTitle,
    required this.onTapCallBack,
    required this.onLongPressCallBack,
    required this.globalKey,
    // required this.manageTaskServerController,
  });

  final Storage storage;
  final String pem;
  final String optionString;
  final String listTileTitle;
  final Function(String pem, Storage storagePem) onTapCallBack;
  final Function(String pem, String? name) onLongPressCallBack;
  final GlobalKey globalKey;
  // final ManageTaskServerController manageTaskServerController;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    String fingerprint(String pemContents) {
      var firstCertificateBlock = decodePemBlocks(
        PemLabel.certificate,
        pemContents,
      ).first;

      return '${sha1.convert(firstCertificateBlock)}';
    }

    var contents = storage.guiPemFiles.pemContents(pem);
    var name = storage.guiPemFiles.pemFilename(pem);
    String identifier = "";
    try {
      if (contents != null) {
        identifier = fingerprint(contents).toUpperCase(); // Null check removed
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    var tileColor = tColors.primaryBackgroundColor;
    return Padding(
      key: globalKey,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            optionString,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              onTapCallBack(pem, storage);
            },
            // onTap: () {
            //   manageTaskServerController.onTapPEMWidget(pem, storage);
            // },
            // onTap: (pem == 'server.cert')
            //     ? () {
            //         widget.storage.guiPemFiles.removeServerCert();
            //         ProfilesWidget.of(context).setState(
            //           () {},
            //         );
            //         setState(
            //           () {},
            //         );
            //       }
            //     : () async {
            //         await setConfig(
            //           storage: widget.storage,
            //           key: widget.pem,
            //         );
            //         setState(
            //           () {},
            //         );
            //       },
            // onLongPress: () {
            //   manageTaskServerController.onLongPressPEMWidget(pem, name);
            // },
            onLongPress: () {
              onLongPressCallBack(pem, name);
            },
            // onLongPress: (widget.pem != 'server.cert' && name != null)
            //     ? () {
            //         widget.storage.guiPemFiles.removePemFile(widget.pem);
            //         setState(() {});
            //       }
            //     : null,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TaskWarriorColors.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            name == null
                                ? listTileTitle
                                : (pem == 'server.cert')
                                    ? ''
                                    : "$name = ",
                            style: TextStyle(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                          Text(
                            pem == 'taskd.key'
                                ? name != null
                                    ? "private.key.pem"
                                    : ""
                                : identifier,
                            style: TextStyle(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: tColors.secondaryTextColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: name == null
                          ? Icon(
                              Icons.chevron_right_rounded,
                              color: tColors.secondaryBackgroundColor,
                            )
                          : Icon(
                              Icons.check,
                              color: TaskWarriorColors.green,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
