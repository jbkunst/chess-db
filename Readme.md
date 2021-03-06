# Chess-db

Scripts for parse pgns files into a sqlite (tsv, RData) database/table.

## How to use

- Download a "chess database". For example you can download a big list of pgn from http://www.kingbase-chess.net/.
- Put all the pgn files in the `data-raw` folder.
- Then run the R scripts.
- If you have a humble pc wait for 2-3 hours (if you download the 1.6M DB).
- And enjoy your chess database ;) in sqslite, Rdata, tsv format!

## Input

The input is a big list of pgns like this:

```
[Event "22. Abu Dhabi Masters"]
[Site "Abudhabi UAE"]
[Date "2015.08.31"]
[Round "9.38"]
[White "Ris, R"]
[Black "Raja, H"]
[Result "1-0"]
[WhiteElo "2449"]
[BlackElo "2247"]
[ECO "A13"]
[EventDate "2015.08.23"]

1.Nf3 Nf6 2.g3 d5 3.c4 e6 4.Bg2 c5 5.O-O Nc6 6.b3 d4 7.e3 Bd6 8.exd4 cxd4 
9.d3 h6 10.Re1 O-O 11.Ba3 e5 12.Bxd6 Qxd6 13.a3 a5 14.Ra2 Bf5 15.Nh4 Bh7 
16.Bh3 Nd7 17.Nf5 Bxf5 18.Bxf5 g6 19.Be4 f5 20.Bd5+ Kg7 21.Rae2 Rae8 22.
Qd2 Nc5 23.b4 axb4 24.axb4 Nd7 25.b5 Nb4 26.Bxb7 Nxd3 27.Qxd3 Nc5 28.Qa3 
Nxb7 29.Qxd6 Nxd6 30.Rxe5 Rxe5 31.Rxe5 Nxc4 32.Rc5 Re8 33.Kf1 Nb6 34.Nd2 
Na4 35.Rc4 Nb6 36.Rxd4 Re5 37.Rb4 Kf6 38.Rb1 Rd5 39.Nf3 g5 40.Rc1 Rxb5 41.
Rc6+ Kg7 42.Nd4 Rb1+ 43.Kg2 h5 44.Nxf5+ Kf7 45.Nd6+ Kg7 46.Ne4 Nd5 47.Nxg5
Rb2 48.Re6 h4 49.Re5 Nf6 50.Re7+ Kg6 51.Ne4 Ng4 52.h3 Ne3+ 53.Kf3 hxg3 54.
fxg3 Nd5 55.Rd7 Rb3+ 56.Kg4 Ne3+ 57.Kf4 Ng2+ 58.Ke5 Rb5+ 59.Rd5 Rxd5+ 60.
Kxd5 Kf5 61.Nd6+ Kg5 62.Ke4 Nh4 63.Ke3 Kh5 64.Ne4 Ng6 65.Kf3 Ne5+ 66.Kf4 
Ng6+ 67.Kf5 Ne7+ 68.Ke6 Ng6 69.Kf6 Nf8 70.Kf5 Ng6 71.g4+ Kh6 72.g5+ Kg7 
73.Nd6 Kh7 74.Nf7 Kg7 75.Ne5 Nh4+ 76.Kg4 Ng2 77.Nc4 Ne1 78.h4 Nd3 79.h5 
1-0
```

## Output

Is a table where every row is a pgn (a game), see a sample in `example_output.tsv`

