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


IMAGE_TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${SERVER_IMAGE_NAME}:${SERVER_IMAGE_TAG}"

gcloud builds submit --tag ${IMAGE_TAG} .
