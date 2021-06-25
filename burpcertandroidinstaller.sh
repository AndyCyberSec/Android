#!/bin/bash

#Renaming cacert.cer to cacert.der
echo '[+] Renaming cacert.cer to cacert.der...'
mv cacert.cer cacert.der

echo '[+] Converting cacert.der to PEM format...'
openssl x509 -inform DER -in cacert.der -out cacert.pem
hash=$(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1)

#echo $hash

mv cacert.pem $hash.0

echo '[+] Running adb as root'
adb root

echo '[+] Remounting device FileSystem'
adb remount

echo '[+] Pushing the certificate into the device tmp directory...'
adb push ./$hash.0 /data/local/tmp

echo '[+] Moving the certificate into the right folder...'
adb shell chmod 644 /data/local/tmp/$hash.0
adb shell mv /data/local/tmp/$hash.0 /system/etc/security/cacerts

adb shell reboot

echo '[+] Done! Rebooting the device..!'
