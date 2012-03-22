###############################################################################
# Binutils
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/binutils-pass1 && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/binutils-pass1

$XPACK_SOURCE_DIR/binutils/configure \
    --target=$XPACK_XTOOLS_ARCH \
    --prefix=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME \
    --with-sysroot=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME \
    --disable-nls \
    --disable-multilib

make -j$XPACK_PARALLEL_JOBS
make install

