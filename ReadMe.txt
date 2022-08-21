
# Create self signed CERT without CA extension  (PEM and DER format)
openssl req -x509 -days 730 -nodes -newkey rsa:2048 -keyout mycert.key -out mycert.crt
openssl req -x509 -days 730 -nodes -newkey rsa:2048 -outform der -keyout server.key -out cert.der



# Create CA key and CA cert | Max Days 825 for MacOS Chrome
openssl req -x509 -days 730 -nodes -newkey rsa:2048 -keyout CA.key -out CA.crt -extensions v3_ca -config openssl.cnf
openssl req -x509 -days 825 -nodes -newkey rsa:2048 -outform der -keyout CA.key -out CA.der -extensions v3_ca -config openssl.cnf



# Convert PEM key to DER key
openssl rsa -in server.key -inform pem -out server.key.der -outform der
# For BURP Suite
openssl pkcs8 -topk8 -inform PEM -outform DER -in CA.key -out CA.key.der -nocrypt



# Convert PEM cert to DER cert
openssl x509 -outform der -in mycert.crt -out mycert.der


#######################################
# Importing the CERT exported from BURP
#
openssl x509 -inform der -in ca.der -out ca.pem
openssl x509 -inform PEM -subject_hash_old -in ca.pem | head -1


cp ca.pem a58355c2.0
openssl x509 -inform PEM -text -in ca.pem -out /dev/null>> a58355c2.0



adb push a58355c2.0 /data/local/tmp
adb shell


su
mount -o rw,remount /system
mv /data/local/tmp/a58355c2.0 /system/etc/security/cacerts/
chown root:root /system/etc/security/cacerts/a58355c2.0
chmod 644 /system/etc/security/cacerts/a58355c2.0
reboot

#############################################################






