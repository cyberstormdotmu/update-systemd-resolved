script_type="up"
foreign_option_1="dhcp-option DOMAIN example.com"
foreign_option_2="dhcp-option DOMAIN-SEARCH example.org"

TEST_TITLE="DNS Single Domain and Single Search"
TEST_BUSCTL_CALLED=1
TEST_BUSCTL_DOMAINS="2 example.com false example.org false"
