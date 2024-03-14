BIN := sysrdl

OBJECTS = yacc.o lexor.o rdlGperf.o rdlMain.o rdlBase.o rdlComponent.o rdlInstance.o rdlProperty.o rdlPropertyDefinition.o rdlEnum.o rdlNumber.o rdlInstanceRef.o
INCDIRS = -I.
LIBDIRS = -L.
CFLAGS = -g
CC = g++

#all: $(BIN) clean
all: $(BIN)

%.o: %.cpp %.h
	$(CC) $(CFLAGS) $(INCDIRS) -c $<
yacc.o: rdlParse.y
	bison -t -d -o yacc.c rdlParse.y
	$(CC) $(CFLAGS) $(INCDIRS) -c yacc.c
lexor.o: rdlParse.l yacc.h
	flex -olexor.c rdlParse.l
	$(CC) $(CFLAGS) $(INCDIRS) -c lexor.c
rdlGperf.o: rdlKeyword.gperf yacc.h
	rm -f rdlGperf.c
	gperf -N check_identifier -L ANSI-C -t rdlKeyword.gperf > rdlGperf.c
	$(CC) $(CFLAGS) $(INCDIRS) -c rdlGperf.c
$(BIN): $(OBJECTS)
	$(CC) -o $@ $(OBJECTS)

clean:
	rm -rf *.o lexor.c yacc.* rdlGperf.c

test:
	cd testCases
	make
	cd ..
