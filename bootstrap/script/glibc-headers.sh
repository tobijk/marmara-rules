###############################################################################
# At this point we don't have a full-featured compiler, yet. We install the
# library headers and a stub for the shared library in order to compile a more
# complete version of the toolchain.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/glibc-headers && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/glibc-headers

BUILD_CC=gcc \
CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/tools/$TARGET_NAME \
    --with-headers=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/include \
    --host=$XTOOLS_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons

make install-headers install_root=$SYSTEM_ROOT/$TARGET_NAME \
    install-bootstrap-headers=yes

make csu/subdir_lib
cp csu/crt1.o csu/crti.o csu/crtn.o $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/lib

$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
    -nostdlib \
    -nostartfiles \
    -shared \
    -x c \
    /dev/null \
    -o $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/lib/libc.so

