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
apiVersion: v1
kind: ConfigMap
metadata:
  name: opentsdb-config
data:
  opentsdb.conf: |
    google.bigtable.project.id = ${PROJECT_ID}
    google.bigtable.instance.id = ${BIGTABLE_INSTANCE_ID}
    google.bigtable.zone.id = ${ZONE}
    hbase.client.connection.impl = com.google.cloud.bigtable.hbase2_x.BigtableConnection
    google.bigtable.auth.service.account.enable = true

    tsd.network.port = 4242
    tsd.core.auto_create_metrics = true
    tsd.core.meta.enable_realtime_ts = true
    tsd.core.meta.enable_realtime_uid = true
    tsd.core.meta.enable_tsuid_tracking = true
    tsd.http.request.enable_chunked = true
    tsd.http.request.max_chunk = 131072
    tsd.storage.fix_duplicates = true
    tsd.storage.enable_compaction = false
    tsd.storage.max_tags = 12
    tsd.http.staticroot = /opentsdb/build/staticroot
    tsd.http.cachedir = /tmp/opentsdb
