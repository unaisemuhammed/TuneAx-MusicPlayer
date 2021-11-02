import 'package:flutter/material.dart';
import 'package:musicplayer/colors.dart' as app_colors;

class Folder extends StatefulWidget {
  const Folder({Key? key}) : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.back,
        body: Container(
          child: ListView(
            children: [
              ListTile(
                // dense: true,
                leading: Container(
                  child: const Icon(
                    Icons.folder_open,
                    size: 30,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(
                      color: app_colors.back,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  width: width / 8,
                  height: heights / 14,
                ),
                title: const Text(
                  'Internal Storage',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,maxLines: 1,
                ),subtitle: const Text(
                '/InternalStorage',
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,maxLines: 1,
              ),
              ),
              const Divider(
                height: 0,
                indent: 85,
                color: Colors.grey,
              ),    ListTile(
                // dense: true,
                leading: Container(
                  child: const Icon(
                    Icons.folder_open,
                    size: 30,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(
                      color: app_colors.back,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  width: width / 8,
                  height: heights / 14,
                ),
                title: const Text(
                  'WhatsApp Audio',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,maxLines: 1,
                ),subtitle: const Text(
                'InternalStorage/Whatsapp/Media/WhatsAppAudio',
                overflow: TextOverflow.ellipsis,maxLines: 1,
                style: TextStyle(color: Colors.grey),
              ),
              ),
              const Divider(
                height: 0,
                indent: 85,
                color: Colors.grey,
              ),
            ],
          ),
          decoration: const BoxDecoration(
              // color: AppColors.shade,
              color: app_colors.shade),
          height: heights,
          width: width,
        ),
      ),
    );
  }
}
