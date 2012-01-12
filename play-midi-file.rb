#!jruby
#
# usage: jruby play-midi-file.rb midifile
#        Ctrl-C to stop the program.

include Java

import javax.sound.midi.MidiSystem

synth = MidiSystem.getSynthesizer
seq = MidiSystem.getSequencer
seq.getTransmitter.setReceiver(synth.getReceiver)
synth.open
seq.open
seq.setSequence(java.io.FileInputStream.new(ARGV[0]))
seq.start
