###############################################################################
# Create an almost FHS compliant directory structure, but without the 'local'
# branch, plus a directory 'tools' into which we will bootstrap a self-
# contained toolchain for the intended target architecture.
###############################################################################

install -dv -m 0755 $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME
install -dv -m 0755 $XPACK_BASE_DIR/tools/$XPACK_TARGET_NAME

cd $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME

install -dv -m 0755 boot etc etc/opt home mnt opt
install -dv -m 0755 usr usr/local media srv var
install -dv -m 0750 root
install -dv -m 1777 tmp var/tmp
( cd usr 
    install -dv -m 0755 bin include lib sbin src share man
    ( cd share
        install -dv -m 0755 doc info locale man
        install -dv -m 0755 misc terminfo zoneinfo
        ( cd man
            install -dv -m 0755 man1 man2 man3 man4 man5 man6 man7 man8
        )
    )
)
( cd var
    install -dv -m 0755 lock log mail run spool
    install -dv -m 0755 opt cache lib lib/misc lib/locate
)
test -h bin  || ln -sf usr/bin bin
test -h sbin || ln -sf usr/sbin sbin
test -h lib  || ln -sf usr/lib lib

# add 'tools' directory

install -dv -m 0755 tools tools/$XPACK_TARGET_NAME \
    tools/$XPACK_TARGET_NAME/include tools/$XPACK_TARGET_NAME/lib

# create some diversions so that headers and libs are found
rmdir $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/include
ln -sf ../tools/$XPACK_TARGET_NAME/include $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/include
rmdir $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/lib
ln -sf ../tools/$XPACK_TARGET_NAME/lib $XPACK_BASE_DIR/sysroot/$XPACK_TARGET_NAME/usr/lib
