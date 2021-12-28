## About
The Dockerfile in this repository produces a statically-linked `vips` binary which should be usable on any Linux distribution. It includes all of [libvips' optional dependencies](https://github.com/libvips/libvips#optional-dependencies):

```
whalehub@pdh:~# vips --vips-config
enable debug: no
enable deprecated library components: no
enable modules: no
use fftw3 for FFT: yes
accelerate loops with orc: yes
ICC profile support with lcms: yes (lcms2)
zlib: yes
text rendering with pangocairo: yes
font file support with fontconfig: yes
RAD load/save: yes
Analyze7 load/save: yes
PPM load/save: yes
GIF load:  yes
EXIF metadata support with libexif: yes
JPEG load/save with libjpeg: yes (pkg-config)
JXL load/save with libjxl: yes (dynamic module: no)
JPEG2000 load/save with libopenjp2: yes
PNG load with libspng: yes
PNG load/save with libpng: yes (pkg-config libpng >= 1.2.9)
quantisation to 8 bit: yes
TIFF load/save with libtiff: yes (pkg-config libtiff-4)
image pyramid save: yes
HEIC/AVIF load/save with libheif: yes (dynamic module: no)
WebP load/save with libwebp: yes
PDF load with PDFium:  yes
PDF load with poppler-glib: no (dynamic module: no)
SVG load with librsvg-2.0: yes
EXR load with OpenEXR: yes
OpenSlide load: yes (dynamic module: no)
Matlab load with matio: yes
NIfTI load/save with niftiio: yes
FITS load/save with cfitsio: yes
GIF save with cgif: yes
Magick package: MagickCore (dynamic module: no)
Magick API version: magick6
load with libMagickCore: yes
save with libMagickCore: yes

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
