# Dockerfile

FROM ubuntu:21.10

ARG OPENCL_PLATFORM=intel

ARG USE_CL_EXPERIMENTAL=OFF
ARG GL_IS_SUPPORTED=ON
ARG GLES_IS_SUPPORTED=ON

ENV DEBIAN_FRONTEND='noninteractive'
ENV DEBIAN_PRIORITY='critical'

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  cmake \
  ocl-icd-opencl-dev \
  opencl-headers \
  mesa-common-dev \
  libgl-dev \
  libgles-dev \
  libglew-dev \
  freeglut3-dev

RUN [[ "${OPENCL_PLATFORM}" != "intel" ]] || ( \
  apt-get update && apt-get install -y --no-install-recommends intel-opencl-icd \
)

RUN git clone https://github.com/KhronosGroup/OpenCL-CTS.git /src
RUN cd /src && git reset --hard "v2021-06-16-00" && git clean -xfd
RUN mkdir -p /src/out

WORKDIR "/src/out"
RUN cmake \
  -DOPENCL_LIBRARIES="-lOpenCL" \
  -DCL_INCLUDE_DIR=/usr/include \
  -DCL_LIB_DIR="/usr/lib/$(uname -m)-linux-gnu" \
  -DCL_LIBCLCXX_DIR="/usr/lib/$(uname -m)-linux-gnu" \
  -DUSE_CL_EXPERIMENTAL="${USE_CL_EXPERIMENTAL}" \
  -DGL_IS_SUPPORTED="${GL_IS_SUPPORTED}" \
  -DGLES_IS_SUPPORTED="${GLES_IS_SUPPORTED}" \
  /src
RUN make -j `nproc`

COPY entrypoint.sh /srv
ENTRYPOINT ["/srv/entrypoint.sh"]
