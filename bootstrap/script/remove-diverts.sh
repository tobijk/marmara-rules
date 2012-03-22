###############################################################################
# Undo dirty tricks
###############################################################################

# remove diversions
rm -f $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/include
rm -f $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/lib
install -dv -m 0755 $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/include
install -dv -m 0755 $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/lib

