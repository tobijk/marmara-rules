#!/bin/sh -xe

unpack_binutils()
{
    xpack \
        --source-dir=$MARMARA_BOOTSTRAP_DIR/output/build/binutils-src \
        --unpack $MARMARA_BOOTSTRAP_DIR/packages/binutils/pack/package.xml
}

unpack_gcc()
{
    xpack \
        --source-dir=$MARMARA_BOOTSTRAP_DIR/output/build/gcc-src \
        --unpack $MARMARA_BOOTSTRAP_DIR/packages/gcc/pack/package.xml
}

unpack_linux()
{
    xpack \
        --source-dir=$MARMARA_BOOTSTRAP_DIR/output/build/linux-src \
        --unpack $MARMARA_BOOTSTRAP_DIR/packages/linux/pack/package.xml
}

unpack_glibc()
{
    xpack \
        --source-dir=$MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src \
        --unpack $MARMARA_BOOTSTRAP_DIR/packages/eglibc/pack/package.xml

    mv $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/ports \
        $MARMARA_BOOTSTRAP_DIR/output/build/eglibc-src/libc/
}

unpack_binutils
unpack_gcc
unpack_linux
unpack_glibc

