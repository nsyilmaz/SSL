
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

# Text output of a CERT
openssl x509 -inform PEM -text -in CA.pem -out CA.txt




###################---BURP---####################
# Create CA Key and CERT 
# Create CA Certificate in DER format
openssl req -x509 -days 730 -nodes -newkey rsa:2048 -outform der -keyout CA.key -out CA.der -extensions v3_ca -config openssl.cnf

# Conver private key to DER format
openssl pkcs8 -topk8 -inform PEM -outform DER -in CA.key -out CA.key.der -nocrypt

# You can import above created KEY and CERT to Burp.
####################################################

# Pushing CA CERT to Android, exported from BURP
#
# Burp exports the cert in der format.

# First convert it to pem format
openssl x509 -inform der -in CA.der -out CA.pem

# Then get the subject hash 
openssl x509 -inform PEM -subject_hash_old -in CA.pem | head -1
# the output will be a 8-char alpha numeric series like this -> a58355c2

# We need to make a copy of the pem file named with this string.
cp CA.pem `openssl x509 -inform PEM -subject_hash_old -in CA.pem | head -1`.0


# Then we need to put this special named cert file to android device.
# Genymotion'da root icin bu komut gerekli olabilir.
adb shell setprop persist.sys.root_access 3
adb push a58355c2.0 /data/local/tmp
adb shell


su
mount -o rw,remount /system
mv /data/local/tmp/a58355c2.0 /system/etc/security/cacerts/
chown root:root /system/etc/security/cacerts/a58355c2.0
chmod 644 /system/etc/security/cacerts/a58355c2.0
reboot

#############################################################






