###############################################################################
# After having built the full (meaning not just the headers) Glibc, we can now
# build a complete toolchain including C++ support.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass3 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass3

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$STAGE1_DIR/$TARGET_NAME \
    --target=$XTOOLS_ARCH \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME/tools \
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

for i in $STAGE1_DIR/$TARGET_NAME/$XTOOLS_ARCH/lib/*; do
    if [ -n "`file -h $i | grep -e 'symbolic link' -e 'shared object'`" ]; then
        cp -d $i $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/lib/
    fi
done

# modify GCC spec file to make it look in 'tools'
SPECFILE="`dirname \`$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc -print-libgcc-file-name\``/specs"
$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc -dumpspecs | sed \
  -e "s@/lib\(64\)\?/ld@/tools/$TARGET_NAME&@g" > $SPECFILE

