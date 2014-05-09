#! /bin/bash -eux

# Periodic job to keep the local mirror updated. This script takes snapshot
# of any arbitrary directory, if the update job actually says there ARE
# updates to be downloaded for one particular repository and one particular
# distribution. For example, you can say that for in.archive.ubuntu.com
# repository, for Precise, if there are any updates, take a snapshot.
# Currently, you cannot specify more than one repository, or distribution to
# take snapshot against.
#
# This script writes status to a file, so that this script can be added to
# a cron easily.

MIRRORCONF=/etc/apt/mirror.list
SNAPSHOTSCRIPT=/home/repo/pipeline/repo-sync/snapshot.sh
DIST=trusty
RELEASE=/home/repo/localrepo/mirror/ubuntu-server-x8664\:81/myrepo/ubuntu/dists/$DIST/Release

SNAPSRC=/home/repo/localrepo
SNAPDEST=/home/repo/repo-snapshots

OLDMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

echo "---------------------------------------------"

sudo apt-mirror $MIRRORCONF

NEWMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

echo $OLDMD5
echo $NEWMD5
if [ "$OLDMD5" = "$NEWMD5" ]; then
    echo "time: `date`. No new packages found"
    echo "Old and new MD5: $OLDMD5 $NEWMD5"
else
    $SNAPSHOTSCRIPT $SNAPSRC $SNAPDEST
    echo "time: `date`. New packages found."
    echo "Old and new MD5: $OLDMD5 $NEWMD5"
fi

