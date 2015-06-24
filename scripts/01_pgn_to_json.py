import json
import time
import chess.pgn


# I prefer running in sublimetext instead RStudio (system can)
pgn = open("../data/sample.pgn")
fout = open("../data/sample.json", "w")

t0 = time.clock()

count = 0
node = chess.pgn.read_game(pgn)

while node != None:

  info =  node.headers
  info["fen"] = []
  info["pgn"] = []

  while node.variations:
    next_node = node.variation(0)
    info["fen"].append(node.board().fen())
    info["pgn"].append(node.board().san(next_node.move))
    node = next_node

  info["fen"].append(node.board().fen())
  node = chess.pgn.read_game(pgn)

  json.dump(info, fout, encoding="latin1")
  fout.write("\n")
  count += 1
  
  if(count % 10 == 0):
    print count, "games in", int((time.clock() - t0)), "seconds"

fout.close()

print "ready",  count, "games.", (time.clock() - t0)/count, "seconds per game"
