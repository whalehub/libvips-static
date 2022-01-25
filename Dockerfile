# syntax=docker/dockerfile:1.4.2
FROM debian:experimental AS builder

ENV VIPS_VERSION="8.13.0-rc2"
ENV VIPS_URL="https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz"

ENV LIBSPNG_VERSION="0.7.2"
ENV LIBSPNG_URL="https://github.com/randy408/libspng/archive/refs/tags/v${LIBSPNG_VERSION}.tar.gz"

ENV PDFIUM_VERSION="5187"
ENV PDFIUM_URL="https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/${PDFIUM_VERSION}/pdfium-linux-x64.tgz"

ENV STATICX_VERSION="0.13.6"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20220101 experimental main contrib non-free" \
  >> /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    file \
    gobject-introspection \
    libcfitsio-dev \
    libcgif-dev \
    libexif-dev \
    libexpat1-dev \
    libfftw3-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libgsf-1-dev \
    libheif-dev \
    libimagequant-dev \
    libjpeg62-turbo-dev \
    libjxl-dev=0.6.1+ds-5 \
    liblcms2-dev \
    libmagick++-6.q16-dev \
    libmatio-dev \
    libnifti2-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libopenslide-dev \
    liborc-0.4-dev \
    libpango1.0-dev \
    libpng-dev \
    librsvg2-dev \
    libtiff-dev \
    libwebp-dev \
    meson \
    patchelf \
    pkg-config \
    python3-minimal \
    python3-pip \
    python3-setuptools \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install "staticx==${STATICX_VERSION}"

WORKDIR /build-libspng
RUN curl -L "${LIBSPNG_URL}" | tar -xzf- --strip=1
RUN meson build --buildtype=release --prefix=/usr --libdir=lib/x86_64-linux-gnu

WORKDIR /build-libspng/build
RUN ninja
RUN ninja install

WORKDIR /usr
RUN curl -L "${PDFIUM_URL}" | tar -xzf- include
RUN curl -L "${PDFIUM_URL}" | tar -xzf- --strip=1 -C lib/x86_64-linux-gnu lib/libpdfium.so

COPY <<EOF lib/pkgconfig/pdfium.pc
prefix=/usr
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib/x86_64-linux-gnu

Name: pdfium
Description: pdfium
Version: ${PDFIUM_VERSION}
Cflags: -I\${includedir}
Libs: -L\${libdir} -lpdfium
EOF

COPY <<EOF lib/pkgconfig/niftiio.pc
prefix=/usr
exec_prefix=\${prefix}
includedir=\${prefix}/include/nifti
libdir=\${exec_prefix}/lib/x86_64-linux-gnu

Name: niftiio
Description: niftiio
Version: 3.0.1
Requires.private: zlib
Cflags: -I\${includedir}
Libs: -L\${libdir} -lniftiio -lznz
EOF

WORKDIR /build-vips
RUN curl -L "${VIPS_URL}" | tar -xzf- --strip=1
RUN meson setup build --default-library=static --buildtype=release --prefix=/usr --libdir=lib/x86_64-linux-gnu

WORKDIR /build-vips/build
RUN meson compile
RUN meson install

RUN staticx --no-compress /usr/bin/vips /bin/vips
RUN strip -s /bin/vips

FROM scratch

LABEL org.opencontainers.image.authors="whalehub <admin@datahoarder.dev>"
LABEL org.opencontainers.image.description="A fast image processing library with low memory needs."
LABEL org.opencontainers.image.documentation="https://github.com/whalehub/libvips-static"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.source="https://github.com/whalehub/libvips-static"
LABEL org.opencontainers.image.title="libvips"
LABEL org.opencontainers.image.url="https://github.com/whalehub/libvips-static"
LABEL org.opencontainers.image.vendor="whalehub <admin@datahoarder.dev>"
LABEL org.opencontainers.image.version="8.13.0-rc1"

COPY --from=builder /bin/vips /vips
