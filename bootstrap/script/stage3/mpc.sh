###############################################################################
# Compile a cross binutils for the actual target platform. The resulting tools
# will be installed in the 'tools' directory in the |actual| target sysroot.
###############################################################################

mkdir -p $XPACK_BUILD_DIR/$TARGET_NAME/stage3/mpc && \
    cd $XPACK_BUILD_DIR/$TARGET_NAME/stage3/mpc

for la_file in $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/lib/*.la; do
    test -f $la_file && rm -fr $la_file
done

$XPACK_SOURCE_DIR/gcc/mpc/configure \
    --host=$XTOOLS_ARCH \
    --prefix=/tools/$TARGET_NAME \
    --with-gmp-lib=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/lib \
    --with-gmp-include=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/include \
    --with-mpfr-lib=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARET_NAME/lib \
    --with-mpfr-include=$SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/include

#sed -i 's@^hardcode_libdir_flag_spec=.*@hardcode_libdir_flag_spec=""@g' libtool
#sed -i 's@^hardcode_into_libs=.*@hardcode_into_libs=no@g' libtool

sed -i 's/^hardcode_libdir_flag_spec.*$'/'hardcode_libdir_flag_spec=" -D__LIBTOOL_NO_RPATH__ "/' libtool

make -j$XPACK_PARALLEL_JOBS
make DESTDIR=$SYSTEM_ROOT/$TARGET_NAME install

