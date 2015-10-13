# Chess-db

Scripts for parse pgns files into a sqlite (tsv, RData) database/table.

## How to use

- Download a "chess database". For example you can download a big list of pgn from http://www.kingbase-chess.net/.
- Put all the pgn files in the `data-raw` folder.
- Then run the R scripts.
- If you have a humble pc wait for 2-3 hours.
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
event	site	date	round	white	black	result	whiteelo	blackelo	eco	moves	file_from
22. Abu Dhabi Masters	Abudhabi UAE	2015-08-31	9.38	Ris, R	Raja, H	1-0	2449	2247	A13	Nf3 Nf6 g3 d5 c4 e6 Bg2 c5 O-O Nc6 b3 d4 e3 Bd6 exd4 cxd4 d3 h6 Re1 O-O Ba3 e5 Bxd6 Qxd6 a3 a5 Ra2 Bf5 Nh4 Bh7 Bh3 Nd7 Nf5 Bxf5 Bxf5 g6 Be4 f5 Bd5+ Kg7 Rae2 Rae8 Qd2 Nc5 b4 axb4 axb4 Nd7 b5 Nb4 Bxb7 Nxd3 Qxd3 Nc5 Qa3 Nxb7 Qxd6 Nxd6 Rxe5 Rxe5 Rxe5 Nxc4 Rc5 Re8 Kf1 Nb6 Nd2 Na4 Rc4 Nb6 Rxd4 Re5 Rb4 Kf6 Rb1 Rd5 Nf3 g5 Rc1 Rxb5 Rc6+ Kg7 Nd4 Rb1+ Kg2 h5 Nxf5+ Kf7 Nd6+ Kg7 Ne4 Nd5 Nxg5 Rb2 Re6 h4 Re5 Nf6 Re7+ Kg6 Ne4 Ng4 h3 Ne3+ Kf3 hxg3 fxg3 Nd5 Rd7 Rb3+ Kg4 Ne3+ Kf4 Ng2+ Ke5 Rb5+ Rd5 Rxd5+ Kxd5 Kf5 Nd6+ Kg5 Ke4 Nh4 Ke3 Kh5 Ne4 Ng6 Kf3 Ne5+ Kf4 Ng6+ Kf5 Ne7+ Ke6 Ng6 Kf6 Nf8 Kf5 Ng6 g4+ Kh6 g5+ Kg7 Nd6 Kh7 Nf7 Kg7 Ne5 Nh4+ Kg4 Ng2 Nc4 Ne1 h4 Nd3 h5	A00-A39
80. ch-ESP 2015	Linares ESP	2015-08-31	9.14	Alsina Leal, Daniel	Navarro Lopez Menchero, D	1-0	2531	2213	A28	c4 e5 Nc3 Nc6 Nf3 Nf6 e4 Bc5 Nxe5 Nxe5 d4 Bb4 dxe5 Nxe4 Qf3 Bxc3+ bxc3 Ng5 Qg3 Ne6 f4 g6 f5 gxf5 Bd3 d5 Bxf5 dxc4 O-O Qe7 Be4 c6 a4 Bd7 Ba3 Qg5 Qf2 Qg7 h4 Rg8 Rab1 b6 a5 Nc5 Bxc5 bxc5 Qxc5 Qh6 Rb7	A00-A39
80. ch-ESP 2015	Linares ESP	2015-08-31	9.10	Alvarado Diaz, Alejandro	Fernandez Romero, Ernesto	1/2-1/2	2408	2488	A05	Nf3 Nf6 g3 b6 Bg2 Bb7 O-O g6 b3 Bg7 Bb2 O-O c4 d6 d4 e6 Nc3 Ne4 Qc2 Nxc3 Bxc3 f5 Ne1 Bxg2 Nxg2 e5 Rad1 exd4 Bxd4 Bxd4 Rxd4 Nc6 Rdd1 Qf6 Qd2 Ne5 Qd5+ Qf7 Nf4 Rae8 e3 a5 Kg2 Ng4 Rc1 Nf6 Qxf7+ Rxf7 Rfd1 g5 Nd5 Kf8 Nxf6 Rxf6 Rd4 h6 h4 Kg7 hxg5 hxg5	A00-A39
```


