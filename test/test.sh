#!/bin/bash
set -euo pipefail

# Inspired by https://raw.githubusercontent.com/openSUSE/microos-tools/16251c081afecbe99effd63dbdb2d4b8539481d8/test/test.sh

function print ()
{
    printf " \n\033[%d;1m%s\033[0m\n" $1 "$2"
}

# Create a tmpdir and delete it on exit 
tmpdir="$(mktemp -d)"
trap "rm -rf '$tmpdir'" EXIT

QEMU_BASEARGS=(-accel kvm -accel tcg -nographic -m 1024 -smp 4 -virtfs "local,path=${tmpdir},mount_tag=tmpdir,security_model=mapped-xattr")

# Prepare the temporary dir
cp -r "test/testscript" "artifacts" "${tmpdir}"
ls -la "${tmpdir}/artifacts"
cd "$tmpdir"

print 32 "# Downloading the latest Tumbleweed Minimal image..."
wget --no-verbose --progress=bar:force:noscroll https://download.opensuse.org/tumbleweed/appliances/openSUSE-Tumbleweed-Minimal-VM.x86_64-kvm-and-xen.qcow2

print 32 "# Starting the VM and runnig the testscript..."
timeout 300 qemu-system-x86_64 "${QEMU_BASEARGS[@]}" -drive if=virtio,file=openSUSE-Tumbleweed-Minimal-VM.x86_64-kvm-and-xen.qcow2 \
        -fw_cfg name=opt/org.opensuse.combustion/script,file=testscript | sed 's/\x1b\[0;30;47m//g' # sed 's/\x1b\[[0-9;]*m//g'

# Exit if testscript fails to complete
set +e
if ! [ -e "${tmpdir}/done" ]; then
	print 31 "ERROR: Test failed"
	exit
fi

echo 0 > ${tmpdir}/exitcode

# Set the exitcode to 100 aka exit with warning if there is output in the first stage
for report in ${tmpdir}/stage-1/*; do
	grep -q -e "no matches" $report
	if ! [ $? -eq 0 ]; then
		echo 100 > ${tmpdir}/exitcode
	fi
done
# And inform the developer in the log
if [ $(cat $tmpdir/exitcode) -eq 100 ]; then
	print 32 "WARNING: Have a look at the first stage"
fi

# Set the exitcode to 200 if there is output in the second stage...
for report in ${tmpdir}/stage-2/{restorecon,journal,unconfined}; do
	grep -q -e "no matches" $report
	if ! [ $? -eq 0 ]; then
		echo 200 > ${tmpdir}/exitcode
	fi
done
# ... or if there is a difference in the ausearch report compared to the first stage
diff ${tmpdir}/stage-1/ausearch ${tmpdir}/stage-2/ausearch > /dev/null
if ! [ $? -eq 0 ]; then
	echo 200 > ${tmpdir}/exitcode
fi
# And inform the developer in the log
if [ $(cat ${tmpdir}/exitcode) -eq 200 ]; then
	print 31 "ERROR: Have a look at the second stage"
fi

# Exit with the previously set exitcode
exit $(cat ${tmpdir}/exitcode)
