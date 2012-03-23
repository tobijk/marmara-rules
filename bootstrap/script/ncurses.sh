###############################################################################
# NCurses
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/ncurses && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/ncurses

CC=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-gcc \
CXX=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-g++ \
AR=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ar \
RANLIB=$STAGE1_DIR/$TARGET_NAME/bin/$XTOOLS_ARCH-ranlib \
$XPACK_SOURCE_DIR/ncurses/configure \
    --prefix=/tools/$TARGET_NAME \
    --host=$XTOOLS_ARCH \
    --mandir=/tools/$TARGET_NAME/share/man \
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
    --with-default-terminfo-dir=/tools/$TARGET_NAME/share/terminfo \
    --with-terminfo-dirs=/tools/$TARGET_NAME/share/terminfo \
    --with-ticlib \
    --disable-nls \
    --with-shared

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

