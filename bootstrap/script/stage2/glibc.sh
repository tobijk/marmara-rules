###############################################################################
# We have bootstrap a usuable version of GCC and are now ready to build the C
# library.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage2/glibc && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage2/glibc

echo "slibdir=/usr/lib" >> configparms
echo "rootsbindir=/usr/bin" >> configparms

BUILD_CC=gcc \
CC=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-gcc \
CXX=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-g++ \
AR=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-ar \
RANLIB=$STAGE2_DIR/$TARGET_NAME/bin/$TARGET_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/usr \
    --libexecdir=/usr/lib \
    --sysconfdir=/etc \
    --with-headers=$SYSTEM_ROOT/$TARGET_NAME/usr/include \
    --host=$TARGET_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons \
    --enable-kernel=2.6.32 \
    BASH_SHELL=/tools/$TARGET_NAME/bin/zsh

make -j$XPACK_PARALLEL_JOBS
make install_root=$SYSTEM_ROOT/$TARGET_NAME install

