###############################################################################
# GLibc headers
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/glibc-headers && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/glibc-headers

BUILD_CC=gcc \
CC=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
CXX=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-g++ \
AR=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ar \
RANLIB=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/tools/$XPACK_TARGET_NAME \
    --with-headers=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/include \
    --host=$XPACK_XTOOLS_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons

make install-headers install_root=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME \
    install-bootstrap-headers=yes

make csu/subdir_lib
cp csu/crt1.o csu/crti.o csu/crtn.o $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/lib

$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
    -nostdlib \
    -nostartfiles \
    -shared \
    -x c \
    /dev/null \
    -o $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/lib/libc.so

