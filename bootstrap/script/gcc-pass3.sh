###############################################################################
# GCC pass 3
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/gcc-pass3 && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/gcc-pass3

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME \
    --target=$XPACK_XTOOLS_ARCH \
    --with-sysroot=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME \
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

for i in $XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/$XPACK_XTOOLS_ARCH/lib/*; do
    if [ -n "`file -h $i | grep -e 'symbolic link' -e 'shared object'`" ]; then
        cp -d $i $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/lib/
    fi
done

# modify GCC spec file to make it look in 'tools'
SPECFILE="`dirname \`$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc -print-libgcc-file-name\``/specs"
$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc -dumpspecs | sed \
  -e "s@/lib\(64\)\?/ld@/tools/$XPACK_TARGET_NAME&@g" > $SPECFILE

