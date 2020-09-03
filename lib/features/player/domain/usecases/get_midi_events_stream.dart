import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';
import 'package:rxdart/rxdart.dart';

class GetMidiEventsStream
    extends UseCase<Stream<MidiEventEntity>, GetMidiEventsStreamParams> {
  final AudioDataRepository _repository;

  GetMidiEventsStream(this._repository);

  @override
  Future<Either<Failure, Stream<MidiEventEntity>>> call(
      GetMidiEventsStreamParams params) {
    return _repository.getMidiEventsStream(
        midiFilePath: params.midiFilePath,
        playButton: params.playButton,
        refresh: params.refresh);
  }
}

class GetMidiEventsStreamParams {
  final String midiFilePath;
  final BehaviorSubject<bool> playButton;
  final bool refresh;

  GetMidiEventsStreamParams({this.midiFilePath, this.playButton, this.refresh});
}
