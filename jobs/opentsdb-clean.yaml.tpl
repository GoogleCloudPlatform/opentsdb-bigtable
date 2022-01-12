# Copyright 2022 Google, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
apiVersion: batch/v1
kind: Job
metadata:
  name: opentsdb-clean
spec:
  template:
    metadata:
      name: opentsdb-clean
    spec:
      containers:
        - name: opentsdb-clean
          image: ${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${SERVER_IMAGE_NAME}:${SERVER_IMAGE_TAG}
          args: ["clean"]
          volumeMounts:
            - name: "opentsdb-config"
              mountPath: "/opt/opentsdb"
      volumes:
        - name: "opentsdb-config"
          configMap:
            name: "opentsdb-config"
            items:
              - key: "opentsdb.conf"
                path: "opentsdb.conf"
      restartPolicy: Never
