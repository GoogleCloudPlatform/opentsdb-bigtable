OpenTSDB on Bigtable
============

You can deploy OpenTSDB on Google Kubernetes Engine with Cloud Bigtable as the underlying storage layer.

The image build and deployment configurations in this repository are used by the accompanying guide
[Monitoring time-series data with OpenTSDB on Cloud Bigtable and GKE](https://cloud.google.com/solutions/monitoring-time-series-data-opentsdb).
The guide also deploys Grafana for visualization of generated test data.

The default image build manifest uses recent base image and dependency versions. If you plan to follow
the instructions in the guide, you can stop reading now, as the guide includes complete instructions
to build the container image.

If you are interested in building a OpenTSDB server for Bigtable image with a customized manifest
that uses an alternate base image and/or dependency versions, you can follow these instructions


## Build Docker image

To use any of these image build options, first set environment variables such that the
image is pushed by Cloud Build to your Artifact Registry:

```sh
cd opentsdb-bigtable
export PROJECT_ID=your-project-id                            # e.g. bt-opentsdb-project-id
export REGION=your-artifact-registry-region                  # e.g. us-central1 
export AR_REPO=your-artifact-registry-repo                   # e.g. opentsdb-bt-repo
export SERVER_IMAGE_NAME=your-opentsdb-server-image-name     # e.g. opentsdb-server-bigtable
export SERVER_IMAGE_TAG=your-opentsdb-server-image-tag       # e.g. 2.4.1
```

> **Note:** Before you can build an image, you must [create a Docker reposiory](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images)
>            in [Artifact Registry](https://cloud.google.com/artifact-registry) 
>            that matches the repository name in your environment variable.

Then choose one of these options to complete the build:

### Option 1: Build the image used in the guide

Use these commands to build the image:

```sh
cd build
./build-cloud.sh
```

### Option 2: Build an image using specific component versions

The OpenTSDB on Bigtable container image includes the following base image and dependencies:

* [Debian Docker image](https://hub.docker.com/_/debian)
* [AdoptOpenJDK/openjdk8-upstream-binaries](https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/)
* [HBase](https://archive.apache.org/dist/hbase/)
* [Google Cloud Bigtable HBase](https://mvnrepository.com/artifact/com.google.cloud.bigtable)
* [Netty/TomcatNative \[BoringSSL Static\]](https://mvnrepository.com/artifact/io.netty/netty-tcnative-boringssl-static)
* [Async Bigtable Library](https://mvnrepository.com/artifact/com.pythian.opentsdb/asyncbigtable)
* [OpenTSDB](https://github.com/OpenTSDB/opentsdb)

If you wish to build an OpenTSDB server for Bigtable image using a specific set of versions:

1. Set the environment variables:

```sh
export DEBIAN_VERSION=your-debian_version                  # e.g. 11.2
export HBASE_RELEASE_VERSION=your-hbase_release_version    # e.g. 2.4.9
export BT_HBASE_VERSION_MAJOR=your-bt_hbase_version_major  # e.g. 2
export BT_HBASE_REVISION=your-bt_hbase_revision            # e.g. 1.26.2
export NETTY_TCNATIVE_VERSION=your-netty_tcnative_version  # e.g. 2.0.46.Final
export OPENTSDB_CHECKOUT=your-opentsdb_checkout            # e.g. tags/v2.4.1
export ASYNCBIGTABLE_VERSION=your-asyncbigtable_version    # e.g. 0.4.3
export OPENJDK8U_VERSION=your-openjdk8u_version            # e.g. 8u292
export OPENJDK8U_BUILD=your-openjdk8u_build                # e.g. b10
```

2. Build the image:

```sh
cd build
./build-cloud-with-version.sh
```

### Option 3: Build an image using the component versions used to build images formerly hosted on gcr.io

For earlier versions of the accompanying guide, the OpenTSDB on Bigtable container images were hosted on gcr.io.
You can use these instructions to build container images including the dependency versions that
match those from these images.

1. Use `source` to set variables in the current shell environment that corresponds with the desired gcr.io version tag.

   a. gcr.io/cloud-solutions-images/opentsdb-bigtable:v3

   ```sh
   source build--gcr-io-cloud-solutions-images-opentsdb-bigtable-v3.env
   ```

   b. gcr.io/cloud-solutions-images/opentsdb-bigtable:v2.1


   ```sh
   source build--gcr-io-cloud-solutions-images-opentsdb-bigtable-v2.1.env
   ```

2. Build the image:

```sh
cd build
./build-cloud-with-version.sh
```

