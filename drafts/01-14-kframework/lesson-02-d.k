module LESSON-02-D

  syntax Color ::= Yellow()
                 | Blue()
                 | Kiwi()
                 | colorOf(Fruit) [function]
  syntax Fruit ::= Banana()
                 | Blueberry()

  rule colorOf(Banana()) => Yellow()
  rule colorOf(Blueberry()) => Blue()

endmodule