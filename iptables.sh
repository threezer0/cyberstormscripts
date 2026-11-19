#starting
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

<insert host-specific rules here>

#deny all input
iptables -A INPUT -p tcp -j DROP
iptables -A INPUT -p udp -j DROP

# dc01: domain-joined hosts / LDAP-using apps only
iptables -A OUTPUT -d 172.20.4.30 -p tcp -m multiport --dports 88,389,445,464,636,3268 -j ACCEPT
iptables -A OUTPUT -d 172.20.4.30 -p udp -m multiport --dports 88,389,464 -j ACCEPT

#output
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --dports 53,123 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 53,8089,9997 -j ACCEPT # splunk stuff
iptables -A OUTPUT -p tcp --dport 1433 -j ACCEPT        # web01 only, if the app uses db01
iptables -A OUTPUT -p tcp -j DROP
iptables -A OUTPUT -p udp -j DROP
netfilter-persistent save
