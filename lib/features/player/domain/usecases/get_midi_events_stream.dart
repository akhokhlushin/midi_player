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
      replicGap: params.onReplicGapChange,
      playButton: params.playButton,
    );
  }
}

class GetMidiEventsStreamParams {
  final String midiFilePath;
  final BehaviorSubject<int> onReplicGapChange;
  final BehaviorSubject<bool> playButton;

  GetMidiEventsStreamParams(
      {this.midiFilePath, this.onReplicGapChange, this.playButton});
}
