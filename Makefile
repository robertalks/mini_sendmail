# Makefile for mini_sendmail

# CONFIGURE: If you are using a SystemV-based operating system, such as
# Solaris, you will need to uncomment this definition.
#SYSV_LIBS =    -lnsl -lsocket

BINDIR 	= /usr/sbin
MANDIR 	= /usr/share/man
CC 	= gcc
CFLAGS 	= -O2 -ansi -pedantic -U__STRICT_ANSI__ -Wpointer-arith -Wshadow -Wcast-qual -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wno-long-long
LDFLAGS =
LDLIBS 	= $(SYSV_LIBS)

all:	mini_sendmail

diet:
	make DIET=diet mini_sendmail


mini_sendmail: mini_sendmail.o
	$(CC) $(LDFLAGS) mini_sendmail.o $(LDLIBS) -o mini_sendmail

mini_sendmail.o: mini_sendmail.c version.h
	$(CC) $(CFLAGS) -c mini_sendmail.c


install: all
	rm -f $(BINDIR)/mini_sendmail
	install -p -m 0755 mini_sendmail $(BINDIR)
	strip --strip-unneeded $(BINDIR)/mini_sendmail
	rm -f $(MANDIR)/man8/mini_sendmail.8
	install -p -m 0644 mini_sendmail.8 $(MANDIR)/man8
	gzip -f -9 $(MANDIR)/man8/mini_sendmail.8
	[ -x /usr/bin/mandb ] && /usr/bin/mandb --quiet

clean:
	rm -f mini_sendmail *.o core core.* *.core

tar:
	@name=`sed -n -e '/#define MINI_SENDMAIL_VERSION /!d' -e 's,.*mini_sendmail/,mini_sendmail-,' -e 's, .*,,p' version.h` ; \
	rm -rf $$name ; \
	mkdir $$name ; \
	tar cf - `cat FILES` | ( cd $$name ; tar xfBp - ) ; \
	chmod 644 $$name/Makefile ; \
	tar cf $$name.tar $$name ; \
	rm -rf $$name ; \
	gzip $$name.tar
