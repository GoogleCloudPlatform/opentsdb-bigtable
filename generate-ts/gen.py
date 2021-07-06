# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Generate random time series events and post to the
OpenTSDB rest endpoint every 1 second.
Args:
    host: OpenTSDB service endpoint (default: opentsdb-write)
"""

import json
import time
import random
import requests
import sys
import logging

host = "opentsdb-write"
if len(sys.argv) > 1:
    host = sys.argv[1];

while True:
    a=[]
    for i in range(0, 5):
        cpu = {}
        cpu["timestamp"] = int(time.time()*1000)
        cpu["metric"] = "cpu_node_utilization_gauge"
        cpu["value"] = random.uniform(0,1)
        cpu["tags"] = {"host": "host%d" %i}
        a.append(cpu)
        mem = {}
        mem["timestamp"] = int(time.time()*1000)
        mem["metric"] = "memory_usage_gauge"
        mem["value"] = random.uniform(1,10)
        mem["tags"] = {"host": "host%d" %i}
        a.append(mem)
    r = requests.post("http://%s:4242/api/put?details" %host, json=a)
    logging.info(r.content)
    time.sleep(5)
