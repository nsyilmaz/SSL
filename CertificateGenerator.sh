#/*
# *
# * Copyright (C) 2005 by Nebi Senol YILMAZ
# * nsyilmaz@ikizler.net , nsyilmaz@gmail.com
# * http://www.ikizler.net/
# *
# *
# * This program is free software; you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation; either version 2 of the License, or
# * (at your option) any later version.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program; if not, write to the
# * Free Software Foundation, Inc.,
# * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# *
# */
#
#########################################################
#
# 	Firstly script generates a CA Key.
#	Then it starts to generating server Key.
#	Then Signs the server key with CA key.
#
#	You should run the script in
#	/path/for/apache/conf
#	directory
#
#


echo "Generating essential directories..."
mkdir -p CA
mkdir -p Server


# CA Key Generation
echo "Generating CA Certificate..."
openssl req -x509 -days 730 -nodes -newkey rsa:2048 -keyout CA/ca.key -out CA/ca.crt -extensions v3_ca -config openssl.cnf


echo "Certificate Verification:"
openssl verify CA/ca.crt
echo
echo "CA Certificate Generation is completed..."
read
# CA Key Generation




# Server Key Generation
echo "Generating Server Certificate..."
openssl genrsa -out Server/server.key 2048


openssl req -new -key Server/server.key -out Server/server.csr -config openssl.cnf
echo
echo "Certificate Sign Request Sent for Server..."
read

openssl x509  -days 730 -CAcreateserial -CA CA/ca.crt -CAkey CA/ca.key -in Server/server.csr -req -out Server/server.crt
echo
echo "Server Certificate is Signed by CA..."
read

echo "Certificate Verification:"
openssl verify -CAfile CA/ca.crt Server/server.crt
# Server Key Generation


echo "Key generation is DONE..."
