##### build stage ##############################################################

ARG TARGET_ARCHITECTURE
ARG BASE=7.0.7ec3
ARG REGISTRY=ghcr.io/epics-containers

FROM  ${REGISTRY}/epics-base-${TARGET_ARCHITECTURE}-developer:${BASE} AS developer

# Get latest ibek while in development. Will come from epics-base when stable
COPY requirements.txt requirements.txt
RUN pip install --upgrade -r requirements.txt

# The devcontainer mounts the project root to /epics/ioc-adsample. Using
# the same location here makes devcontainer/runtime differences transparent.
WORKDIR /epics/ioc-adsample/ibek-support

# copy the global ibek files
COPY ibek-support/_global/ _global

COPY ibek-support/asyn/ asyn/
RUN asyn/install.sh R4-42

COPY ibek-support/busy/ busy/
RUN busy/install.sh R1-7-3

COPY ibek-support/ADCore-slim/ ADCore-slim/
RUN ADCore-slim/install.sh R3-12-1

COPY ibek-support/ADSimDetector/ ADSimDetector/
RUN ADSimDetector/install.sh R2-9

# create IOC source tree, generate Makefile and compile IOC Instance
RUN ibek ioc build

##### runtime preparation stage ################################################

FROM developer AS runtime_prep

# get the products from the build stage and reduce to runtime assets only
RUN ibek ioc extract-runtime-assets /assets

##### runtime stage ############################################################

FROM ${REGISTRY}/epics-base-${TARGET_ARCHITECTURE}-runtime:${BASE} AS runtime

# get runtime assets from the preparation stage
COPY --from=runtime_prep /assets /

# install runtime system dependencies, collected from install.sh scripts
RUN ibek support apt-install --runtime

ENV TARGET_ARCHITECTURE ${TARGET_ARCHITECTURE}

ENTRYPOINT ["/bin/bash", "-c", "${IOC}/start.sh"]
