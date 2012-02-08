include Java

import javax.sound.midi.MetaEventListener
import javax.sound.midi.MidiEvent
import javax.sound.midi.MidiSystem
import javax.sound.midi.Sequence
import javax.sound.midi.ShortMessage

class Metronome
  include MetaEventListener

  def initialize
    @sequencer = nil
    @bpm = 60
  end

  def start(bpm)
    @bpm = bpm
    openSequencer
    seq = createSequence
    startSequence(seq)
  end

  def openSequencer
    @sequencer = MidiSystem::getSequencer
    @sequencer.open
    @sequencer.addMetaEventListener(self)
  end

  def createSequence
    seq = Sequence.new(Sequence::PPQ, 1)
    track = seq.createTrack
    msg = ShortMessage.new(ShortMessage::PROGRAM_CHANGE, 9, 1, 0)
    evt = MidiEvent.new(msg, 0)
    track.add(evt)

    addNoteEvent(track, 0)
    addNoteEvent(track, 1)
    addNoteEvent(track, 2)
    addNoteEvent(track, 3)

    msg = ShortMessage.new(ShortMessage::PROGRAM_CHANGE, 9, 1, 0)
    evt = MidiEvent.new(msg, 4)
    track.add(evt)
    return seq
  end

  def addNoteEvent(track, tick)
    message = ShortMessage.new(ShortMessage::NOTE_ON, 9, 37, 100)
    event = MidiEvent.new(message, tick)
    track.add(event)
  end

  def startSequence(seq)
    @sequencer.setSequence(seq)
    @sequencer.setTempoInBPM(@bpm)
    @sequencer.start
  end

  def meta(message)
    return if message.getType != 47 # end of track
    doLoop
  end

  def doLoop
    return if !@sequencer || !@sequencer.isOpen
    @sequencer.setTickPosition(0)
    @sequencer.start
    @sequencer.setTempoInBPM(bpm)
  end
end

if $0 == __FILE__
  bpm = 60
  bpm = ARGV[0].to_i if ARGV.size > 0
  bpm = 60 if bpm == 0
  Metronome.new.start(bpm)
end
