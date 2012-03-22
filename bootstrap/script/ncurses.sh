###############################################################################
# NCurses
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/ncurses && \
    cd $XPACK_BUILD_DIR/$XPACK_TARGET_NAME/ncurses

CC=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-gcc \
CXX=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-g++ \
AR=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ar \
RANLIB=$XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME/bin/$XPACK_XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/ncurses/configure \
    --prefix=/tools/$XPACK_TARGET_NAME \
    --host=$XPACK_XTOOLS_ARCH \
    --mandir=/tools/$XPACK_TARGET_NAME/share/man \
    --without-profile \
    --without-debug \
    --disable-rpath \
    --enable-echo \
    --enable-const \
    --without-ada \
    --without-tests \
    --enable-symlinks \
    --disable-lp64 \
    --with-chtype=long \
    --with-mmask-t=long \
    --disable-termcap \
    --with-default-terminfo-dir=/tools/$XPACK_TARGET_NAME/share/terminfo \
    --with-terminfo-dirs=/tools/$XPACK_TARGET_NAME/share/terminfo \
    --with-ticlib \
    --disable-nls \
    --with-shared

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME install

