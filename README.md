## About
The Dockerfile in this repository produces a statically-linked `vips` binary which should be usable on any Linux distribution. It includes all of [libvips' optional dependencies](https://github.com/libvips/libvips#optional-dependencies):

```
whalehub@pdh:~# vips --vips-config
enable debug: false
enable deprecated library components: true
enable modules: false
use fftw3 for FFT: true
accelerate loops with orc: true
ICC profile support with lcms: true
zlib: true
text rendering with pangocairo: true
font file support with fontconfig: true
RAD load/save: true
Analyze7 load/save: true
PPM load/save: true
GIF load: true
GIF save with cgif: true
EXIF metadata support with libexif: true
JPEG load/save with libjpeg: true
JXL load/save with libjxl: true (dynamic module: false)
JPEG2000 load/save with libopenjp2: true
PNG load with libspng: true
PNG load/save with libpng: false
selected quantisation package: imagequant
TIFF load/save with libtiff: true
image pyramid save: true
HEIC/AVIF load/save with libheif: true (dynamic module: false)
WebP load/save with libwebp: true
PDF load with PDFium: true
PDF load with poppler-glib: false (dynamic module: false)
SVG load with librsvg-2.0: true
EXR load with OpenEXR: true
OpenSlide load: true (dynamic module: false)
Matlab load with matio: true
NIfTI load/save with niftiio: true
FITS load/save with cfitsio: true
Magick package: true (dynamic module: false)
Magick API version: magick6
load with libMagickCore: true
save with libMagickCore: true
```

The static binary can be downloaded from the [Releases page](https://github.com/whalehub/libvips-static/releases) or built locally with Docker.

### Building
In order to use this Dockerfile, you need to be running Docker 18.06 or newer because it makes use of a couple of [BuildKit](https://github.com/moby/buildkit) features.

To create a statically-linked `vips` binary in the current working directory, execute either one of the following commands:

```
DOCKER_BUILDKIT=1 docker build -o . .
```

```
docker buildx build -o . .
```
