import 'package:grpc/grpc.dart';

import 'package:grpc_demo/grpc_demo.dart';

void main() async {
  final channel = ClientChannel(
    'localhost',
    port: 5000,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  final stub = AlbumServiceClient(channel);

  // var response = await stub.getAlbums(AlbumRequest());
  // print('Response received: ${response.writeToJson()}');
  //
  // response = await stub.getAlbums(AlbumRequest()..id = 1);
  // print('Response received: ${response.writeToJsonMap()}');

  // var response2 = await stub.getAlbumsWithPhotos(AlbumRequest()..id = 3);
  // print('Got response! ${response2}');

  var photoStream = stub.getPhotos(AlbumRequest());

  await for (var photo in photoStream) {
    print('Received photo! ${photo.url}');
  }

  await channel.shutdown();
}