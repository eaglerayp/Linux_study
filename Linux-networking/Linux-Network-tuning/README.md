#    Network tuning
---
### tuning kernel parameters
* control the kernel-based socket buffer set max to 256M+ for 10GE
  * net.core.rmem_max = 268435456
  * net.core.wmem_max = 268435456
  * net.core.wmem_default; net.core.rmem_default
* control the packets queue length in **net.core.netdev_max_backlog** >=8000
* control the listen backlog **net.core.somaxconn** >=1024 to prevent new connection dropped (max 65535)

### tuning TCP 
* **TCP total memory** 
  * net.ipv4.tcp_mem = 524288 786432 1048576 (unit=PAGESIZE=4096Bytes; 可將一半的RAM用在這; in 8G host: 2,3,4 >3GB enter the "memory pressure" warning. MAX 4GB)
* **tuning TCP wmem and rmem**'s default buffer size set max to 16MB for 1GE, and 32M+ for 10GE:
  * net.ipv4.tcp_rmem = 4096 87380 33554432
  * net.ipv4.tcp_wmem = 4096 65536 33554432 
* net.ipv4.tcp_max_orphans = 65536 (sockets that no connect with any process (appliaction closed,but TCP still not fin), over half would warning may cost RAM 2GB, can increase this if warning) 
* net.ipv4.tcp_max_tw_buckets = 65536 (Maximal number of timewait sockets, should larger)
* net.ipv4.tcp_low_latency = 0 (true for latency; high for throughput)

#### **Optimizing connections**
* prevent connection lost for TCP syn queue per port in **net.ipv4.tcp_max_syn_backlog** >=8192
* detect failing connections, decrease **net.ipv4.tcp_synack_retries** <=3 
* **net.ipv4.tcp_retries2** control the resend times with already connect user, default high because drop the connected user is hurt, but retry too many times for dead user cost high, keep retries2 >synack_retries (=5)
* **net.ipv4.tcp_fin_timeout** = 60
* **net.ipv4.tcp_keepalive_time** control the idle connection live time, decrease it when server busy (=900 sec) 
* **net.ipv4.tcp_keepalive_probes** control the number of packets to check dead , faster for small number (=3)
* **net.ipv4.tcp_keepalive_intvl** control the time interval between sending probes, shorter for busy server (=15)
* allow reusing a TIME-WAIT socket (just viewed dead) using **net.ipv4.tcp_tw_reuse**=1 and **net.ipv4.tcp_tw_recycle**=1
*  **net.ipv4.tcp_tso_win_divisor** control 1 TSO can simultaneously use how many congestion window. (2-16)

# Discussion

