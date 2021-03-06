###############################################################################
# Sanitized kernel headers for building libc
###############################################################################

cd $XPACK_SOURCE_DIR/linux
rm -fr tmp-install
mkdir tmp-install

case "`echo $NATIVE_ARCH | sed 's/\([^-]*\).*/\1/'`" in
        i?86)
        KERNEL_ARCH=x86
        ;;
        arm*)
        KERNEL_ARCH=arm
        ;;
esac

make mrproper
make ARCH=$KERNEL_ARCH headers_check
make ARCH=$KERNEL_ARCH INSTALL_HDR_PATH=$XPACK_SOURCE_DIR/linux/tmp-install \
    headers_install

mv $XPACK_SOURCE_DIR/linux/tmp-install/include/* \
    $SYSTEM_ROOT/$TARGET_NAME/tools/$TARGET_NAME/include/

make mrproper
rm -fr $XPACK_SOURCE_DIR/linux/tmp-install
