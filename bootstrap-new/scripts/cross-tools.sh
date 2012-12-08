#!/bin/sh -xe

export PATH="$MARMARA_BOOTSTRAP_DIR/output/cross/bin:$PATH"

build_binutils()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/binutils-cross
    cd $MARMARA_BOOTSTRAP_DIR/output/build/binutils-cross

    $MARMARA_BOOTSTRAP_DIR/output/build/binutils-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/cross \
        --target=$MARMARA_TARGET_TYPE \
        --with-sysroot=$MARMARA_BOOTSTRAP_DIR/output/sysroot \
        --disable-nls \
        --disable-multilib \
        --disable-werror

    make -j$MARMARA_PARALLEL_JOBS
    make install
}

build_gcc_pass1()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass1-cross
    cd $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass1-cross

    $MARMARA_BOOTSTRAP_DIR/output/build/gcc-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/cross \
        --target=$MARMARA_TARGET_TYPE \
        --disable-decimal-float \
        --without-headers \
        --with-newlib \
        --disable-libmudflap \
        --disable-libssp \
        --disable-libgomp \
        --disable-multilib \
        --disable-nls \
        --disable-threads \
        --disable-shared \
        --enable-languages=c

    make -j$MARMARA_PARALLEL_JOBS
    make install
}

build_linux_headers()
{
    cd $MARMARA_BOOTSTRAP_DIR/output/build/linux-src
    rm -fr headers-install
    mkdir headers-install

    make mrproper
    make ARCH=$MARMARA_CANONICAL_TARGET_ARCH \
        INSTALL_HDR_PATH=$MARMARA_BOOTSTRAP_DIR/output/build/linux-src/headers-install \
            headers_install

    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/include/
    mv $MARMARA_BOOTSTRAP_DIR/output/build/linux-src/headers-install/include/* \
        $MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/include/

    make mrproper
    rm -fr headers-install
}

build_glibc_headers()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-headers-cross
    cd $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-headers-cross

    $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/libc/configure \
        --prefix=/usr \
        --with-headers=$MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/include \
        --host=$MARMARA_TARGET_TYPE \
        --disable-profile \
        --without-gd \
        --without-cvs \
        --enable-add-ons

    make install-headers install_root=$MARMARA_BOOTSTRAP_DIR/output/sysroot \
        install-bootstrap-headers=yes

    make csu/subdir_lib

    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/lib/
    cp csu/crt1.o csu/crti.o csu/crtn.o $MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/lib

    $MARMARA_BOOTSTRAP_DIR/output/cross/bin/$MARMARA_TARGET_TYPE-gcc \
        -nostdlib \
        -nostartfiles \
        -shared \
        -x c \
        /dev/null \
        -o $MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/lib/libc.so
}

build_gcc_pass2()
{
    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass2-cross
    cd $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass2-cross

    $MARMARA_BOOTSTRAP_DIR/output/build/gcc-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/cross \
        --target=$MARMARA_TARGET_TYPE \
        --with-sysroot=$MARMARA_BOOTSTRAP_DIR/output/sysroot \
        --disable-multilib \
        --disable-nls \
        --disable-libssp \
        --disable-libgomp \
        --disable-libmudflap \
        --enable-shared \
        --enable-languages=c

    make -j$MARMARA_PARALLEL_JOBS
    make install
}

build_glibc()
{
    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build/glibc-cross
    cd $MARMARA_BOOTSTRAP_DIR/output/build/glibc-cross

    echo "slibdir=/usr/lib" >> configparms
    echo "rootsbindir=/usr/sbin" >> configparms

    $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/libc/configure \
        --prefix=/usr \
        --libexecdir=/usr/lib \
        --sysconfdir=/etc \
        --with-headers=$MARMARA_BOOTSTRAP_DIR/output/sysroot/usr/include \
        --host=$MARMARA_TARGET_TYPE \
        --disable-profile \
        --without-gd \
        --without-cvs \
        --enable-add-ons \
        --enable-kernel=2.6.32 \
        BASH_SHELL=/usr/bin/sh

    make -j$MARMARA_PARALLEL_JOBS
    make install_root=$MARMARA_BOOTSTRAP_DIR/output/sysroot install
}

build_binutils
build_gcc_pass1
build_linux_headers
build_glibc_headers
build_gcc_pass2
build_glibc

