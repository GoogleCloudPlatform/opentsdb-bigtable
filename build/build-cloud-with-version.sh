#!/bin/bash
#
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

# check for required image tag arguments

[ -z $REGION ] && \
    echo "env var REGION is not set" && EXIT_SCRIPT=1
[ -z $PROJECT_ID ] && \
    echo "env var PROJECT_ID is not set" && EXIT_SCRIPT=1
[ -z $AR_REPO ] && \
    echo "env var AR_REPO is not set" && EXIT_SCRIPT=1
[ -z $SERVER_IMAGE_NAME ] && \
    echo "env var SERVER_IMAGE_NAME is not set" && EXIT_SCRIPT=1
[ -z $SERVER_IMAGE_TAG ] && \
    echo "env var SERVER_IMAGE_TAG is not set" && EXIT_SCRIPT=1

# check for required component version arguments

[ -z $DEBIAN_VERSION ] && \
     echo "env var DEBIAN_VERSION is not set" && EXIT_SCRIPT=1
[ -z $HBASE_RELEASE_VERSION ] && \
     echo "env var HBASE_RELEASE_VERSION is not set" && EXIT_SCRIPT=1
[ -z $BT_HBASE_VERSION_MAJOR ] && \
     echo "env var BT_HBASE_VERSION_MAJOR is not set" && EXIT_SCRIPT=1
[ -z $BT_HBASE_REVISION ] && \
     echo "env var BT_HBASE_REVISION is not set" && EXIT_SCRIPT=1
[ -z $NETTY_TCNATIVE_VERSION ] && \
     echo "env var NETTY_TCNATIVE_VERSION is not set" && EXIT_SCRIPT=1
[ -z $OPENTSDB_CHECKOUT ] && \
     echo "env var OPENTSDB_CHECKOUT is not set" && EXIT_SCRIPT=1
[ -z $ASYNCBIGTABLE_VERSION ] && \
     echo "env var ASYNCBIGTABLE_VERSION is not set" && EXIT_SCRIPT=1
[ -z $OPENJDK8U_VERSION ] && \
     echo "env var OPENJDK8U_VERSION is not set" && EXIT_SCRIPT=1
[ -z $OPENJDK8U_BUILD ] && \
     echo "env var OPENJDK8U_BUILD is not set" && EXIT_SCRIPT=1

[ ${EXIT_SCRIPT:-0} -eq 1 ] && exit


IMAGE_TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${SERVER_IMAGE_NAME}:${SERVER_IMAGE_TAG}"

# Need YAML so we can set --build-arg
cat <<EOF > /tmp/cloudbuild.yml
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', '$IMAGE_TAG',
                  '-f', 'Dockerfile-version-args',
                  '--build-arg', 'DEBIAN_VERSION=$DEBIAN_VERSION',
                  '--build-arg', 'HBASE_RELEASE_VERSION=$HBASE_RELEASE_VERSION',
                  '--build-arg', 'BT_HBASE_VERSION_MAJOR=$BT_HBASE_VERSION_MAJOR',
                  '--build-arg', 'BT_HBASE_REVISION=$BT_HBASE_REVISION',
                  '--build-arg', 'NETTY_TCNATIVE_VERSION=$NETTY_TCNATIVE_VERSION',
                  '--build-arg', 'OPENTSDB_CHECKOUT=$OPENTSDB_CHECKOUT',
                  '--build-arg', 'ASYNCBIGTABLE_VERSION=$ASYNCBIGTABLE_VERSION',
                  '--build-arg', 'OPENJDK8U_VERSION=$OPENJDK8U_VERSION',
                  '--build-arg', 'OPENJDK8U_BUILD=$OPENJDK8U_BUILD',
         '.']
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', '$IMAGE_TAG']
EOF

gcloud builds submit . --config /tmp/cloudbuild.yml

rm /tmp/cloudbuild.yml

