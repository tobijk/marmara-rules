###############################################################################
# Compile a minimal GCC. All we want to get out of this build is libgcc and
# some essential headers, which we need in order to install the Glibc headers.
# The Glibc headers in turn are required to fully bootstrap GCC later.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage1/gcc-pass1 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage1/gcc-pass1

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$STAGE1_DIR/$TARGET_NAME \
    --target=$XTOOLS_ARCH \
    --disable-decimal-float \
    --without-headers \
    --with-newlib \
    --disable-libmudflap \
    --disable-libssp \
    --disable-libgomp \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-threads \
    --enable-languages=c

make -j$XPACK_PARALLEL_JOBS
make install

