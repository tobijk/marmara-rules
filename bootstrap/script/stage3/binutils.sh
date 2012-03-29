###############################################################################
# Compile a cross binutils for the actual target platform. The resulting tools
# will be installed in the 'tools' directory in the |actual| target sysroot.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage3/binutils && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage3/binutils

CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/binutils/configure \
    --host=$XTOOLS_ARCH \
    --target=$TARGET_ARCH \
    --prefix=/tools/$TARGET_NAME \
    --program-transform-name='s@[^-]*-@@g' \
    --with-sysroot=/ \
    --with-build-sysroot=$SYSTEM_ROOT/$TARGET_NAME \
    --disable-nls \
    --disable-multilib \
    --disable-werror

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

