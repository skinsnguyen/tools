sed -i '/^#SPAMDROP/s/^#//' /etc/csf/csf.blocklists
sed -i '/^#SPAMEDROP/s/^#//' /etc/csf/csf.blocklists
sed -i '/^#DSHIELD/s/^#//' /etc/csf/csf.blocklists
sed -i '/^#HONEYPOT/s/^#//' /etc/csf/csf.blocklists
#sed -i '/^#MAXMIND/s/^#//' /etc/csf/csf.blocklists FALSOS POSITIVOS
sed -i '/^#BDE|/s/^#//' /etc/csf/csf.blocklists

sed -i '/^SPAMDROP/s/|0|/|300|/' /etc/csf/csf.blocklists
sed -i '/^SPAMEDROP/s/|0|/|300|/' /etc/csf/csf.blocklists
sed -i '/^DSHIELD/s/|0|/|300|/' /etc/csf/csf.blocklists
sed -i '/^HONEYPOT/s/|0|/|300|/' /etc/csf/csf.blocklists
#sed -i '/^MAXMIND/s/|0|/|300|/' /etc/csf/csf.blocklists # FALSOS POSITIVOS
sed -i '/^BDE|/s/|0|/|300|/' /etc/csf/csf.blocklists

sed -i '/^TOR/s/^TOR/#TOR/' /etc/csf/csf.blocklists
sed -i '/^ALTTOR/s/^ALTTOR/#ALTTOR/' /etc/csf/csf.blocklists
sed -i '/^CIARMY/s/^CIARMY/#CIARMY/' /etc/csf/csf.blocklists
sed -i '/^BFB/s/^BFB/#BFB/' /etc/csf/csf.blocklists
sed -i '/^OPENBL/s/^OPENBL/#OPENBL/' /etc/csf/csf.blocklists
sed -i '/^BDEALL/s/^BDEALL/#BDEALL/' /etc/csf/csf.blocklists

#############################################################################################
cat > /etc/csf/csf.rignore << EOF
.cpanel.net
.googlebot.com
.crawl.yahoo.net
.search.msn.com
EOF
#############################################################################################

