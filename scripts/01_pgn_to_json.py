import json
import time
import chess.pgn

pgn = open("../data/KingBaseLite2015-05-A80-A99.pgn")
fout = open('../data/KingBaseLite2015-05-A80-A99.json', 'w')

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

  json.dump(info, fout, encoding='latin1')
  fout.write('\n')
  count += 1
  
  if(count % 10 == 0):
    print(count)

fout.close()

print (time.clock() - t0)/count, "seconds per game"
print "ready " + str(count) + " games"