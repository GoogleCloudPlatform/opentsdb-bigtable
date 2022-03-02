# Copyright 2022 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM debian:11.2

CMD ["bash"]
RUN apt-get update  \
    && apt-get install -y --no-install-recommends ca-certificates curl netbase wget  \
    && rm -rf /var/lib/apt/lists/*
RUN set -ex; if ! command -v gpg > /dev/null; then apt-get update; apt-get install -y --no-install-recommends gnupg dirmngr ; rm -rf /var/lib/apt/lists/*; fi
RUN apt-get update  \
    && apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps  \
    && rm -rf /var/lib/apt/lists/*
RUN set -eux; apt-get update; apt-get install -y --no-install-recommends bzip2 unzip xz-utils ca-certificates p11-kit fontconfig libfreetype6 ; rm -rf /var/lib/apt/lists/*
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN { echo '#/bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home  \
    && chmod +x /usr/local/bin/docker-java-home  \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]
ENV JAVA_VERSION=8u292
RUN set -eux; arch="$(dpkg --print-architecture)"; case "$arch" in amd64 | i386:x86-64) downloadUrl=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_linux_8u292b10.tar.gz ;; *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; esac; wget -O openjdk.tgz.asc "$downloadUrl.sign"; wget -O openjdk.tgz "$downloadUrl" --progress=dot:giga; export GNUPGHOME="$(mktemp -d)"; gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options no-self-sigs-only --recv-keys CA5F11C6CE22644D42C6AC4492EF8D39DC13168F; gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EAC843EBD3EFDB98CC772FADA5CD6035332FA671; gpg --batch --list-sigs --keyid-format 0xLONG CA5F11C6CE22644D42C6AC4492EF8D39DC13168F | tee /dev/stderr | grep '0xA5CD6035332FA671' | grep 'Andrew Haley'; gpg --batch --verify openjdk.tgz.asc openjdk.tgz; gpgconf --kill all; rm -rf "$GNUPGHOME"; mkdir -p "$JAVA_HOME"; tar --extract --file openjdk.tgz --directory "$JAVA_HOME" --strip-components 1 --no-same-owner ; rm openjdk.tgz*; { echo '#!/usr/bin/env bash'; echo 'set -Eeuo pipefail'; echo 'if ! [ -d "$JAVA_HOME" ]; then echo >&2 "error: missing JAVA_HOME environment variable"; exit 1; fi'; echo 'cacertsFile=; for f in "$JAVA_HOME/lib/security/cacerts" "$JAVA_HOME/jre/lib/security/cacerts"; do if [ -e "$f" ]; then cacertsFile="$f"; break;    fi; done'; echo 'if [ -z "$cacertsFile" ] || ! [ -f "$cacertsFile" ]; then echo >&2 "error: failed to find cacerts file in $JAVA_HOME"; exit 1; fi'; echo 'trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$cacertsFile"'; } > /etc/ca-certificates/update.d/docker-openjdk; chmod +x /etc/ca-certificates/update.d/docker-openjdk; /etc/ca-certificates/update.d/docker-openjdk; find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; ldconfig; javac -version; java -version

RUN apt-get update \
    && apt-get install -y autoconf make unzip gnuplot curl git

RUN curl -f https://archive.apache.org/dist/hbase/2.4.9/hbase-2.4.9-bin.tar.gz | tar zxf - && \
    mkdir -p hbase-2.4.9/lib/bigtable && \
    curl https://repo1.maven.org/maven2/com/google/cloud/bigtable/bigtable-hbase-2.x-hadoop/1.26.2/bigtable-hbase-2.x-hadoop-1.26.2.jar \
    -f -o hbase-2.4.9/lib/bigtable/bigtable-hbase-2.x.jar && \
    curl https://repo1.maven.org/maven2/io/netty/netty-tcnative-boringssl-static/2.0.46.Final/netty-tcnative-boringssl-static-2.0.46.Final.jar \
      -f -o hbase-2.4.9/lib/netty-tcnative-boringssl-static-2.0.46.Final.jar && \
    echo 'export HBASE_CLASSPATH="$HBASE_HOME/lib/bigtable/bigtable-hbase-2.x.jar:$HBASE_HOME/lib/netty-tcnative-boringssl-static-2.0.46.Final.jar"' >> /hbase-2.4.9/conf/hbase-env.sh && \
    echo 'export HBASE_OPTS="${HBASE_OPTS} -Xms1024m -Xmx2048m"' >> /hbase-2.4.9/conf/hbase-env.sh

RUN git clone https://github.com/OpenTSDB/opentsdb.git && \
    cd opentsdb && \
    git fetch --tags && \
    git checkout tags/v2.4.1 && \
    # Remove TTL=>forever from create_table
    sed -i "s/, TTL => '\$TSDB_TTL'}/}/" src/create_table.sh

COPY hbase-site.xml /hbase-2.4.9/conf
COPY include.mk /opentsdb/third_party/asyncbigtable/include.mk
COPY asyncbigtable-0.4.3-jar-with-dependencies.jar.md5 /opentsdb/third_party/asyncbigtable/asyncbigtable-0.4.3-jar-with-dependencies.jar.md5

RUN apt-get install -y python3 python3-pip
RUN set -eux; if [ ! -f /usr/bin/python -a ! -L /usr/bin/python ] ; then if [ -L  /usr/bin/python3 -o -f /usr/bin/python3 ] ; then ln -s /usr/bin/python3 /usr/bin/python; else exit "Cannot successfully configure python symbolic link as python3 is not present"; fi ; fi

RUN cd /opentsdb && sh build-bigtable.sh install

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start"]
