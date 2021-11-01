import 'package:flutter/material.dart';
import 'package:musicplayer/colors.dart' as AppColors;

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
        backgroundColor: AppColors.back,
        body: Container(
          child: ListView(
            children: [
              ListTile(
                // dense: true,
                leading: Container(
                  child: Icon(
                    Icons.folder_open,
                    size: 30,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.back,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  width: width / 8,
                  height: heights / 14,
                ),
                title: Text(
                  "Internal Storage",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,maxLines: 1,
                ),subtitle: Text(
                "/InternalStorage",
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,maxLines: 1,
              ),
              ),
              Divider(
                height: 0,
                indent: 85,
                color: Colors.grey,
              ),    ListTile(
                // dense: true,
                leading: Container(
                  child: Icon(
                    Icons.folder_open,
                    size: 30,
                    color: Colors.grey,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.back,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  width: width / 8,
                  height: heights / 14,
                ),
                title: Text(
                  "WhatsApp Audio",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,maxLines: 1,
                ),subtitle: Text(
                "InternalStorage/Whatsapp/Media/WhatsAppAudio",
                overflow: TextOverflow.ellipsis,maxLines: 1,
                style: TextStyle(color: Colors.grey),
              ),
              ),
              Divider(
                height: 0,
                indent: 85,
                color: Colors.grey,
              ),
            ],
          ),
          decoration: BoxDecoration(
              // color: AppColors.shade,
              color: AppColors.shade),
          height: heights,
          width: width,
        ),
      ),
    );
    ;
  }
}
