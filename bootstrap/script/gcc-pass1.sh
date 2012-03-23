###############################################################################
# GCC pass 1
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass1 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass1

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

