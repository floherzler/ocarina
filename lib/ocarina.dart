import 'dart:async';

import 'package:flutter/services.dart';

class OcarinaPlayer {
  static const MethodChannel _channel =
      const MethodChannel('ocarina');

  /// Player id
  int _id;
  double volume;
  final bool loop;

  String asset;
  String filePath;

  OcarinaPlayer({
    this.asset,
    this.filePath,

    this.volume = 1.0,
    this.loop = false,
  }) {
    assert(
        (asset != null && filePath == null) || (asset == null && filePath != null),
        'You need to specify an assert, OR filePath, not both, or neither'
    );
  }

  /// Loads your asset or file, no other operation can be performed on this instance before this is called
  Future<void> load() async {
    _id = await  _channel.invokeMethod('load', {
      'url': asset ?? filePath,
      'volume': volume,
      'loop': loop,
      'isAsset': asset != null,
    });
  }

  Future<void> play() async {
    _ensureLoaded();
    await _channel.invokeMethod('play', { 'playerId': _id });
  }

  Future<void> pause() async {
    _ensureLoaded();
    await _channel.invokeMethod('pause', { 'playerId': _id });
  }

  Future<void> resume() async {
    _ensureLoaded();
    await _channel.invokeMethod('resume', { 'playerId': _id });
  }

  Future<void> stop() async {
    _ensureLoaded();
    await _channel.invokeMethod('stop', { 'playerId': _id });
 }

  Future<void> seek(Duration duration) async {
    _ensureLoaded();
    await _channel.invokeMethod('seek', { 'playerId': _id, 'position': duration.inMilliseconds });
 }

  Future<void> updateVolume(double volume) async {
    _ensureLoaded();
    await _channel.invokeMethod('volume', { 'playerId': _id, 'volume': volume });
 }

  void _ensureLoaded() {
    assert(_id != null, 'Player is not loaded yet, you must call load before.');
  }
}
