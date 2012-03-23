###############################################################################
# Binutils
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/binutils-pass1 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/binutils-pass1

$XPACK_SOURCE_DIR/binutils/configure \
    --target=$XTOOLS_ARCH \
    --prefix=$STAGE1_DIR/$TARGET_NAME \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME/tools \
    --disable-nls \
    --disable-multilib

make -j$XPACK_PARALLEL_JOBS
make install

