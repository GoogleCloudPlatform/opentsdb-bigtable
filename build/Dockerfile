# Copyright 2017 Google Inc.
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

RUN apt-get update && apt-get install -y autoconf make unzip gnuplot curl git && \
    curl -f http://storage.googleapis.com/cloud-bigtable/hbase-dist/hbase-1.2.1/hbase-1.2.1-bin.tar.gz | tar zxf -  && \
    mkdir -p hbase-1.2.1/lib/bigtable && \
    curl http://repo1.maven.org/maven2/com/google/cloud/bigtable/bigtable-hbase-1.2/0.9.5.1/bigtable-hbase-1.2-0.9.5.1.jar \
      -f -o hbase-1.2.1/lib/bigtable/bigtable-hbase-1.2-0.9.5.1.jar && \
    curl http://repo1.maven.org/maven2/io/netty/netty-tcnative-boringssl-static/1.1.33.Fork19/netty-tcnative-boringssl-static-1.1.33.Fork19.jar \
      -f -o hbase-1.2.1/lib/netty-tcnative-boringssl-static-1.1.33.Fork19.jar && \
    echo 'export HBASE_CLASSPATH="$HBASE_HOME/lib/bigtable/bigtable-hbase-1.2-0.9.5.1.jar:$HBASE_HOME/lib/netty-tcnative-boringssl-static-1.1.33.Fork19.jar"' >> /hbase-1.2.1/conf/hbase-env.sh && \
    echo 'export HBASE_OPTS="${HBASE_OPTS} -Xms1024m -Xmx2048m"' >> /hbase-1.2.1/conf/hbase-env.sh

RUN git clone https://github.com/OpenTSDB/opentsdb.git && \
    cd opentsdb && \
    sh build-bigtable.sh install

COPY hbase-site.xml /hbase-1.2.1/conf

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start"]
