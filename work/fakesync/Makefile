CC = gcc

all: lib

lib: fakesync.c
	$(CC) -nostartfiles -shared -fPIC -Wl,-soname,libfakesync.so.1 -o libfakesync.so.1 fakesync.c

install:
	@echo 'Do *not* install this in the usual library path!'

clean:
	rm libfakesync.so.1
