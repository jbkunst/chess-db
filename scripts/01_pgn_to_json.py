# Converts the millionbase chess PGN database (http://www.top-5000.nl/pgn.htm) to json
# with one json dictionary per row. (That is, the resulting file is contain multiple json objects, 
# not just one large).

import json
import chess.pgn # From python-chess https://github.com/niklasf/python-chess

pgn = open("../data/KingBaseLite2015-05-A80-A99.pgn") # Or where you have put it
fout = open('../data/KingBaseLite2015-05-A80-A99.json', 'w') # Or where you want it

count = 0
node = chess.pgn.read_game(pgn)
while node != None:
  info =  node.headers
  info["fen"] = []
  while node.variations:
    next_node = node.variation(0)
    info["fen"].append(node.board().fen())
    node = next_node
  info["fen"].append(node.board().fen())
  node = chess.pgn.read_game(pgn)
  json.dump(info, fout, encoding='latin1')
  fout.write('\n')
  count += 1
  if(count % 100 == 0):
    print(count)

fout.close()
print "ready"
