module LESSON-02-D

  syntax Color ::= Yellow()
                 | Blue()
                 | Green()
                 | Black()
                 | colorOf(Fruit) [function]
  syntax Fruit ::= Banana()
                 | Blueberry()
                 | Blackberry()
                 | Kiwi()

  rule colorOf(Banana()) => Yellow()
  rule colorOf(Blueberry()) => Blue()
  rule colorOf(Blackberry()) => Black()
  rule colorOf(Kiwi()) => Green()

endmodule

// kompile lesson-02-d.k 
// krun -cPGM='colorOf(Blackberry())' --definition 'lesson-02-d-kompiled'
// krun -cPGM='colorOf(Kiwi())' --definition 'lesson-02-d-kompiled'
