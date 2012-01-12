#!jruby
#
# Usage: jruby change-keyboard-into-piano.rb

include Java

import java.awt.event.KeyEvent
import javax.sound.midi.ShortMessage
import javax.swing.JFrame

class ChangeKeyboardIntoPiano
  include java.awt.event.KeyListener
  include java.lang.Runnable

  def initialize
    @synth = nil
    @lastNote = 0
    @msg = ShortMessage.new
  end

  def setup
    @synth = javax.sound.midi.MidiSystem.getSynthesizer
    @synth.open
  end

  def noteOn(note)
    noteOff
    @msg.setMessage(ShortMessage::NOTE_ON, 0, note, 64)
    @synth.getReceiver.send(@msg, -1)
    @lastNote = note
  end

  def noteOff
    if @lastNote < 0
      return
    end
    @msg.setMessage(ShortMessage::NOTE_OFF, 0, @lastNote, 64)
    @synth.getReceiver.send(@msg, -1)
    @lastNote = -1
  end

  def createAndShowGui
    frame = newFrame
    frame.setVisible(true)
  end

  def newFrame
    frame = JFrame.new("ChangeKeyboardIntoPiano")
    frame.addKeyListener(self)
    frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    frame.setContentPane(newPane)
    frame.pack
    return frame
  end

  def newPane
    pane = javax.swing.JPanel.new
    pane.setPreferredSize(java.awt.Dimension.new(320, 240))
    return pane
  end

  def keyPressed(event)
    code = event.getKeyCode
    if code == KeyEvent::VK_SPACE
      noteOff
      return
    end
    note = keyCodeToNote(code)
    if note >= 0
      noteOn(note)
    end
  end

  def keyReleased(event); end
  def keyTyped(event); end

  def keyCodeToNote(keyCode)
    case keyCode
      when KeyEvent::VK_D
      return 60
    when KeyEvent::VK_F
      return 62
    when KeyEvent::VK_G
      return 64
    when KeyEvent::VK_H
      return 65
    when KeyEvent::VK_J
      return 67
    when KeyEvent::VK_K
      return 69
    when KeyEvent::VK_L
      return 71
    when KeyEvent::VK_SEMICOLON
      return 72
    else
      return -1
    end
  end

  def run
    createAndShowGui
  end
end

if $0 == __FILE__
  app = ChangeKeyboardIntoPiano.new
  app.setup
  javax.swing.SwingUtilities.invokeLater(app)
end
