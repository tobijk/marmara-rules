###############################################################################
# Kernel headers
###############################################################################

cd $XPACK_SOURCE_DIR/linux
rm -fr tmp-install
mkdir tmp-install

case "$XPACK_TARGET_NAME" in
        i?86)
        KERNEL_ARCH=x86
esac

make mrproper
make ARCH=$KERNEL_ARCH headers_check
make ARCH=$KERNEL_ARCH INSTALL_HDR_PATH=$XPACK_SOURCE_DIR/linux/tmp-install \
    headers_install

mv $XPACK_SOURCE_DIR/linux/tmp-install/include/* \
    $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/tools/$XPACK_TARGET_NAME/include/

make mrproper
rm -fr $XPACK_SOURCE_DIR/linux/tmp-install
