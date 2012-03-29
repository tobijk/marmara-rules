###############################################################################
# The Glibc headers are installed now, which means we can generate a GCC with
# more complete functionality than before. In stage1 there is yet another
# build of GCC coming up, once we have a full-featured Glibc installation.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage2/gcc-pass2 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage2/gcc-pass2

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$STAGE2_DIR/$TARGET_NAME \
    --target=$TARGET_ARCH \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME \
    --disable-multilib \
    --disable-nls \
    --disable-libssp \
    --disable-libgomp \
    --disable-libmudflap \
    --enable-languages=c

make -j$XPACK_PARALLEL_JOBS
make install

