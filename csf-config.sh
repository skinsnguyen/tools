cp /etc/csf/csf.conf /etc/csf/csf.conf.bak
sed -i 's/^TESTING = .*/TESTING = "0"/g' /etc/csf/csf.conf
sed -i 's/^RESTRICT_SYSLOG = .*/RESTRICT_SYSLOG = "3"/g' /etc/csf/csf.conf
sed -i 's/^TESTING_INTERVAL = .*/TESTING_INTERVAL = "5"/g' /etc/csf/csf.conf
sed -i 's/^LF_CSF = .*/LF_CSF =  = "1"/g' /etc/csf/csf.conf
sed -i 's/^UDPFLOOD = .*/UDPFLOOD = "1"/g' /etc/csf/csf.conf
sed -i 's/^UDPFLOOD_LIMIT = .*/UDPFLOOD_LIMIT = "25/s"/g' /etc/csf/csf.conf
sed -i 's/^UDPFLOOD_BURST = .*/UDPFLOOD_BURST = "50"/g' /etc/csf/csf.conf
sed -i 's/^CT_LIMIT = .*/CT_LIMIT = "100"/g' /etc/csf/csf.conf
sed -i 's/^CONNLIMIT = .*/CONNLIMIT = "80;20,443;20"/g' /etc/csf/csf.conf
sed -i 's/^PORTFLOOD = .*/PORTFLOOD = "80;tcp;50;10;443;tcp;50;10"g' /etc/csf/csf.conf
sed -i 's/^SYNFLOOD = .*/SYNFLOOD = "1"/g' /etc/csf/csf.conf
sed -i 's/^SMTP_BLOCK = .*/SMTP_BLOCK = "0"/g' /etc/csf/csf.conf
sed -i 's/^LF_SSHD = .*/LF_SSHD = "10"/g' /etc/csf/csf.conf
sed -i 's/^CT_PORTS = .*/CT_PORTS = "80,53,22,21,443"g' /etc/csf/csf.conf
sed -i 's/^CT_STATES = .*/CT_STATES = "SYN_RECV"g' /etc/csf/csf.conf





#############################################################################################
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
sed -i '/gmail.com/d' /etc/csf/csf.dyndns
sed -i '/public.pyzor.org/d' /etc/csf/csf.dyndns
echo "tcp|out|d=25|d=smtp.gmail.com" >> /etc/csf/csf.dyndns
echo "tcp|out|d=465|d=smtp.gmail.com" >> /etc/csf/csf.dyndns
echo "tcp|out|d=587|d=smtp.gmail.com" >> /etc/csf/csf.dyndns
echo "tcp|out|d=995|d=imap.gmail.com" >> /etc/csf/csf.dyndns
echo "tcp|out|d=993|d=imap.gmail.com" >> /etc/csf/csf.dyndns
echo "tcp|out|d=143|d=imap.gmail.com" >> /etc/csf/csf.dyndns
echo "udp|out|d=24441|d=public.pyzor.org" >> /etc/csf/csf.dyndns
#############################################################################################



