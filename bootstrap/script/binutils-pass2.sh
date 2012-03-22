###############################################################################
# Binutils
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/binutils-pass2 && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/binutils-pass2

CC=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
CXX=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-g++ \
AR=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ar \
RANLIB=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/binutils/configure \
    --host=$XPACK_XTOOLS_ARCH \
    --target=$XPACK_TARGET_ARCH \
    --prefix=/tools/$XPACK_TARGET_NAME \
    --program-transform-name='s@[^-]*-@@g' \
    --with-sysroot=/ \
    --disable-nls \
    --disable-multilib

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME install

