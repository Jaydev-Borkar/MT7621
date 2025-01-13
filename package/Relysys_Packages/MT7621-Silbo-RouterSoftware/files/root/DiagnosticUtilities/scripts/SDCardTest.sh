#!/bin/sh


MainMountPoint="/dev/mmcblk0"
AppSrcMountPoint="/dev/mmcblk0p1"
AppDataMountPoint="/dev/mmcblk0p2"
AppSrcMountPath="/mnt/disk/AppSrc"
AppDataMountPath="/mnt/disk/AppData"

CardIdentify()
{
    if [ -b "$MainMountPoint" ]
    then
        MainMountPointStatus="Detected"
    else
        MainMountPointStatus="Not Detected"
    fi
    
    if [ -b "$AppSrcMountPoint" ]
    then
        AppSrcMountPointStatus="Detected"
    else
        AppSrcMountPointStatus="Not Detected"
    fi
    
    if [ -b "$AppDataMountPoint" ]
    then
        AppDataMountPointstatus="Detected"
    else
        AppDataMountPointstatus="Not Detected"
    fi
    
}

MountStatus()
{
    AppSrcMountStatus=$(grep -sw "$AppSrcMountPath" /proc/mounts 2>&1)
    if [ "x$AppSrcMountStatus" = "x" ]
    then
        AppSrcMountStatus="Not Mounted"
    fi
    
    AppDataMountStatus=$(grep -sw "$AppDataMountPath" /proc/mounts 2>&1)
    if [ "x$AppDataMountStatus" = "x" ]
    then
        AppDataMountStatus="Not Mounted"
    fi
}

UnmountSDCard()
{
    AppSrcUnMountStatus=$(/bin/umount "$AppSrcMountPath" 2>&1)
    AppSrcUnMountRetVal=$?
    if [ "$AppSrcUnMountRetVal" = "0" ]
    then
        AppSrcUnMountStatus="unmounted"
    else
        if [ "x$AppSrcUnMountStatus" = "x" ]
        then
            AppSrcUnMountStatus="Failed to unmount"
        fi
    fi
    
    AppDataUnMountStatus=$(/bin/umount "$AppDataMountPath" 2>&1)
    AppDataUnMountRetVal=$?
    if [ "$AppDataUnMountRetVal" = "0" ]
    then
        AppDataUnMountStatus="unmounted"
    else
        if [ "x$AppDataUnMountStatus" = "x" ]
        then
            AppDataUnMountStatus="Failed to unmount"
        fi
    fi
}

CheckSDcard()
{
    AppSrcCheckStatus=$(fsck.ext4 -p $AppSrcMountPoint)
    AppDataCheckStatus=$(fsck.ext4 -p $AppDataMountPoint)
}

ReMountSDCard()
{
    AppSrcReMountStatus=$(/bin/mount -t ext4 -o rw,relatime,data=ordered $AppSrcMountPoint $AppSrcMountPath 2>&1)
    AppSrcReMountRetVal=$?
    if [ "$AppSrcReMountRetVal" = "0" ]
    then
        AppSrcReMountStatus="mounted"
    else
        if [ "x$AppSrcReMountStatus" = "x" ]
        then
            AppSrcReMountStatus="Failed to mount"
        fi
    fi
    
    AppDataReMountStatus=$(/bin/mount -t ext4 -o rw,relatime,data=ordered $AppDataMountPoint $AppDataMountPath 2>&1)
    AppDataReMountRetVal=$?
    if [ "$AppDataReMountRetVal" = "0" ]
    then
        AppDataReMountStatus="mounted"
    else
        if [ "x$AppDataReMountStatus" = "x" ]
        then
            AppDataReMountStatus="Failed to mount"
        fi
    fi

}

echo "Card Indentification :"
CardIdentify
echo "MainMountPoint[$MainMountPoint] = $MainMountPointStatus"
echo "AppSrcMountPoint[$AppSrcMountPoint] = $AppSrcMountPointStatus"
echo "AppDataMountPoint[$AppDataMountPoint] = $AppDataMountPointstatus"
echo ""

echo "Mount Status :"
MountStatus
echo "AppSrc  = $AppSrcMountStatus"
echo "AppData = $AppDataMountStatus"
echo ""

echo "UnMount SDCard Partitions :"
UnmountSDCard
echo "AppSrc = $AppSrcUnMountStatus"
echo "AppData = $AppDataUnMountStatus"
echo ""

echo "SDCard FileSystem Check Status :"
CheckSDcard
echo "AppSrcCheckStatus[$AppSrcMountPoint]=$AppSrcCheckStatus"
echo "AppDataCheckStatus[$AppSrcMountPoint]=$AppDataCheckStatus"
echo ""

echo "ReMounting SDCard Partitions :"
ReMountSDCard
echo "AppSrc = $AppSrcReMountStatus"
echo "AppData = $AppDataReMountStatus"
echo ""

echo "Mount Status After FileSystem Check :"
MountStatus
echo "AppSrc  = $AppSrcMountStatus"
echo "AppData = $AppDataMountStatus"
echo ""
    
exit 0

