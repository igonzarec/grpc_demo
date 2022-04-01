import 'package:grpc_demo/grpc_demo.dart';
import 'package:protobuf/protobuf.dart';

void main(List<String> arguments) {
  final album = Album()
    ..id = 1
    ..title = 'Album title';

  final album2 =
      Album.fromJson('{"1": ${albums[0]['id']}, "2": "${albums[0]['title']}"}');

  print(album);
  print("------------");
  print(album2);
  print(album2.clone());
  print("------------");
  print(album2.copyWith((album2) {
    album2.setField(2, 'album title updated');
  }));
  print("------------");
  print(album2.writeToJson());
}
