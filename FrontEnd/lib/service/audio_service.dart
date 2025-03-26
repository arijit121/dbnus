import 'package:audioplayers/audioplayers.dart';

import '../extension/logger_extension.dart';

class AudioService {
  // Private constructor for singleton
  AudioService._internal();

  // Singleton instance
  static final AudioService _instance = AudioService._internal();

  static AudioService getInstance = _instance;

  AudioPlayer? _audioPlayer;

  /// Stop any currently playing audio and create a new player
  Future<void> _initNewPlayer() async {
    try {
      await _audioPlayer?.stop(); // Stop existing player if playing
      await _audioPlayer?.dispose(); // Dispose existing player
      _audioPlayer = AudioPlayer(); // Create new instance
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e,
          stackTrace: stacktrace,
          tag: "Error initializing new player");
    }
  }

  /// Play audio from assets
  Future<void> playFromAsset(String assetPath, {bool loop = false}) async {
    try {
      await _initNewPlayer();
      await _audioPlayer?.play(AssetSource(assetPath));
      _setLoopMode(loop);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e,
          stackTrace: stacktrace,
          tag: "Error playing asset: $assetPath");
    }
  }

  /// Play audio from a file
  Future<void> playFromFile(String filePath, {bool loop = false}) async {
    try {
      await _initNewPlayer();
      await _audioPlayer?.play(DeviceFileSource(filePath));
      _setLoopMode(loop);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e,
          stackTrace: stacktrace,
          tag: "Error playing file: $filePath");
    }
  }

  /// Play audio from a network URL
  Future<void> playFromUrl(String url, {bool loop = false}) async {
    try {
      await _initNewPlayer();
      await _audioPlayer?.play(UrlSource(url));
      _setLoopMode(loop);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error playing URL: $url");
    }
  }

  /// Pause the current audio
  Future<void> pause() async {
    try {
      await _audioPlayer?.pause();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error pausing audio");
    }
  }

  /// Resume the paused audio
  Future<void> resume() async {
    try {
      await _audioPlayer?.resume();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error resuming audio");
    }
  }

  /// Stop the current audio
  Future<void> stop() async {
    try {
      await _audioPlayer?.stop();
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error stopping audio");
    }
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer?.seek(position);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error seeking audio");
    }
  }

  /// Set the audio volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer?.setVolume(volume);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error setting volume");
    }
  }

  /// Get current audio position
  Stream<Duration>? get onPositionChanged => _audioPlayer?.onPositionChanged;

  /// Get audio completion event
  Stream<void>? get onComplete => _audioPlayer?.onPlayerComplete;

  /// Set loop mode
  void _setLoopMode(bool loop) {
    try {
      _audioPlayer?.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e, stackTrace: stacktrace, tag: "Error setting loop mode");
    }
  }

  /// Dispose the audio player
  Future<void> dispose() async {
    try {
      await _audioPlayer?.dispose();
      _audioPlayer = null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(),
          error: e,
          stackTrace: stacktrace,
          tag: "Error disposing audio player");
    }
  }
}
