###############################################################################
# At this point we don't have a full-featured compiler, yet. We install the
# library headers and a stub for the shared library in order to compile a more
# complete version of the toolchain.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage2/glibc-headers && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage2/glibc-headers

BUILD_CC=gcc \
CC=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-gcc \
CXX=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-g++ \
AR=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-ar \
RANLIB=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/usr \
    --with-headers=$SYSTEM_ROOT/$TARGET_NAME/usr/include \
    --host=$TARGET_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons

make install-headers install_root=$SYSTEM_ROOT/$TARGET_NAME \
    install-bootstrap-headers=yes

make csu/subdir_lib
cp csu/crt1.o csu/crti.o csu/crtn.o $SYSTEM_ROOT/$TARGET_NAME/usr/lib

$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-gcc \
    -nostdlib \
    -nostartfiles \
    -shared \
    -x c \
    /dev/null \
    -o $SYSTEM_ROOT/$TARGET_NAME/usr/lib/libc.so

