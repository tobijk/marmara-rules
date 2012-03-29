###############################################################################
# After having built the full (meaning not just the headers) Glibc, we can now
# build a complete toolchain including C++ support.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage3/gcc && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage3/gcc

for subdir in mpfr mpc gmp; do
    rm -fr $XPACK_SOURCE_DIR/gcc/$subdir
done

$XPACK_SOURCE_DIR/gcc/configure \
    --host=$XTOOLS_ARCH \
    --target=$TARGET_ARCH \
    --prefix=/tools/$TARGET_NAME \
    --program-transform-name='s@[^-]*-@@g' \
    --with-sysroot=/ \
    --with-build-sysroot=$SYSTEM_ROOT/$TARGET_NAME \
    --disable-multilib \
    --disable-nls \
    --enable-shared \
    --enable-threads=posix \
    --enable-__cxa_atexit \
    --disable-libstdcxx-pch \
    --enable-clocale=gnu \
    --enable-languages=c,c++

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

for i in $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/$TARGET_ARCH/lib/*; do
    if [ -n "`file -h $i | grep -e 'symbolic link' -e 'shared object'`" ]; then
        cp -d $i $SYSTEM_ROOT/$TARGET_NAME/usr/lib/
    fi
done

