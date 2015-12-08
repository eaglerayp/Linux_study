# Traffic Control

## qdisc - classless
* PFIFO-FAST: (default), 三條queue組成的priority fifo queue, 由ToS分類.
* RED: 當queue長度超過一定值後, 會隨機標記packet (開啟ECN的後會在packet附加此選項告知對方網路狀況)丟包,
機率隨queue len線性成長.
* SFQ: max buckets:65536 len:127 after Linux-3.3. 流量到達網卡上限才會作用,
為1.Source address 2.Destination address 3.Source port做HASH分到buckets queue, 
因為HASH還是會有conflict,所以每過了perturb時間後就會更新parameter產生新的HASH算法,所以可以減少隨機性的某個bucket過重.
在man裡看到似乎還可以套用RED module.
* TBF: token bucket 的演算法, 只有一桶, 累積的token可以在burst的時候消耗.

## qdisc - classful 不適用
* HTB: 與filter一同使用, HTB的queue一樣是用tbf演算法,但是可以分類限速,與parent共享頻寬.
* CBQ: 與filter一同使用, CBQ的queue是讓queue idle進行限速, 如果只讓1/10的流量通過就讓queue閒置9/10的時間.
* PRIO: 與filter一同使用,　自訂的priority queue, 只會做scheduling而不會做限速或delay.