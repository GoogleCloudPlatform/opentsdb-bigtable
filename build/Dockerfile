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

FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y autoconf make unzip gnuplot curl git

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
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN cd /opentsdb && sh build-bigtable.sh install

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start"]
