#!/bin/sh

get_bootstrap_dir()
{
    __self="$0"
    __dirname=""

    if test "`echo $__self | cut -b1`" = "/"; then
        __dirname="`dirname $__self`"
    else
        __dirname="`dirname \`pwd\`/$__self`"
    fi

    __dirname=`cd $__dirname && pwd`
    cd - > /dev/null 2>&1

    echo $__dirname
}

get_script_dir()
{
    __bootstrap_dir="`eval get_bootstrap_dir`"
    echo "$__bootstrap_dir/scripts"
}

get_rc_dir()
{
    __bootstrap_dir="`eval get_bootstrap_dir`"
    echo "$__bootstrap_dir/rc.d"
}

get_build_type()
{
    __scriptdir=`eval get_bootstrap_dir`
    echo `$__scriptdir/config.guess`
}

get_selfx_type()
{
    __build_triplet=`eval get_build_type`
    echo "`echo $__build_triplet | sed 's/-[^-]\+/-selfx/'`"
}

get_target_type()
{
    __cpu="$1"
    __vendor="$2"
    __os="$3"
    __abi="$4"

    if test -n "$__vendor"; then
        echo "$__cpu-$__vendor-$__os-$__abi"
    else
        echo "$__cpu-$__os-$__abi"
    fi
}

get_target_arch()
{
    __cpu="$1"

    case "$__cpu" in
        arm*)
            echo "arm"
            ;;
        i?86)
            echo "i686"
            ;;
        *)
            echo "$__cpu"
            ;;
    esac
}

get_canonical_arch()
{
    __triplet=$1

    case "`echo $__triplet | sed 's/\([^-]*\).*/\1/'`" in
            i?86)
                echo "x86"
            ;;
            arm*)
                echo "arm"
            ;;
    esac
}

# source configuration file
. "`eval get_bootstrap_dir`/config"

# global exports
export MARMARA_BUILD_TYPE="`eval get_build_type`"
export MARMARA_SELFX_TYPE="`eval get_selfx_type`"
export MARMARA_TARGET_TYPE="`eval get_target_type \
    \\"$CONFIG_TARGET_CPU\\" \
    \\"$CONFIG_TARGET_VENDOR\\" \
    \\"$CONFIG_TARGET_OS\\" \
    \\"$CONFIG_TARGET_ABI\\"`"
export MARMARA_TARGET_ARCH="`eval get_target_arch $CONFIG_TARGET_CPU`"
export MARMARA_BOOTSTRAP_DIR="`eval get_bootstrap_dir`"
export MARMARA_CANONICAL_SELFX_ARCH="`eval get_canonical_arch $MARMARA_SELFX_TYPE`"
export MARMARA_CANONICAL_TARGET_ARCH="`eval get_canonical_arch $MARMARA_TARGET_TYPE`"

if [ -n "$CONFIG_PARALLEL_JOBS" ]; then
    export MARMARA_PARALLEL_JOBS=$CONFIG_PARALLEL_JOBS
else
    export MARMARA_PARALLEL_JOBS=2
fi

# run everything from the bootstrap folder
cd $MARMARA_BOOTSTRAP_DIR

# run scripts to perform bootstrap
RC_DIR="`eval get_rc_dir`"

case "$1" in
    bootstrap)
        mkdir -p $MARMARA_BOOTSTRAP_DIR/output/build
        mkdir -p $MARMARA_BOOTSTRAP_DIR/output/sysroot
        mkdir -p $MARMARA_BOOTSTRAP_DIR/output/selfx
        mkdir -p $MARMARA_BOOTSTRAP_DIR/output/cross

        ls "$RC_DIR" | sort | while read __script_name
        do
            echo "#"
            echo "# Running '$__script_name'"
            echo "#"

            if ! "$RC_DIR/$__script_name"; then
                echo "Error running '$RC_DIR/$__script_name'."
                exit 1
            fi
        done 2>&1 | tee -a bootstrap.log
        ;;
    clean)
        rm -fr $MARMARA_BOOTSTRAP_DIR/output/build
        rm -fr $MARMARA_BOOTSTRAP_DIR/output/sysroot
        rm -fr $MARMARA_BOOTSTRAP_DIR/output/selfx
        rm -fr $MARMARA_BOOTSTRAP_DIR/output/cross

        test -f bootstrap.log && rm -f bootstrap.log
        ;;
    *)
        echo "Usage: $0 (bootstrap|clean)"
        ;;
esac

