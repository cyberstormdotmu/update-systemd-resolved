script_type="up"
foreign_option_1="dhcp-option DOMAIN example.com"
foreign_option_2="dhcp-option DOMAIN-SEARCH example.org"
foreign_option_3="dhcp-option DOMAIN-SEARCH example.net"

TEST_TITLE="DNS Single Domain and Dual Search"
TEST_BUSCTL_CALLED=1
TEST_BUSCTL_DOMAINS="3 example.com false example.org false example.net false"
