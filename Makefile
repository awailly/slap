Parser: Parser.lex.o Parser.y.o
	$(CC) -g -o Parser Parser.lex.o Parser.y.o -lfl

Parser.lex.o: Parser.lex Parser.y.o
	flex Parser.lex
	mv lex.yy.c Parser.lex.c
	$(CC) -g -c Parser.lex.c -o Parser.lex.o

Parser.y.o: Parser.y
	bison -d Parser.y
	mv Parser.tab.h Parser.h
	mv Parser.tab.c Parser.y.c
	$(CC) -g -c Parser.y.c -o Parser.y.o

clean:
	rm Parser.h Parser *.c *.o
