###############################################################################
# GCC pass 2
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass2 && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/gcc-pass2

$XPACK_SOURCE_DIR/gcc/configure \
    --prefix=$STAGE1_DIR/$TARGET_NAME \
    --target=$XTOOLS_ARCH \
    --with-sysroot=$SYSTEM_ROOT/$TARGET_NAME/tools \
    --disable-multilib \
    --disable-nls \
    --disable-libssp \
    --disable-libgomp \
    --disable-libmudflap \
    --enable-languages=c

make -j$XPACK_PARALLEL_JOBS
make install

# modify GCC spec file to make it look in 'tools'
SPECFILE="`dirname \`$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc -print-libgcc-file-name\``/specs"
$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc -dumpspecs | sed \
  -e "s@/lib\(64\)\?/ld@/tools/$TARGET_NAME&@g" > $SPECFILE


