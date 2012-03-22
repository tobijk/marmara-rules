###############################################################################
# GCC pass 2
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/gcc-pass2 && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/gcc-pass2

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME \
    --target=$XPACK_XTOOLS_ARCH \
    --with-sysroot=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME \
    --disable-multilib \
    --disable-nls \
    --disable-libssp \
    --disable-libgomp \
    --disable-libmudflap \
    --enable-languages=c

make -j$XPACK_PARALLEL_JOBS
make install

# modify GCC spec file to make it look in 'tools'
SPECFILE="`dirname \`$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc -print-libgcc-file-name\``/specs"
$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc -dumpspecs | sed \
  -e "s@/lib\(64\)\?/ld@/tools/$XPACK_TARGET_NAME&@g" > $SPECFILE


