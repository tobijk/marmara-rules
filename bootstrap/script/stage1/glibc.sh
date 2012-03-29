###############################################################################
# Compile libc
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage1/glibc && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage1/glibc

echo "slibdir=/tools/$TARGET_NAME/lib" >> configparms
echo "rootsbindir=/tools/$TARGET_NAME/bin" >> configparms

BUILD_CC=gcc \
CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/eglibc/libc/configure \
    --prefix=/tools/$TARGET_NAME \
    --libexecdir=/tools/$TARGET_NAME/lib \
    --sysconfdir=/tools/$TARGET_NAME/etc \
    --with-headers=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/include \
    --host=$XTOOLS_ARCH \
    --disable-profile \
    --without-gd \
    --without-cvs \
    --enable-add-ons \
    --enable-kernel=2.6.32 \
    BASH_SHELL=/tools/$TARGET_NAME/bin/zsh

make -j$XPACK_PARALLEL_JOBS
make install_root=$SYSTEM_ROOT/$TARGET_NAME install

