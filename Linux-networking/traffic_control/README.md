# Traffic Control

## awareness
* make sure the interface has its own queue: vlan,lo(loopback) don't have txqueuelen. Solve:`ifconfig eth txqueuelen 20`

## qdisc - classless
* PFIFO-FAST: (default), 三條queue組成的priority fifo queue, 由ToS分類,只會smooth和schedule packets.
* SFQ: max buckets:65536 len:127 after Linux-3.3. 流量到達網卡上限才會作用,
為1.Source address 2.Destination address 3.Source port做HASH分到buckets queue, 
因為HASH還是會有conflict,所以每過了perturb時間後就會更新parameter產生新的HASH算法,所以可以減少隨機性的bucket過重.
只會smooth和schedule packets.  
`sudo tc qdisc add dev eth1 root sfq perturb 10 divisor 65536`  
divisor只能是2的次方數, depth最多只有127; 集中流量的情況(apache benchmark)容易drop pkts. 
  * depth最多128,所以在頻寬使用滿時,瞬間某連線過大流量會drop.
* TBF: token bucket 的演算法, 只有一桶, 累積的token可以在burst的時候消耗, 只會限速！  
`tc qdisc add dev eth1 root tbf rate 1000mbit burst 20mb latency 100ms`
  * 計算burst的方式： 首先找出系統頻率 
`egrep '^CONFIG_HZ_[0-9]+' /boot/config-$(uname -r)`  
burst 至少> rate(bits)/ Hz =bits 再轉成bytes, e.g., 10mbps  250Hz system: burst =10m/250=40kbits 因為burst=bucket size,
而系統每一個hz會丟一個token到bucket,若是burst<token size,那bucket永遠沒有token,  
但是新的Intel processor和Linux已經是tickless的系統了,所以上述概念只是幫助理解,總之就是burst要夠大!
而latency/limit則是在bucket耗盡後,要降速多久/降到多低的rate來補充token. 
  * TBF的缺點：大封包可能會因為token數量不足被卡住, 但目前在連線數不高的情況TBF效率較好.
* RED: 一般只用在router. 當queue長度超過一定值後, 會隨機標記packet (開啟ECN的後會在packet附加此選項告知對方網路狀況)**丟包**,機率隨queue len線性成長.

## qdisc - classful 不適用
* HTB: 與filter一同使用, HTB的queue一樣是用tbf演算法,但是可以分類限速,與parent共享頻寬.
* CBQ: 與filter一同使用, CBQ的queue是讓queue idle進行限速, 如果只讓1/10的流量通過就讓queue閒置9/10的時間.
* PRIO: 與filter一同使用,　自訂的priority queue, 只會smooth和schedule packets而不會做限速或delay.
