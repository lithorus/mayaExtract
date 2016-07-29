#!/bin/bash

#$1 : sourcePath
#$2 : mayaTemp
#$3 : mayaTargetPath

mkdir -p $2
mkdir -p $3/Licensing
cd $2

for filename in `ls -1 $1/*.rpm`
do
    rpm2cpio $filename|cpio -i -d
done

wget http://mirror.centos.org/centos/7.2.1511/os/x86_64/Packages/libcurl-7.29.0-25.el7.centos.x86_64.rpm
rpm2cpio libcurl-7.29.0-25.el7.centos.x86_64.rpm|cpio -i -d

wget http://mirror.centos.org/centos/7.2.1511/os/x86_64/Packages/openssl-libs-1.0.1e-42.el7.9.x86_64.rpm
rpm2cpio openssl-libs-1.0.1e-42.el7.9.x86_64.rpm|cpio -i -d

wget http://mirror.centos.org/centos/7.2.1511/os/x86_64/Packages/compat-libtiff3-3.9.4-11.el7.x86_64.rpm
rpm2cpio compat-libtiff3-3.9.4-11.el7.x86_64.rpm|cpio -i -d

cp -rl $2/usr/autodesk/maya*/* $3/

cp -rl $2/opt/Autodesk/Adlm $3/Licensing/

cp -rl $2/var/opt/Autodesk/Adlm $3/Licensing/

cp -rl $2/usr/lib64/lib* $3/lib/

cat > $3/Licensing/AdlmThinClientCustomEnv.xml <<_EOF
<?xml version='1.0' encoding='utf-8'?>
<ADLMCUSTOMENV VERSION='1.0.0.0'>
    <PLATFORM OS='Linux'>
        <KEY ID='ADLM_COMMON_BIN_LOCATION'>
            <!--Path to the AdLM shared executables-->
            <STRING>$3/Licensing/Adlm/R12/bin</STRING>
        </KEY>
        <KEY ID='ADLM_COMMON_LIB_LOCATION'>
            <!--Path to the AdLM shared libraries-->
            <STRING>$3/Licensing/Adlm/R12/lib64</STRING>
        </KEY>
        <KEY ID='ADLM_COMMON_LOCALIZED_DATA_LOCATION'>
            <!--Path to the AdLM shared localized resource files (do not include the language folder)-->
            <STRING>$3/Licensing/Adlm/R12</STRING>
        </KEY>
        <KEY ID='ADLM_ERROR_TABLE_LOCATION'>
            <!--Path to AdlmErrorCodes.xml-->
            <STRING>$3/Licensing/Adlm/R12</STRING>
        </KEY>
        <KEY ID='ADLM_PIT_FILE_LOCATION'>
            <!--Path to the ProductInformation.pit file-->
            <STRING>$3/Licensing/Adlm/.config</STRING>
        </KEY>
        <KEY ID='ADLM_CASCADE_FILE_LOCATION'>
            <!--Path where the CascadeInfo.cas file will be created (this should always be on the client machine)-->
            <STRING>$3/Licensing/Adlm/.config</STRING>
        </KEY>
        <KEY ID='ADLM_LICENSE_FILE_LOCATION'>
            <!--Path to a directory containing one or more .lic files (API override)-->
            <STRING>$3/Licensing</STRING>
        </KEY>
        <KEY ID='ADLM_APPLICATION_ADLM_RESOURCE_LOCATION'>
            <!--Path to the AdlmIntRes.xml file (API override)-->
            <STRING></STRING>
        </KEY>
        <KEY ID='ADLM_APPLICATION_ERROR_LOG_FILE'>
            <!--Path and filename of the application AdLM log file (API override)-->
            <STRING></STRING>
        </KEY>
    </PLATFORM>
</ADLMCUSTOMENV>
_EOF
