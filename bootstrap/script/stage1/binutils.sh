###############################################################################
# Compile a cross binutils where the target platform is identical to whatever
# is the native platform at the time. This is done to gain some isolation from
# the host, as we continue to bootstrap a |fully| self-contained toolchain.
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

