###############################################################################
# Compile a cross binutils for the actual target platform. The resulting tools
# will be installed in the 'tools' directory in the |actual| target sysroot.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage3/mpfr && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage3/mpfr

$XPACK_SOURCE_DIR/gcc/mpfr/configure \
    --host=$XTOOLS_ARCH \
    --prefix=/tools/$TARGET_NAME

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

