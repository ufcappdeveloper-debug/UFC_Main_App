import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

// class ChatSocketManager {
//   static final ChatSocketManager _instance = ChatSocketManager._internal();
//   factory ChatSocketManager() => _instance;
//   ChatSocketManager._internal();

//   static final Socket _socket = io(
//     AppConfig.chatBaseUrl,
//     OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .enableForceNewConnection()
//         .build(),
//   );

//   static final StreamController<dynamic> chatUpdatesController =
//       StreamController.broadcast();

//   static void emit(String event, dynamic data) {
//     _socket.emit(event, data);
//   }

//   static void joinRoom(String roomId) {
//     _socket.emit("joinRoom", {"room": roomId});
//   }

//   static void leaveRoom(String roomId) {
//     _socket.emit("leaveRoom", {"room": roomId});
//   }

//   static void init() {
//     _socket.connect();

//     _socket.onConnect((_) {
//       debugLog('Chat Socket connected ✅');
//     });

//     _socket.onReconnect((_) {
//       debugLog('Chat Socket reconnected 🔁');
//     });

//     _socket.onDisconnect((_) {
//       _socket.destroy();
//       _socket.dispose();
//       _socket.disconnect();
//       debugLog('Chat Socket disconnected ❌');
//     });

//     _socket.on('receiveMessage', (data) {
//       chatUpdatesController.add(data);
//     });
//   }

//   static Stream<dynamic> get chatStream => chatUpdatesController.stream;

//   static void dispose() {
//     chatUpdatesController.close();
//   }
// }

class ChatSocketManager {
  static final ChatSocketManager _instance = ChatSocketManager._internal();
  factory ChatSocketManager() => _instance;
  ChatSocketManager._internal();

  static final Socket _socket = io(
    AppConfig.chatBaseUrl,
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableForceNewConnection()
        .build(),
  );

  static final StreamController<dynamic> chatUpdatesController =
      StreamController.broadcast();

  static bool isConnected = false;

  static void emit(String event, dynamic data) {
    if (isConnected) {
      _socket.emit(event, data);
    } else {
      debugLog('Socket not connected. Cannot emit event.');
    }
  }

  static void joinRoom(String roomId, String userId) {
    if (isConnected) {
      _socket.emit("joinRoom", {"room": roomId, "user_id": userId});
    } else {
      debugLog('Socket not connected. Cannot join room.');
    }
  }

  static void leaveRoom(String roomId, String userId) {
    if (isConnected) {
      _socket.emit("leaveRoom", {"room": roomId, "user_id": userId});
    } else {
      debugLog('Socket not connected. Cannot leave room.');
    }
  }

  static void init() {
    if (!isConnected) {
      _socket.connect();

      _socket.onConnect((_) {
        isConnected = true;
        debugLog('Chat Socket connected ✅');
      });

      _socket.onReconnect((_) {
        isConnected = true;
        debugLog('Chat Socket reconnected 🔁');
      });

      _socket.onDisconnect((_) {
        isConnected = false;
        debugLog('Chat Socket disconnected ❌');
      });

      _socket.on('receiveMessage', (data) {
        chatUpdatesController.add(data);
      });
    }
  }

  static Stream<dynamic> get chatStream => chatUpdatesController.stream;

  static void dispose() {
    if (isConnected) {
      _socket.disconnect();
      isConnected = false;
      debugLog('Chat Socket disconnected ❌');
    }
    chatUpdatesController.close();
  }
}
