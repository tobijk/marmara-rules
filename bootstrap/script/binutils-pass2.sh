###############################################################################
# Binutils
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/binutils-pass2 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/binutils-pass2

CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/binutils/configure \
    --host=$XTOOLS_ARCH \
    --target=$TARGET_ARCH \
    --prefix=/tools/$TARGET_NAME \
    --program-transform-name='s@[^-]*-@@g' \
    --with-sysroot=/ \
    --with-build-sysroot=$SYSTEM_ROOT/$TARGET_NAME/tools \
    --disable-nls \
    --disable-multilib

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

