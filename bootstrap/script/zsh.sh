###############################################################################
# Zsh
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/zsh && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/zsh

CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/zsh/configure \
    --host=$XTOOLS_ARCH \
    --prefix=/tools/$TARGET_NAME \
    --sysconfdir=/tools/$TARGET_NAME/etc \
    --enable-etcdir=/tools/$TARGET_NAME/etc/zsh \
    --enable-function-subdirs

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

ln -s zsh $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/bin/sh

