###############################################################################
# Create a basic FSH
###############################################################################

install -dv -m 0755 $SYSTEM_ROOT/$TARGET_NAME
install -dv -m 0755 $XPACK_BASE_DIR/stage1/$TARGET_NAME
install -dv -m 0755 $XPACK_BASE_DIR/stage2/$TARGET_NAME
install -dv -m 0755 $XPACK_BASE_DIR/stage3/$TARGET_NAME

cd $SYSTEM_ROOT/$TARGET_NAME

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

install -dv -m 0755 tools tools/$TARGET_NAME \
    tools/$TARGET_NAME/include tools/$TARGET_NAME/lib

# some symlinks to trick the build system
ln -sf $TARGET_NAME tools/usr
ln -sf . tools/tools

