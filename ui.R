bootstrapPage(
  title = "Playing Chess",
  theme = "https://bootswatch.com/paper/bootstrap.min.css",
  
  fluidRow(
    column(6, h1("Hi")),
    column(6, h1("Bye")),
    column(12, hr())
    ),
  
  fluidRow(
    column(6, chessboardOutput("board", width = "400px")),
    column(12,
           fluidRow(
             column(3, chessboardOutput("board1", width = "100%")),
             column(3, chessboardOutput("board2", width = "100%")),
             column(3, chessboardOutput("board3", width = "100%")),
             column(3, chessboardOutput("board4", width = "100%"))
             )
           )
    )
  
)
