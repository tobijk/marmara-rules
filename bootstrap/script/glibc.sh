###############################################################################
# Glibc
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/glibc && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/glibc

echo "slibdir=/tools/$XPACK_TARGET_NAME/lib" >> configparms
echo "rootsbindir=/tools/$XPACK_TARGET_NAME/bin" >> configparms

BUILD_CC=gcc \
CC=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
CXX=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-g++ \
AR=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ar \
RANLIB=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/tools/$XPACK_TARGET_NAME \
    --libexecdir=/tools/$XPACK_TARGET_NAME/lib \
    --sysconfdir=/tools/$XPACK_TARGET_NAME/etc \
    --with-headers=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/include \
    --host=$XPACK_XTOOLS_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons \
    --enable-kernel=2.6.32 \
    BASH_SHELL=/usr/bin/zsh

make -j$XPACK_PARALLEL_JOBS
make install_root=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME install

