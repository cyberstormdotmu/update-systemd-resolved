script_type="up"

foreign_options=("dhcp-option DNS 1234:567:89:0:ab:cde:f123:4567")

TEST_TITLE="Single IPv6 DNS Server (Full, Simple)"
TEST_BUSCTL_CALLED=1
TEST_BUSCTL_DNS="1 10 16 18 52 5 103 0 137 0 0 0 171 12 222 241 35 69 103"
