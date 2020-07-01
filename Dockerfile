FROM debian:buster
MAINTAINER Tonny Gieselaar 

ENV MKDOMOTICZ_UPDATED=20200608
ARG DOMOTICZ_VERSION="master"

# install packages
RUN apt-get update && apt-get install -y \
	build-essential \
	cmake \
	curl \
        fail2ban \
	git \
	libboost-all-dev \
	libcereal-dev \
	libcurl4 \
	libcurl4-gnutls-dev \
#	libcurl4-openssl-dev \
	libsqlite3-0 \
	libsqlite3-dev \
	libssl1.1 \
	libssl-dev \
	libusb-0.1-4 \
	libusb-dev \
	liblua5.3-dev \
	libudev-dev \
	python3-dev \
	python3-pip \
	uthash-dev \
	zlib1g-dev 

# Build Cmake 3.16, required for building Domoticz
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.16.8/cmake-3.16.8.tar.gz --output cmake.tar.gz && \
	gunzip cmake.tar.gz && \
	tar xvf cmake.tar && \
	cd cmake*/ && \ 
	./bootstrap && make && make install
   
RUN git clone --depth 2 https://github.com/OpenZWave/open-zwave.git /src/open-zwave && \
	cd /src/open-zwave && \
	make && make install && \
	ln -s /src/open-zwave /src/open-zwave-read-only

RUN git clone -b "${DOMOTICZ_VERSION}" --depth 2 https://github.com/domoticz/domoticz.git /src/domoticz && \
	cd /src/domoticz && \
	git fetch --unshallow && \
	cmake -DCMAKE_BUILD_TYPE=Release . && \
	make 

# Install
# install -m 0555 domoticz /usr/local/bin/domoticz && \
#RUN cd /tmp && \
#	pip3 install -U ouimeaux

RUN apt-get remove -y \
	git cmake linux-headers-amd64 \
	build-essential libssl-dev libboost-dev \
	libboost-thread-dev libboost-system-dev \
	libsqlite3-dev libcurl4-openssl-dev \
	libusb-dev zlib1g-dev libudev-dev && \
	apt-get autoremove -y && \ 
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


VOLUME /config

EXPOSE 8080

COPY start.sh /start.sh

#ENTRYPOINT ["/src/domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log"]
#CMD ["-www", "8080"]
CMD [ "/start.sh" ]
