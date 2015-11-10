#    ipv4 system variables
---
###   CIPSOv4 (安全等級標籤,決定溝通雙方要求資料的權限)
* net.ipv4.cipso_cache_bucket_size = 10
* net.ipv4.cipso_cache_enable = 1 
* net.ipv4.cipso_rbm_optfmt = 0
* net.ipv4.cipso_rbm_strictvalid = 1

##   **Configure .all for now using interface settings**
* net.ipv4.conf.all.accept_local = 0  (allow local packet, if two NIC wants to send packet.)
* net.ipv4.conf.all.accept_redirects = 0 (Do not accept ICMP redirects for prevent **MITM** attacks =0)
* net.ipv4.conf.all.accept_source_route = 0 (true for allow Strict Source Route允許別人指定packet走的路徑-容易被導入有問題的router導致 ip spoofing, should turn off)

## ARP firewall settings  [reference](https://support.cumulusnetworks.com/hc/en-us/articles/203859616-Default-ARP-Settings-in-Cumulus-Linux)
* net.ipv4.conf.all.arp_accept = 0 (Don't create new entries in the ARP table when receive unknown gratuitous ARP) 
* net.ipv4.conf.all.arp_announce = 2 (2 = allow ARP packets lie source IP when multi network interface)
* net.ipv4.conf.all.arp_filter = 0  (when multi network interfaces are on different IP networks =1,在多網卡情況 調整filter或ignore可以避免多網卡同時發出ARP reply造成類似multithread的value write conflict)
* net.ipv4.conf.all.arp_ignore = 1  (security problem should ignore ARP broadquest)
* net.ipv4.conf.all.arp_notify = 1 (send gratitous ARP when device change)

## Routing settings
* net.ipv4.conf.all.proxy_arp = 0 (server dont have to be a router)
* net.ipv4.conf.all.proxy_arp_pvlan = 0 (proxy_arp for private VLAN, check server structure)
* net.ipv4.conf.all.forwarding = 0 (disallow IP forwarding, server dont have to be a router)
* net.ipv4.conf.all.mc_forwarding = 0 
* net.ipv4.conf.all.secure_redirects = 1 (Accept ICMP redirect messages only for default gateways,)
* net.ipv4.conf.all.send_redirects = 0 (Do not send ICMP redirects, we are not a router)
* net.ipv4.conf.all.route_localnet = 0 
* net.ipv4.ip_forward = 0 (not router)
* net.ipv4.ping_group_range = 1	0 (Specify the group range allowed to create non-raw icmp sockets. default no body can ping ICMP socket)
* net.ipv4.route.error_burst = 1250 ( we can send maximum buset/cost ICMP Destination unreachables message /sec)
* net.ipv4.route.error_cost = 250
* net.ipv4.route.gc_elasticity = 8
* net.ipv4.route.gc_interval = 60 
* net.ipv4.route.gc_min_interval_ms = 500 
* net.ipv4.route.gc_thresh = -1
* net.ipv4.route.gc_timeout = 150
* net.ipv4.route.max_size = 2147483647 (increase when use many interface and routers)
* net.ipv4.route.min_adv_mss = 256  (The advertised MSS dynamic depends on the first hop route MTU, but will never be lower than this )
* net.ipv4.route.min_pmtu = 552 (minimum discovered Path MTU)
* net.ipv4.route.mtu_expires = 600 (cached PMTU information lived)
* net.ipv4.route.redirect_load = 5
* net.ipv4.route.redirect_number = 9
* net.ipv4.route.redirect_silence = 5120

## Protocol
* net.ipv4.conf.all.bootp_relay = 0 (for BOOTP protocol)
* net.ipv4.conf.all.disable_policy = 0 (disable IPsec policy)
* net.ipv4.conf.all.disable_xfrm = 0 (disable IPSEC encryption)
* net.ipv4.conf.all.force_igmp_version = 0 (auto, or force use what IGMP version)
* net.ipv4.conf.all.log_martians = 1  (Log Spoofed Packets, Source Routed Packets, Redirect Packets)
* net.ipv4.conf.all.medium_id = 0 (used for check device id)
* net.ipv4.conf.all.promote_secondaries = 0 (make secondary IP addresses promote when primary IP addresses are removed)
* net.ipv4.conf.all.rp_filter = 0 (enable source route verification (Strict Reverse Path), prevent IP spoofing for **DDoS**)
* net.ipv4.conf.all.shared_media = 1 (Indicates that the media is shared with different subnets, if secure_redirect =1, should = 1)
* net.ipv4.conf.all.src_valid_mark = 1  (tell kernel to use packet mark, may cover rp_filter)
* net.ipv4.conf.all.tag = 0 

##   **Configure default for future add-on machine settings, or specific NIC**  

## ICMP
* net.ipv4.icmp_echo_ignore_all = 0 (Don't ignore directed pings, if must prohibit **ping** set as 1 prevent **ping flood attack**)
* net.ipv4.icmp_echo_ignore_broadcasts = 1 (only ignore broadcast ping)
* net.ipv4.icmp_errors_use_inbound_ifaddr = 0 (choose primary IP address to send ICMP packets)
* net.ipv4.icmp_ignore_bogus_error_responses = 1 (ignore the bogus error responses to save storage)
* net.ipv4.icmp_ratelimit = 1000  (chosen type ICMP packets limited rate per jiffie)
* net.ipv4.icmp_ratemask = 6168  (limit rates of which type ICMP packets, 6168=bitwised 0000001100000011000)

## IGMP settings
* net.ipv4.igmp_max_memberships = 20 (max number of total IGMP member across multi ICMP group)
* net.ipv4.igmp_max_msf = 10  (max number of source filters, if connect more socket like IP_ADD_SOURCE_MEMBERSHIP, add this variable)

## inet peer (can remember peer's IP without router)
* net.ipv4.inet_peer_maxttl = 600 (peer max time to live)
* net.ipv4.inet_peer_minttl = 120 (peer min time to live)
* net.ipv4.inet_peer_threshold = 65664 (control INET peer datastructure AVL tree size, bigger size shorter ttl and gc time interval)

## IP 
* net.ipv4.ip_default_ttl = 64 (in slow network may set larger)
* net.ipv4.ip_dynaddr = 0 (support Dynamic address, but we don't need this)
* net.ipv4.ip_early_demux = 1 (routing workload, should turn off)
* net.ipv4.ip_local_port_range = 32768	61000 (tcp/udp free port, maximum 1024 to 65535)
* net.ipv4.ip_local_reserved_ports = 42689, 6892-6899 (reserve listen ports)
* net.ipv4.ip_no_pmtu_disc = 0 (enalbe Path MTU Discovery in most case, if router in PATH fail and no ICMP, should decrease the MTU and disable PMTU by hand)
* net.ipv4.ip_nonlocal_bind = 0 (enable local process bind nonlocal IP, may be useful in dynamic network environment)

## **IP Fragmentation**
* net.ipv4.ipfrag_high_thresh = 4194304 (Maximum memory used to reassemble IP fragments)
* net.ipv4.ipfrag_low_thresh = 3145728 (Minimum memory used to reassemble IP fragments)
* net.ipv4.ipfrag_max_dist = 64 (max disorder fragment queue:set 0 or bigger than 16384)
* net.ipv4.ipfrag_secret_interval = 600 (Regeneration interval of the hash secret (or lifetime) for IP fragments)
* net.ipv4.ipfrag_time = 30 (time in seconds to keep an IP fragment in memory, slow network enviroment should be longer, load balaning server should be smaller because the IP packet would not be big)

## **ARP table settings** important for gateway or proxy
* net.ipv4.neigh.default.anycast_delay = 100 (maximum number of jiffies to delay before replying)
* net.ipv4.neigh.default.app_solicit = 0 (probes to send to the user space ARP daemon)

# [ARP table GC process](http://stackoverflow.com/questions/15372011/configuring-arp-age-timeout)
* net.ipv4.neigh.default.base_reachable_time = 30
* net.ipv4.neigh.default.base_reachable_time_ms = 30000
* net.ipv4.neigh.default.delay_first_probe_time = 5 (如果符合失效條件後多久才送出probe in sec)
* net.ipv4.neigh.default.gc_interval = 30 (how fast garbage collection for ARP entries) 
* net.ipv4.neigh.default.gc_stale_time = 60 (如果被判定為stale之後,在cache存活gc_stale_time秒數後應該gc, if referenced by routing table, 被gc的時間又會被route.gc_time影響)
* net.ipv4.neigh.default.gc_thresh1 = 1024 (entries less than this gc will not start)
* net.ipv4.neigh.default.gc_thresh2 = 2048 (entries more than this gc will start after 5sec)
* net.ipv4.neigh.default.gc_thresh3 = 4096 (entries more than this, gc always run, also max size of ARP table )
* net.ipv4.neigh.default.locktime = 100 (ttl, minimum jiffies to keep an ARP entry in the cache. prevent ARP cache thrashing when error.不立即的刪除)
* net.ipv4.neigh.default.mcast_solicit = 3 (check alived multicast/broadcast times)
* net.ipv4.neigh.default.proxy_delay = 80 (delay up how many jiffies before replying ARP request,  prevent **network flooding**)
* net.ipv4.neigh.default.proxy_qlen = 64 (maximum number of packets which may be queued to proxy-ARP addresses.)
* net.ipv4.neigh.default.retrans_time_ms = 1000 (delay before retransmitting a reuest)
* net.ipv4.neigh.default.ucast_solicit = 3 
* net.ipv4.neigh.default.unres_qlen_bytes = 65536 (maximum size of packets queue for each	unresolved address) (In order to reduce a performance spike with relation to timestamps generation, bigger it)

## TCP
* net.ipv4.tcp_abort_on_overflow = 0 (If listening service is too slow to accept new connections, reset them.)
* net.ipv4.tcp_adv_win_scale = 2 (1/2^scale split memory for application memory, should>=2)
* net.ipv4.tcp_allowed_congestion_control = cubic reno  (cubic is latest TCP congestion control algo version, used in high bandwidth networks with high latency ,reno allow Fast Retransmit and Fast Recovery )
* net.ipv4.tcp_app_win = 31 (1/2^32 TCP socket memory buffer for application buffer)
* net.ipv4.tcp_available_congestion_control = cubic reno
* net.ipv4.tcp_base_mss = 512 (If MTU probing is enabled, this is the initial MSS used)
* net.ipv4.tcp_challenge_ack_limit = 100 (Improving TCP's Robustness to Blind In-Window Attacks)
* net.ipv4.tcp_congestion_control = cubic
* net.ipv4.tcp_early_retrans = 3 (delayed ER and TLP)
* net.ipv4.tcp_ecn = 2 (ECN allow the routers in PATH actively notify the TCP reciever the congestion to avoid packet losses)
* net.ipv4.tcp_sack = 1 (allow selective ACK)
* net.ipv4.tcp_dsack = 1 (Allows TCP to send "duplicate" Selective ACK, cascade with tcp_sack)
* net.ipv4.tcp_fack = 1 (allow forward ACK, cascade with tcp_sack, sack add-ons help congestion control)
* net.ipv4.tcp_fastopen = 1 (allow fast TCP connection, client利用cookie(IP and MAC加密),在reconnect 不用3 way handshake,省下1 RTT)
* net.ipv4.tcp_fastopen_key = a0d3dffc-6a819259-efb132a7-fad7fb21 (using by fastopen)
* net.ipv4.tcp_fin_timeout = 60 
* net.ipv4.tcp_frto = 2 (F-RTO is an enhanced recovery algorithm for TCP retransmission	timeouts. used when network unstable, RTT change scenario, conflict with MTU probe, 主要應用情境是行動用戶在不同的wi-fi/3G/4G環境移動,轉換AP導致RTO,但其實他們有收到資料,F-RTO主要避免這類型的重傳) [reference](http://blog.csdn.net/zhangskd/article/details/7446441)
* check TCP connection alive
  * net.ipv4.tcp_keepalive_intvl = 15 (see tuning)
  * net.ipv4.tcp_keepalive_probes = 3
  * net.ipv4.tcp_keepalive_time = 900
* net.ipv4.tcp_limit_output_bytes = 131072 (Controls TCP Small Queue limit per tcp socket. 預設128Kb in flight per socket)
* net.ipv4.tcp_low_latency = 0 (true for latency; high for throughput 以OS效率為優先, interrupt time 縮短, ack delay, socket delay)
* net.ipv4.tcp_max_ssthresh = 0 (set slow start's max ending condition)
* net.ipv4.tcp_max_syn_backlog = 8192 (control the packets queue length, cost 64 bytes per entry, maxlen 65535)
* net.ipv4.tcp_max_tw_buckets = 65536 (Maximal number of timewait sockets, should larger)
* net.ipv4.tcp_mem = 2147483648 3221225472 4294967296 (unit PAGESIZE=4096Bytes  use half > RAM e.g.,MIN:2GB, >3GB enter the "memory pressure" mode. MAX 4GB)
* net.ipv4.tcp_min_tso_segs = 2 (Minimal number of segments per TSO frame)
* net.ipv4.tcp_moderate_rcvbuf = 1 (enable buffer auto-tuning)
* net.ipv4.tcp_mtu_probing = 0 (Enable TCP MTU Probing in order to deal with black hole routers)
* net.ipv4.tcp_no_metrics_save = 0 (true for don't do connection cache)
* net.ipv4.tcp_max_orphans = 65536 (sockets that no connect with any process (appliaction closed,but TCP still not fin), over half would warning may cost RAM 2GB, can increase this if warning)
* net.ipv4.tcp_orphan_retries = 1 
* net.ipv4.tcp_reordering = 3 (max reordering packets)
* net.ipv4.tcp_retrans_collapse = 1 (default on for solving TCP bug)
* net.ipv4.tcp_retries1 = 3
* net.ipv4.tcp_retries2 = 5
* net.ipv4.tcp_rfc1337 = 0 (if must follow RFC1337)
* **net.ipv4.tcp_rmem** = 4096	87380	6291456 (Byte)
* net.ipv4.tcp_slow_start_after_idle = 1 (slow start after time out)
* net.ipv4.tcp_stdurg = 0 (old format on TCP urgent pointer field)
* net.ipv4.tcp_syn_retries = 3
* net.ipv4.tcp_synack_retries = 3
* net.ipv4.tcp_syncookies = 1 (**prevent syn flood==DDoS** if syn queue full, 不特地分配資源等待連線而是計算一個加密一個 cookie給對方, 最後驗證ACK的cookie是否合法) 
* net.ipv4.tcp_thin_dupack = 0 (if true, reduce the dupACK threshold for fast retransmit)
* net.ipv4.tcp_thin_linear_timeouts = 0 (for thin stream)
* net.ipv4.tcp_timestamps = 1
* net.ipv4.tcp_tso_win_divisor = 8 (controls how much of the tcp congestion window is consumed by a single TSO frame)
* net.ipv4.tcp_tw_recycle = 1 (CASCADE with tcp_timestamps, decrease the dead SOCKET WAIT TIME)
* net.ipv4.tcp_tw_reuse = 1 
* net.ipv4.tcp_window_scaling = 1 (allow tcp window size >65535)
* net.ipv4.tcp_rmem = 4096 87380 33554432 (set max to 16MB for 1GE, and 32M+ for 10GE)
* net.ipv4.tcp_wmem = 4096 65536 33554432 (set max to 16MB for 1GE, and 32M+ for 10GE)
* net.ipv4.tcp_workaround_signed_windows = 0
* net.ipv4.udp_mem = 94416	125890	188832
* net.ipv4.udp_rmem_min = 4096
* net.ipv4.udp_wmem_min = 4096
* net.ipv4.xfrm4_gc_thresh = 1024

#    ipv6 system variables
---

* net.ipv6.bindv6only = 0
* net.ipv6.conf.all.accept_dad = 1
* net.ipv6.conf.all.accept_ra = 1 (接收router的router advertisement(
* net.ipv6.conf.all.accept_ra_defrtr = 1
* net.ipv6.conf.all.accept_ra_pinfo = 1
* net.ipv6.conf.all.accept_ra_rt_info_max_plen = 0
* net.ipv6.conf.all.accept_ra_rtr_pref = 1
* net.ipv6.conf.all.accept_redirects = 0 (ICMP redirect
* net.ipv6.conf.all.accept_source_route = 0

* net.ipv6.conf.all.autoconf = 1
* net.ipv6.conf.all.dad_transmits = 1
* net.ipv6.conf.all.disable_ipv6 = 0
* net.ipv6.conf.all.force_mld_version = 0
* net.ipv6.conf.all.force_tllao = 0
* net.ipv6.conf.all.forwarding = 0 (disallow IP forwarding, server dont have to be a router)
* net.ipv6.conf.all.hop_limit = 64
* net.ipv6.conf.all.max_addresses = 16
* net.ipv6.conf.all.max_desync_factor = 600
* net.ipv6.conf.all.mc_forwarding = 0
* net.ipv6.conf.all.mtu = 1280
* net.ipv6.conf.all.ndisc_notify = 0
* net.ipv6.conf.all.proxy_ndp = 0
* net.ipv6.conf.all.regen_max_retry = 3
* net.ipv6.conf.all.router_probe_interval = 60
* net.ipv6.conf.all.router_solicitation_delay = 1
* net.ipv6.conf.all.router_solicitation_interval = 4
* net.ipv6.conf.all.router_solicitations = 3
* net.ipv6.conf.all.temp_prefered_lft = 86400
* net.ipv6.conf.all.temp_valid_lft = 604800
* net.ipv6.conf.all.use_tempaddr = 2
* net.ipv6.icmp.ratelimit = 1000
* net.ipv6.ip6frag_high_thresh = 4194304
* net.ipv6.ip6frag_low_thresh = 3145728
* net.ipv6.ip6frag_secret_interval = 600
* net.ipv6.ip6frag_time = 60
* net.ipv6.mld_max_msf = 64
* net.ipv6.neigh.default.anycast_delay = 100
* net.ipv6.neigh.default.app_solicit = 0
* net.ipv6.neigh.default.base_reachable_time = 30
* net.ipv6.neigh.default.base_reachable_time_ms = 30000
* net.ipv6.neigh.default.delay_first_probe_time = 5
* net.ipv6.neigh.default.gc_interval = 30
* net.ipv6.neigh.default.gc_stale_time = 60
* net.ipv6.neigh.default.gc_thresh1 = 128
* net.ipv6.neigh.default.gc_thresh2 = 512
* net.ipv6.neigh.default.gc_thresh3 = 1024
* net.ipv6.neigh.default.locktime = 0
* net.ipv6.neigh.default.mcast_solicit = 3
* net.ipv6.neigh.default.proxy_delay = 80
* net.ipv6.neigh.default.proxy_qlen = 64
* net.ipv6.neigh.default.retrans_time = 250
* net.ipv6.neigh.default.retrans_time_ms = 1000
* net.ipv6.neigh.default.ucast_solicit = 3
* net.ipv6.neigh.default.unres_qlen = 31
* net.ipv6.neigh.default.unres_qlen_bytes = 65536
* net.ipv6.route.gc_elasticity = 9
* net.ipv6.route.gc_interval = 30
* net.ipv6.route.gc_min_interval = 0
* net.ipv6.route.gc_min_interval_ms = 500
* net.ipv6.route.gc_thresh = 1024
* net.ipv6.route.gc_timeout = 60
* net.ipv6.route.max_size = 4096
* net.ipv6.route.min_adv_mss = 1220
* net.ipv6.route.mtu_expires = 600
* net.ipv6.xfrm6_gc_thresh = 1024
