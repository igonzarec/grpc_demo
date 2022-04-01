import 'package:grpc/grpc.dart';
import 'package:grpc_demo/grpc_demo.dart';

class AlbumService extends AlbumServiceBase {
  @override
  Future<AlbumResponse> getAlbums(
      ServiceCall call, AlbumRequest request) async {
    if (request.id > 0) {
      final album = findAlbums(request.id);
      return AlbumResponse()..albums.addAll(album);
    }

    final albumList = albums.map(convertToAlbum).toList();
    return AlbumResponse()..albums.addAll(albumList);
  }

  @override
  Future<AlbumResponse> getAlbumsWithPhotos(
      ServiceCall call, AlbumRequest request) async {
    return AlbumResponse()
      ..albums.addAll(albums.map((json) {
        final album = convertToAlbum(json);
        final albumPhotos = findPhotos(album.id);
        return album..photos.addAll(albumPhotos);
      }));
    throw UnimplementedError();
  }

  @override
  Stream<Photo> getPhotos(ServiceCall call, AlbumRequest request) async* {
    var photoList = photos;

    for (final photo in photoList) {
      yield Photo.fromJson('''{
      "1": ${photo['albumId']}, 
      "2": ${photo['id']}, 
      "3": "${photo['title']}", 
      "4": "${photo['url']}"
      }''');
    }
    // for (final photo in photoList) {
    //   yield Photo.fromJson('''{
    //       "1": ${photo['albumId']},
    //       "2": ${photo['id']},
    //       "3": "${photo['title']}",
    //       "4": "${photo['url']}"
    //     }''');
    // }
  }
}

// helpers
List<Photo> findPhotos(int id) {
  return photos
      .where((element) => element['albumId'] == id)
      .map(convertToPhoto)
      .toList();
}

Photo convertToPhoto(Map photo) => Photo.fromJson(
    '{"1": ${photo['albumId']}, "2": ${photo['id']}, "3": "${photo['title']}", "4": "${photo['url']}"}');

List<Album> findAlbums(int id) {
  return albums
      .where((element) => element['id'] == id)
      .map(convertToAlbum)
      .toList();
}

Album convertToAlbum(Map album) =>
    Album.fromJson('{"1": "${album['id']}", "2": "${album['title']}"}');

void main() async {
  final server = Server([AlbumService()]);
  await server.serve(port: 5000);
  print('Server listening on port: ${server.port}');
}