### Network Environment
* **tcp_congestion_control** : 現在通行的cubic (是為了 high bandwidth networks with high latency), or reno: [performance comparison](http://journal.info.unlp.edu.ar/journal/journal35/papers/JCST-Apr13-1.pdf)
* net.ipv4.tcp_fastopen = 1 (allow fast TCP connection, client利用cookie (IP and MAC加密),在reconnect 不用3 way handshake,省下1 RTT, 行動和無線應該假設容易lost connection所以要開啟)
* 網路容易變動(可能因為移動在不同的wireless切換 或wireless<==>3G/4G)  ([F-RTO](http://blog.csdn.net/zhangskd/article/details/7446441) 與MTU probing互斥) 
  * net.ipv4.tcp_frto = 2 (F-RTO is an enhanced recovery algorithm for TCP retransmission timeouts. used when network unstable 因為RTT改變所以需要判斷RTO是否真實)  可搭配 tcp_low_latency =1  (在Lossy Wireless Networks開啟可使retransmit更頻繁)
  * net.ipv4.tcp_mtu_probing = 0 (探索black hole router:1.因為mtu size不對而被drop卻沒通知 2.router斷了卻沒更新其他router的table) 
* net.ipv4.tcp_thin_dupack = 0 (在thin stream下使用, 一次傳輸的inflight packet<4, 一般用在遊戲/股市等應用環境,封包是為了迅速**更新狀態**的網路 :  reduce the dupACK threshold for fast retransmit)
* net.ipv4.tcp_thin_linear_timeouts = 0 (搭配thin_dupack  for **thin stream**)
* net.ipv4.tcp_early_retrans = 3 (在非thin stream環境下開啟, delayed ER and TLP, 如果開啟thin dupACK則無法進行early_retrans, code 會先進thin dupACK的if clause) 

### security
* The idea of a DoS attack is to bombard the targeted system with requests that fill up the server's storage.(利用error log塞滿file system) 
  * **net.core.message_burst** control how fast to write a new warning message. (lareger so message less, but risk up)
  * **net.core.message_cost** control the threshold cost value the warning message is ignored. (lareger so message less, but risk up)
* **net.ipv4.conf.all.rp_filter**
  * (enable source route verification:Strict Reverse Path確認封包是不是從合理的router路徑過來,不是就判定是假的封包, prevent IP spoofing for **DDoS**), but may cause problem in IGMP or complicated routing network
* **net.ipv4.neigh.default.proxy_delay** (delay up how many jiffies(開機以來有多少次interrupt) before replying ARP requests,  prevent **network flooding**)
* net.ipv4.tcp_challenge_ack_limit (為了避免假冒的RST(reset connection)攻擊 challenge_ack要確認是否是真實的情況, 限制每秒送出的challenge ACK)
* net.ipv4.tcp_syncookies = 1 (**prevent syn flood==DDoS** if syn queue full, 不特地分配資源等待連線而是計算一個(HASH) cookie給對方, 最後驗證ACK的cookie後才分配資源, 缺點是MSS被限制只有8種大小) 
* net.ipv4.conf.all.accept_redirects = 0 (Do not accept ICMP redirects for preventing **MITM** attacks =0)
* net.ipv4.conf.all.arp_ignore = 1  (security problem should ignore ARP broadquest)

### ICMP 
* net.ipv4.icmp_echo_ignore_all = 0 (Don't ignore directed pings, if must prohibit **ping** set as 1 prevent **ping flood attack**)
* net.ipv4.icmp_echo_ignore_broadcasts = 1 (only ignore broadcast ping)
* net.ipv4.icmp_ratelimit = 1000  (chosen type ICMP packets limited rate)
* 
* net.ipv4.icmp_ratemask = 6168  (limit rates of which type ICMP packets, default 6168 or 88089)
```
	Significant bits: IHGFEDCBA9876543210
	Default mask:     0000001100000011000
		0 Echo Reply *
		3 Destination Unreachable *
		4 Source Quench *
		5 Redirect
		8 Echo Request
		B Time Exceeded *
		C Parameter Problem *
		D Timestamp Request
		E Timestamp Reply *
		F Info Request
		G Info Reply *
		H Address Mask Request
		I Address Mask Reply
```
### IP 
* net.ipv4.ip_default_ttl = 64 (決定IP packet可在網路上走幾個hop,網路環境差可能要大一點  64<ttl<256)
* net.ipv4.ip_local_port_range = 32768	61000 (tcp/udp free port, maximum 1024 to 65535)
* net.ipv4.ip_local_reserved_ports = 42689, 6892-6899 (reserve listen ports)
* net.ipv4.ip_no_pmtu_disc = 0 (enalbe Path MTU Discovery in most case, if router in PATH fail and no ICMP, should decrease the MTU and disable PMTU by hand)
* **IP Fragmentation** and **Segmentation** 
* net.ipv4.ipfrag_high_thresh = 4194304 (Maximum memory used to reassemble IP fragments)
* net.ipv4.ipfrag_low_thresh = 3145728 (Minimum memory used to reassemble IP fragments)
* net.ipv4.ipfrag_max_dist = 64 (max disorder fragment queue:set 0 or bigger than 16384)
* net.ipv4.ipfrag_time = 30 (time in seconds to keep an IP fragment in memory, slow network enviroment should be longer, 避免packet queue太長還沒丟出去就被drop)
* net.ipv4.tcp_limit_output_bytes = 131072 (Controls TCP Small Queue limit per tcp socket. may affect GSO)

### ARP table gc time [(ARP table GC process)](http://stackoverflow.com/questions/15372011/configuring-arp-age-timeout)
* net.ipv4.neigh.default.base_reachable_time = 30
* net.ipv4.neigh.default.delay_first_probe_time = 5 (如果符合失效條件後多久才送出probe做最終判定 in sec)
* net.ipv4.neigh.default.gc_interval = 30 (how fast garbage collection for ARP entries) 
* net.ipv4.neigh.default.gc_stale_time = 60 (如果被判定為stale之後,在cache存活gc_stale_time秒數後應該gc, if referenced by routing table, 被gc的時間又會被route.gc_time影響)
* net.ipv4.conf.all.arp_accept = 0 (Don't create new entries in the ARP table when receive unknown gratuitous ARP) 


## Resource: Pro Ubuntu Server Administration
