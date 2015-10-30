obj-m = hellomod.o

# Inside the container

KVERSION = $(shell uname -r)
all:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

# On the host

build:
	docker build -t hellomod .

install:
	docker run --rm --privileged -v /:/host hellomod /install.sh

uninstall:
	docker run --rm --privileged -v /:/host hellomod /uninstall.sh

.PHONY: build install uninstall all clean
