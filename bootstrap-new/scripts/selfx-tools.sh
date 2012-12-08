#!/bin/sh -xe

export PATH="$MARMARA_BOOTSTRAP_DIR/output/selfx/bin:$PATH"

build_binutils()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/binutils-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/binutils-selfx

    $MARMARA_BOOTSTRAP_DIR/output/build/binutils-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/selfx \
        --target=$MARMARA_SELFX_TYPE \
        --with-sysroot=$MARMARA_BOOTSTRAP_DIR/output/sysroot/tools \
        --disable-nls \
        --disable-multilib \
        --disable-werror

    make -j$MARMARA_PARALLEL_JOBS
    make install
}

build_gcc_pass1()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass1-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass1-selfx

    $MARMARA_BOOTSTRAP_DIR/output/build/gcc-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/selfx \
        --target=$MARMARA_SELFX_TYPE \
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
    make ARCH=$MARMARA_CANONICAL_SELFX_ARCH \
        INSTALL_HDR_PATH=$MARMARA_BOOTSTRAP_DIR/output/build/linux-src/headers-install \
            headers_install

    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/include/
    mv $MARMARA_BOOTSTRAP_DIR/output/build/linux-src/headers-install/include/* \
        $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/include/

    make mrproper
    rm -fr headers-install
}

build_glibc_headers()
{
    mkdir $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-headers-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-headers-selfx

    $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/libc/configure \
        --prefix=/tools/usr \
        --with-headers=$MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/include \
        --host=$MARMARA_SELFX_TYPE \
        --disable-profile \
        --without-gd \
        --without-cvs \
        --enable-add-ons

    make install-headers install_root=$MARMARA_BOOTSTRAP_DIR/output/sysroot \
        install-bootstrap-headers=yes

    make csu/subdir_lib

    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/lib/
    cp csu/crt1.o csu/crti.o csu/crtn.o $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/lib

    $MARMARA_BOOTSTRAP_DIR/output/selfx/bin/$MARMARA_SELFX_TYPE-gcc \
        -nostdlib \
        -nostartfiles \
        -shared \
        -x c \
        /dev/null \
        -o $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/lib/libc.so
}

build_gcc_pass2()
{
    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass2-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass2-selfx

    $MARMARA_BOOTSTRAP_DIR/output/build/gcc-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/selfx \
        --target=$MARMARA_SELFX_TYPE \
        --with-sysroot=$MARMARA_BOOTSTRAP_DIR/output/sysroot/tools \
        --disable-multilib \
        --disable-nls \
        --disable-libssp \
        --disable-libgomp \
        --disable-libmudflap \
        --enable-shared \
        --enable-languages=c

    make -j$MARMARA_PARALLEL_JOBS
    make install

    # modify GCC spec file to make it look in 'tools'
    SPECFILE="`dirname \`$MARMARA_BOOTSTRAP_DIR/output/selfx/bin/$MARMARA_SELFX_TYPE-gcc -print-libgcc-file-name\``/specs"
    $MARMARA_BOOTSTRAP_DIR/output/selfx/bin/$MARMARA_SELFX_TYPE-gcc -dumpspecs | sed \
      -e "s@/lib\(64\)\?/ld@/tools&@g" > $SPECFILE
}

build_glibc()
{
    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build/glibc-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/glibc-selfx

    echo "slibdir=/tools/usr/lib" >> configparms
    echo "rootsbindir=/tools/usr/sbin" >> configparms

    $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/libc/configure \
        --prefix=/tools/usr \
        --libexecdir=/tools/usr/lib \
        --sysconfdir=/tools/etc \
        --with-headers=$MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/include \
        --host=$MARMARA_SELFX_TYPE \
        --disable-profile \
        --without-gd \
        --without-cvs \
        --enable-add-ons \
        --enable-kernel=2.6.32 \
        BASH_SHELL=/tools/usr/bin/sh

    make -j$MARMARA_PARALLEL_JOBS
    make install_root=$MARMARA_BOOTSTRAP_DIR/output/sysroot install
}

build_gcc_pass3()
{
    mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass3-selfx
    cd $MARMARA_BOOTSTRAP_DIR/output/build/gcc-pass3-selfx

    # this is a dirty hack for a dirty build system
    ln -s . $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/tools
    #ln -s . $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/$MARMARA_TARGET_TYPE

    $MARMARA_BOOTSTRAP_DIR/output/build/gcc-src/configure \
        --prefix=$MARMARA_BOOTSTRAP_DIR/output/selfx \
        --target=$MARMARA_SELFX_TYPE \
        --with-sysroot=$MARMARA_BOOTSTRAP_DIR/output/sysroot/tools \
        --disable-multilib \
        --disable-nls \
        --enable-shared \
        --enable-threads=posix \
        --enable-__cxa_atexit \
        --disable-libstdcxx-pch \
        --enable-clocale=gnu \
        --enable-languages=c,c++

    make -j$MARMARA_PARALLEL_JOBS
    make install

    for i in $MARMARA_BOOTSTRAP_DIR/output/selfx/$MARMARA_SELFX_TYPE/lib/*; do
        if [ -n "`file -h $i | grep -e 'symbolic link' -e 'shared object'`" ]; then
            cp -d $i $MARMARA_BOOTSTRAP_DIR/output/sysroot/tools/usr/lib/
        fi
    done

    # modify GCC spec file to make it look in 'tools'
    SPECFILE="`dirname \`$MARMARA_BOOTSTRAP_DIR/output/selfx/bin/$MARMARA_SELFX_TYPE-gcc -print-libgcc-file-name\``/specs"
    $MARMARA_BOOTSTRAP_DIR/output/selfx/bin/$MARMARA_SELFX_TYPE-gcc -dumpspecs | sed \
      -e "s@/lib\(64\)\?/ld@/tools&@g" > $SPECFILE
}

build_binutils
build_gcc_pass1
build_linux_headers
build_glibc_headers
build_gcc_pass2
build_glibc
build_gcc_pass3

