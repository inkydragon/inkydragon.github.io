module LESSON-02-EX2

  syntax Color ::= White() | Black()
  // hat, shirt, pants, and shoes
  syntax Hat ::= Hat(Color)
  syntax Shirt ::= Shirt(Color)
  syntax Pants ::= Pants(Color)
  syntax Shoe ::= Shoe(Color)
  // outfit 
  syntax Outfit ::= Outfit(Hat, Shirt, Pants, Shoe)
  syntax Boolean ::= True() | False()
    | outfitMatching(Outfit) [function]

  rule outfitMatching(Outfit(Hat(White()), Shirt(White()), Pants(White()), Shoe(White()))) => True()
  rule outfitMatching(Outfit(Hat(Black()), Shirt(Black()), Pants(Black()), Shoe(Black()))) => True()

endmodule

// kompile lesson-02-ex2.k 
// krun -cPGM='outfitMatching(Outfit(Hat(White()), Shirt(White()), Pants(White()), Shoe(White())))' --definition 'lesson-02-ex2-kompiled'
// krun -cPGM='outfitMatching(Outfit(Hat(Black()), Shirt(Black()), Pants(Black()), Shoe(Black())))' --definition 'lesson-02-ex2-kompiled'
// krun -cPGM='outfitMatching(Outfit(Hat(Black()), Shirt(White()), Pants(White()), Shoe(White())))' --definition 'lesson-02-ex2-kompiled'
