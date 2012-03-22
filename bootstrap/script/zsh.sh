###############################################################################
# Zsh
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/zsh && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/zsh

CC=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
CXX=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-g++ \
AR=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ar \
RANLIB=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/zsh/configure \
    --host=$XPACK_XTOOLS_ARCH \
    --prefix=/tools/$XPACK_TARGET_NAME \
    --sysconfdir=/tools/$XPACK_TARGET_NAME/etc \
    --enable-etcdir=/tools/$XPACK_TARGET_NAME/etc/zsh \
    --enable-function-subdirs

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME install

ln -s zsh $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/bin/sh

