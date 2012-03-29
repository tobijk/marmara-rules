###############################################################################
# After having built the full (meaning not just the headers) Glibc, we can now
# build a complete toolchain including C++ support.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage2/gcc-pass3 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage2/gcc-pass3

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$STAGE2_DIR/$TARGET_NAME \
    --target=$TARGET_ARCH \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME \
    --disable-multilib \
    --disable-nls \
    --enable-shared \
    --enable-threads=posix \
    --enable-__cxa_atexit \
    --disable-libstdcxx-pch \
    --enable-clocale=gnu \
    --enable-languages=c,c++

make -j$XPACK_PARALLEL_JOBS
make install

