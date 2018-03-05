cd /opt/cq/
java -XX:MaxPermSize=512m -Xmx4096M -jar cq-author-4502.jar -unpack -p 4502 -r author
mkdir /opt/cq/crx-quickstart/install/
cp quickstart quickstart.original2
cat quickstart.original2  | sed "s|1024|4096|g" > quickstart
/opt/cq/crx-quickstart/bin/quickstart &
tail -f /opt/cq/crx-quickstart/log/* &
echo "Waiting for crx to start"
until $(curl --output /dev/null --silent --head --fail -uadmin:admin http://localhost:4502); do     printf '.';     sleep 5; done
echo "started"
mkdir /tmp/install
echo "Getting SP1"
wget --quiet --no-cookies http://rshare:$password@rshare.rwcms.com/Install_assets/zg-adobefixes/adobe/AEM-6.3-Service-Pack-1-6.3.1.zip -O /tmp/install/AEM-6.3-Service-Pack-1-6.3.1.zip
echo "SP1 Downloaded ,  Installing ...."
mv /tmp/install/AEM-6.3-Service-Pack-1-6.3.1.zip /opt/cq/crx-quickstart/install/
until (curl -s -uadmin:admin http://localhost:4502/system/console/productinfo  | grep 6.3.1.0); do     printf '.';     sleep 5; done 
echo "installed"
echo "Getting Cumulative Fix Pack6.3"
wget --quiet --no-cookies http://rshare:$password@rshare.rwcms.com/Install_assets/zg-adobefixes/adobe/AEM-CFP-6.3.1.2-2.0.zip -O /tmp/install/AEM-CFP-6.3.1.2-2.0.zip 
mv /tmp/install/AEM-CFP-6.3.1.2-2.0.zip /opt/cq/crx-quickstart/install/
echo "Getting Cumulative Fix Pack6.3 Downloaded ,  Installing ...."
until (curl -s -uadmin:admin http://localhost:4502/system/console/productinfo  | grep 6.3.1.2); do     printf '.';     sleep 5; done 
rm /opt/cq/crx-quickstart/install/AEM-CFP-6.3.1.2-2.0.zip

