shinyServer(function(input, output) {

  output$board <- renderChessboard({
    chessboard()
  })
  
  output$board1 <- renderChessboard({
    chessboard("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
  })
  
  output$board2 <- renderChessboard({
    chessboard("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
  })
  
  output$board3 <- renderChessboard({
    chessboard("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
  })
  
})
