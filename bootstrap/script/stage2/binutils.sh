###############################################################################
# Compile a cross binutils where the target platform is identical to whatever
# is the native platform at the time. This is done to gain some isolation from
# the host, as we continue to bootstrap a |fully| self-contained toolchain.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage2/binutils && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage2/binutils

$XPACK_SOURCE_DIR/binutils/configure \
    --target=$TARGET_ARCH \
    --prefix=$STAGE2_DIR/$TARGET_NAME \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME \
    --disable-nls \
    --disable-multilib \
    --disable-werror

make -j$XPACK_PARALLEL_JOBS
make install

