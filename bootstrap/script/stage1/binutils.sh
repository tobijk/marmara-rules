###############################################################################
# Cross 'binutils' for host platform
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage1/binutils && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage1/binutils

$XPACK_SOURCE_DIR/binutils/configure \
    --target=$XTOOLS_ARCH \
    --prefix=$STAGE1_DIR/$TARGET_NAME \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME/tools \
    --disable-nls \
    --disable-multilib

make -j$XPACK_PARALLEL_JOBS
make install