```
event	site	date	round	white	black	result	whiteelo	blackelo	eco	pgn
FIDE World Cup 2015	Baku AZE	2015-09-29	6.2	Karjakin, Sergey	Eljanov, Pavel	1/2-1/2	2762	2717	A29	1.c4 Nf6 2.Nc3 e5 3.Nf3 Nc6 4.g3 Bb4 5.Bg2 O-O 6.O-O e4 7.Ng5 Bxc3 8.bxc3  Re8 9.f3 exf3 10.Nxf3 Qe7 11.e3 Ne5 12.Nh4 d6 13.d3 Ng6 14.Nxg6 1/2-1/2
16. Karpov Poikovsky	Poikovsky RUS	2015-09-28	1.1	Morozevich, Alexander	Bologan, Viktor	0-1	2711	2607	A07	1.Nf3 d5 2.g3 c6 3.Bg2 Bf5 4.c4 e6 5.Qb3 Qb6 6.d3 Nf6 7.Be3 Qxb3 8.axb3 a6 9.Nh4 Bg6 10.f4 Nbd7 11.h3 Bb4+ 12.Kd1 O-O 13.Nd2 Rfd8 14.Kc2 b5 15.Rhd1  a5 16.Nxg6 hxg6 17.Nf3 Re8 18.Nd4 Rac8 19.Bd2 Nh5 20.cxb5 cxb5+ 21.Kb1  Nxg3 22.Nxb5 Rb8 23.Nd4 Nc5 24.Be3 Nf5 25.Nxf5 gxf5 26.Ka2 Nxb3 27.Rab1  Bd6 28.Ba7 Rb4 29.e4 Ra8 30.Be3 Rab8 0-1
Satka Autumn 2015	Satka RUS	2015-09-28	7.1	Ovod, Evgenija	Guseva, Marina	1-0	2328	2411	A11	1.c4 c6 2.Nf3 Nf6 3.Nc3 d5 4.e3 e6 5.b3 Bd6 6.Bb2 O-O 7.Be2 e5 8.cxd5 cxd5 9.Nb5 e4 10.Ne5 Ne8 11.Nxd6 Nxd6 12.f3 f6 13.Ng4 Nc6 14.fxe4 dxe4 15.O-O  b6 16.Qe1 Nb4 17.Qg3 Bxg4 18.Bxg4 Qe7 19.Qh3 Rad8 20.Bc3 Nd3 21.Be6+ Kh8  22.Bf5 Nxf5 23.Rxf5 Rf7 24.Raf1 Rd6 25.g4 Qe6 26.g5 Kg8 27.Qg3 Rd8 28.gxf6 Nc1 29.Qg2 Nxa2 30.Bd4 Nb4 31.Rg5 g6 32.Re5 Qc6 33.Rxe4 Nd5 34.Re5 Qd6 35. Ref5 Rdf8 36.Rxd5 1-0
Lev Gutman 70 GM 2015	Lingen GER	2015-09-28	6.3	Gutman, Lev	Heimann, Andreas	1/2-1/2	2443	2548	A37	1.Nf3 c5 2.g3 g6 3.Bg2 Bg7 4.c4 Nc6 5.O-O e6 6.d3 Nge7 7.Nc3 O-O 8.Bd2 d5  9.Qc1 b6 10.Bh6 d4 11.Bxg7 Kxg7 12.Ne4 e5 13.b4 Bf5 14.bxc5 Bxe4 15.dxe4  bxc5 16.Ne1 Qd6 17.f4 Nc8 18.Nd3 Nb6 19.Rb1 Na4 20.Qa3 Nc3 21.Rb2 Rab8 22. Rxb8 Rxb8 23.Bf3 Re8 24.fxe5 Nxe5 25.Qxa7 Rc8 26.Nxe5 Qxe5 27.a4 Rc7 28. Qa8 Qe7 29.Ra1 Ra7 30.Qc6 Ra5 31.Ra3 Qe5 32.Qd7 h5 33.Rb3 Nxe4 34.Rb7 Ng5  35.Qc7 Qxc7 36.Rxc7 d3 37.Rd7 Rxa4 38.Kf2 Rxc4 39.Rxd3 Rc1 40.h4 Ne6 41. Rd7 Kf6 42.Bd5 Ke5 43.Bf3 Kf6 44.Ke3 Nd4 45.Bd5 Rc3+ 46.Ke4 Ne6 47.e3 Rc2  48.Ra7 Rg2 49.Kf3 Rd2 50.Ke4 Rg2 51.Kf3 Rb2 52.Ra5 Rc2 53.Ke4 Rc1 54.Ra6  Rg1 55.Kf3 Ke5 56.Bc4 Rc1 57.Bb5 Rc3 58.Be8 Nc7 59.Ra7 Nxe8 60.Re7+ Kd6  61.Rxe8 Rc1 62.Rd8+ Ke6 63.Re8+ Kd7 64.Rf8 Rf1+ 65.Ke2 Rf6 66.Ra8 Rc6 67. Kd3 Ke6 68.e4 c4+ 69.Kc3 Ke5 70.Ra7 f6 71.Re7+ Re6 72.Rxe6+ Kxe6 1/2-1/2
Lev Gutman 70 GM 2015	Lingen GER	2015-09-28	6.2	Halkias, Stelios	Mikhalevski, Victor	1-0	2538	2536	A20	1.c4 e5 2.g3 c6 3.Nf3 e4 4.Nd4 d5 5.cxd5 Qxd5 6.e3 Bc5 7.Nc3 Qe5 8.Bg2 Nf6 9.O-O O-O 10.d3 exd3 11.Qxd3 Na6 12.a3 Re8 13.b4 Bb6 14.Bb2 c5 15.Ndb5 Rd8 16.Qc2 Qh5 17.Na4 cxb4 18.Bxf6 gxf6 19.Nxb6 axb6 20.Nd4 Bh3 21.Bxh3 Qxh3  22.axb4 Nxb4 23.Qc7 Nc6 24.Rxa8 Rxa8 25.Qxb7 1-0
16. Karpov Poikovsky	Poikovsky RUS	2015-09-28	1.4	Laznicka, Viktor	Smirin, Ilia	1/2-1/2	2676	2655	A26	1.c4 g6 2.Nc3 Bg7 3.g3 e5 4.Bg2 Nc6 5.d3 d6 6.e4 Nd4 7.Nge2 Bg4 8.h3 Bf3  9.O-O Nxe2+ 10.Nxe2 Bxg2 11.Kxg2 Ne7 12.d4 exd4 13.Nxd4 O-O 14.Rb1 Qd7 15. Re1 Nc6 16.Nf3 Rae8 17.Bf4 Re7 18.Qd5 Rfe8 19.a3 b6 20.b4 Ne5 21.Nxe5 Bxe5 22.Bd2 Qa4 23.Qd3 a6 24.Re3 1/2-1/2
6. Biella Open 2015	Biella ITA	2015-09-27	5.4	Gilevych, Artem	Sgnaolin, Davide	1/2-1/2	2408	2241	A32	1.d4 Nf6 2.Nf3 e6 3.c4 c5 4.Nc3 cxd4 5.Nxd4 Bb4 6.Nc2 Bxc3+ 7.bxc3 O-O 8. Ba3 Re8 9.e3 d5 10.cxd5 Nxd5 11.c4 Qa5+ 12.Qd2 Qxd2+ 13.Kxd2 Nf6 14.Bd3  Nc6 15.Bb2 e5 16.e4 Rd8 17.f3 Be6 18.Ke2 Nd7 19.Ne3 Nc5 20.Nd5 Nxd3 21. Kxd3 b5 22.cxb5 Nb4+ 23.Ke2 Nxd5 24.exd5 Rxd5 25.a4 Rad8 1/2-1/2
Vasteras Open 2015	Vasteras SWE	2015-09-27	8.6	Danielsen, Henrik	Ernst, Thomas	0-1	2510	2336	A04	1.Nf3 c5 2.g3 Nc6 3.Bg2 e5 4.O-O d5 5.d3 Nf6 6.e4 d4 7.Na3 Be7 8.Nc4 Qc7  9.a4 Bg4 10.h3 Be6 11.Ne1 Nd7 12.f4 f6 13.Bd2 O-O-O 14.Nf3 Nb6 15.b3 Nxc4  16.bxc4 Qd7 17.f5 Bf7 18.Qb1 Nb4 19.a5 Kb8 20.Be1 Rdg8 21.Nd2 g6 22.Kh2  Qc7 23.Nb3 Be8 24.c3 Na6 25.Nc1 gxf5 26.Rxf5 h5 27.Ne2 Bd7 28.Rf1 Rd8 29. Ra2 Be6 30.Rb2 Rd7 31.Rb5 Ka8 32.Kh1 Rhd8 33.cxd4 cxd4 34.Bd2 Rg8 35.Qc2  Bd8 36.Rfb1 Rdg7 37.Bh6 Rh7 38.Bc1 Bc8 39.Bd2 Rhg7 40.c5 Be7 41.Kh2 Bxc5  42.Rc1 Ba3 0-1
Duna Open 2015	Budapest HUN	2015-09-27	5.2	Hando, Vilmos	Almasi, Istvan	0-1	2332	2409	A32	1.d4 Nf6 2.Nf3 c5 3.c4 cxd4 4.Nxd4 e6 5.Nc3 Bb4 6.Bd2 Nc6 7.Nc2 Be7 8.e4  O-O 9.Be3 Qa5 10.Bd3 Rd8 11.a3 d5 12.b4 Qc7 13.Nb5 Qb8 14.exd5 exd5 15.c5  Ng4 16.Qd2 Qe5 17.h3 Nxe3 18.Qxe3 a6 19.Nbd4 Bf6 20.Qxe5 Bxe5 21.Nxc6 Bc3+ 22.Kd1 bxc6 23.Rb1 a5 24.Ke2 axb4 25.axb4 Re8+ 26.Kf3 Be6 27.Rhd1 Reb8 28. b5 cxb5 29.Rxb5 Rc8 30.Ne3 g6 31.g4 Bd7 32.Rb3 d4 33.Be4 Ba4 34.Bxa8 Bxb3  35.Rb1 Ba2 36.Bb7 Rxc5 0-1
Lev Gutman 70 GM 2015	Lingen GER	2015-09-27	7.5	Greenfeld, Alon	Halkias, Stelios	1/2-1/2	2535	2538	A13	1.Nf3 Nf6 2.c4 e6 3.g3 d5 4.Bg2 dxc4 5.Qa4+ Bd7 6.Qxc4 c5 7.Ne5 Qc8 8.O-O  Nc6 9.Nxd7 Qxd7 10.Nc3 Rc8 11.a3 a6 12.Qa4 Be7 13.b4 O-O 14.Rb1 c4 15.Rd1  Nd5 16.Bb2 Rfd8 17.b5 axb5 18.Qxb5 Nxc3 19.Bxc3 Bxa3 20.Qxc4 Bf8 21.Qe4  Rb8 22.Rb2 Nd4 23.Bxd4 Qxd4 24.Qxd4 Rxd4 25.Rxb7 Rxb7 26.Bxb7 h5 27.Bf3 h4 28.e3 Rb4 29.Ra1 hxg3 30.hxg3 Rb2 31.d4 g6 32.Kf1 Rc2 33.Ra7 Rc1+ 34.Kg2  Rc8 35.Rd7 Re8 36.Bc6 Re7 37.Rd8 Rc7 38.Be4 Kg7 39.g4 Be7 40.Ra8 g5 41.Ra6 Rc3 42.Ra7 Kf8 43.Kf3 Ra3 44.Rb7 Ra2 45.Rc7 Ra1 46.Rc8+ Kg7 47.Rc7 Kf8 48. d5 exd5 49.Bxd5 Ra4 50.Rc8+ Kg7 51.Rc7 Kf8 52.Bc4 Ra5 53.Rb7 Rc5 54.Bb3  Rc1 55.Bd5 Rc2 56.Rb8+ Kg7 57.Rb7 Kf8 58.Be4 Rd2 59.Rb5 Kg7 60.Rf5 Rd7 61. Ke2 Ra7 62.Bd5 Bd8 63.Kd3 Rd7 64.Kc4 Rc7+ 65.Kb5 f6 66.Be6 Re7 67.Rd5 Bc7  68.Bf5 Re5 69.e4 Re7 1/2-1/2
```


