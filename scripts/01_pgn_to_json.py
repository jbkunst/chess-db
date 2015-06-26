'''
Original script by rasmusab: https://gist.github.com/rasmusab/07f1823cb4bd0bc7352d.
I made some changes to add the 'san' moves and the posibility to
convert various pgn files given a 'pattern' in the 'data' folder.
'''
import json
import time
import chess.pgn
import glob
import os
# I prefer running in sublimetext instead RStudio because
# I cant put 'verbose' to get prints

# Data is from http://www.kingbase-chess.net/ or/and www.top-5000.nl/pgn.htm

pattern = "KingBaseLite" #"millionbase" #"KingBaseLite" # 

pgns = glob.glob("../data/" + pattern + "*.pgn")
pgns = [pgn.replace("\\", "/") for pgn in pgns] # Maybe this is for windows

print pgns

t0 = time.clock()

max_pgn_per_file = 1000

count = 0

fout = open("../data/" + pattern + ".json", "w")

for pgn_path in pgns:

    print "processing ", pgn_path

    pgn = open(pgn_path)

    inner_count = 0

    node = chess.pgn.read_game(pgn)

    while node != None:

      if inner_count == max_pgn_per_file:
        count = count + inner_count
        break

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
      inner_count += 1
      
      if(inner_count % 10 == 0):
        print inner_count, "games in", int((time.clock() - t0)), "seconds"

fout.close()

print "ready",  count, "games.", (time.clock() - t0)/count, "seconds per game"