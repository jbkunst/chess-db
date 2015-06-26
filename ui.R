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
    column(6,
           fluidRow(
             column(12, chessboardOutput("board1", width = "200px")),
             column(12, chessboardOutput("board2", width = "200px")),
             column(12, chess("board3", width = "200px"))
             )
           )
    )
  
)
