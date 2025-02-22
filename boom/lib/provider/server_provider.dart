import 'dart:io';

import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_provider.g.dart';

class ServerState {
  int port;
  HttpServer httpServer;
  ServerState({
    required this.port,
    required this.httpServer,
  });
}

@Riverpod(keepAlive: true)
class Server extends _$Server {
  Function(List<int>) _listenner = (data) {};
  final Map<String, WebSocketChannel> _channels = {};
  @override
  ServerState? build() {
    return null;
  }

  /// Starts the server from user settings.
  Future<ServerState?> startServerFromSettings() async {
    return startServer(
      port: ref.read(configureProvider).port,
    );
  }

  void listen(Function(List<int>) callback) {
    _listenner = callback;
  }

  void send(String id, List<int> data) {
    var channel = _channels[id];
    if (channel != null) {
      channel.sink.add(data);
    }
  }

  // Starts the server.
  Future<ServerState?> startServer({required int port}) async {
    if (state != null) {
      return state;
    }

    if (port < 0 || port > 65535) {
      port = 8989;
    }

    Router router = Router();
    router.get("/info", (RequestContext context) {
      return Response.json(
          body: {'port': port.toString(), 'type': '局域网服务', 'ip': ''});
    });

    router.get("/register", (RequestContext context) {
      final params = context.request.uri.queryParameters;
      final id = params['id'] ?? '';
      if (id == '') {
        return Response(statusCode: 400);
      }

      final handler = webSocketHandler(
        (channel, protocol) {
          _channels[id] = channel;
          channel.stream.listen((event) {
            var body = Body.fromBuffer(event);
            if (body.to == ref.read(configureProvider).deviceId) {
              _listenner(event);
            } else {
              send(body.to, event);
            }
          });
        },
      );
      return handler(context);
    });

    ServerState? newServerState;

    newServerState = ServerState(
      httpServer: await _startServer(
        router: router.call,
        port: port,
      ),
      port: port,
    );

    state = newServerState;
    return newServerState;
  }

  Future<void> stopServer() async {
    await state?.httpServer.close(force: true);
    state = null;
  }

  Future<ServerState?> restartServerFromSettings() async {
    await stopServer();
    return await startServerFromSettings();
  }
}

Future<HttpServer> _startServer({
  required FutureOr<Response> Function(RequestContext context) router,
  required int port,
}) async {
  return serve(router.call, '0.0.0.0', port);
}
