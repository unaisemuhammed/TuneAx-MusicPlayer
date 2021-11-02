
class PlaylistModel {
  int? id;
  String playListName;

  List<PlayListSong> playListSongs = [];

  //TABLE COLUMNS
  static String tableName = 'playlist';
  static String columnId = 'id';
  static String columnPlayListName = 'playlistName';

  PlaylistModel({
    this.id,
    required this.playListName,
  });

  PlaylistModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        playListName = res['playListName'];

  Map<String, dynamic> toMapForDB() {
    return {
      columnId: id,
      columnPlayListName: playListName,
    };
  }

 void setSongsInPlaylist(List<PlayListSong> songsList) {
    playListSongs.clear();
    playListSongs.addAll(songsList);
  }
}

class PlayListSong {
  int? id;
  int songID;
  int playlistID;
  String songName;
  String path;

  static String ids = 'id';
  static String songId = 'songID';
  static String playlistsID = 'playlistID';
  static String songsName = 'songName';
  static String songPath = 'path';

  PlayListSong(
      {this.id,
      required this.songID,
      required this.playlistID,
      required this.songName,
      required this.path});

  PlayListSong.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        songID = res['songID'],
        playlistID = res['playlistID'],
        songName = res['songName'],
        path = res['path'];

  Map<String, dynamic> toMapForDB() {
    return {
      ids: id,
      songId: songID,
      playlistsID: playlistID,
      songsName: songName,
      songPath: path,
    };
  }

//add variables methods similar to the above class
}
