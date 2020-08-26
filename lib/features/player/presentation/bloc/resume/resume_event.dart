part of 'resume_bloc.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object> get props => [];
}

class Restart extends ResumeEvent {
  final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<int> replicGap;
  final BehaviorSubject<bool> player;
  final List<Replic> replics;
  final String songPath;
  final Stream<MidiEventEntity> onMidiEvents;

  const Restart({
    this.volumeMusic,
    this.volumeReplic,
    this.replicGap,
    this.replics,
    this.songPath,
    this.player,
    this.onMidiEvents,
  });

  @override
  List<Object> get props => [
        volumeMusic,
        volumeReplic,
        replicGap,
        replics,
        songPath,
        player,
        onMidiEvents,
      ];
}
