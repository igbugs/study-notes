### ceph上传下载

```
[root@centos158 storgetest]# mc cp 10g.dat ceph/edoc3
/root/storgetest/10g.dat:          10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 54.30 MiB/s 3m8s
```

```
[root@centos158 storgetest]# mc cp ceph/edoc3/10g.dat /tmp
...168.251.54:8080/edoc3/10g.dat:  10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 96.80 MiB/s 1m45s
```

### ceph混合压测

#### 10MB

```
10MB: 2500obj
./warp mixed --host=192.168.251.53:8080,192.168.251.54:8080,192.168.251.55:8080 --objects=2500 --obj.size=10Mib --access-key W6XCJFJX2ETBB387IK4D --secret-key yh8wpPjiQ7wNfbGhKYkFHSNa7OBPHaIWjEQgOPlD --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-18[162202]-ExZe.csv.zst"             
Mixed operations.
Operation: DELETE - total: 590, 9.9%, Concurrency: 20, Ran 4m53s, starting 2022-08-18 16:22:08.592 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 0.65 obj/s.
 * http://192.168.251.54:8080: Avg: 0.70 obj/s.
 * http://192.168.251.55:8080: Avg: 0.69 obj/s.

Requests considered: 591:
 * Avg: 375ms, 50%: 260ms, 90%: 885ms, 99%: 1.441s, Fastest: 38ms, Slowest: 1.704s

Requests by host:
 * http://192.168.251.53:8080 - 188 requests: 
	- Avg: 332ms Fastest: 38ms Slowest: 1.334s 50%: 190ms 90%: 797ms
 * http://192.168.251.54:8080 - 205 requests: 
	- Avg: 406ms Fastest: 38ms Slowest: 1.704s 50%: 313ms 90%: 952ms
 * http://192.168.251.55:8080 - 201 requests: 
	- Avg: 383ms Fastest: 42ms Slowest: 1.632s 50%: 265ms 90%: 882ms

Operation: GET - total: 2656, 44.8%, Concurrency: 20, Ran 4m54s, starting 2022-08-18 16:22:08.236 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 29.28 MiB/s, 2.93 obj/s.
 * http://192.168.251.54:8080: Avg: 28.68 MiB/s, 2.87 obj/s.
 * http://192.168.251.55:8080: Avg: 33.08 MiB/s, 3.31 obj/s.

Requests considered: 2657:
 * Avg: 1.265s, 50%: 1.238s, 90%: 1.84s, 99%: 2.495s, Fastest: 185ms, Slowest: 3.623s
 * TTFB: Avg: 337ms, Best: 4ms, 25th: 29ms, Median: 308ms, 75th: 539ms, 90th: 722ms, 99th: 1.224s, Worst: 1.874s
 * First Access: Avg: 1.288s, 50%: 1.26s, 90%: 1.859s, 99%: 2.527s, Fastest: 192ms, Slowest: 3.623s
 * First Access TTFB: Avg: 346ms, Best: 7ms, 25th: 32ms, Median: 322ms, 75th: 548ms, 90th: 737ms, 99th: 1.241s, Worst: 1.748s
 * Last Access: Avg: 1.258s, 50%: 1.226s, 90%: 1.837s, 99%: 2.456s, Fastest: 192ms, Slowest: 3.623s
 * Last Access TTFB: Avg: 328ms, Best: 4ms, 25th: 28ms, Median: 293ms, 75th: 523ms, 90th: 719ms, 99th: 1.222s, Worst: 1.639s

Requests by host:
 * http://192.168.251.53:8080 - 858 requests: 
	- Avg: 1.274s Fastest: 209ms Slowest: 3.082s 50%: 1.245s 90%: 1.868s
	- First Byte: Avg: 363ms, Best: 4ms, 25th: 25ms, Median: 329ms, 75th: 581ms, 90th: 775ms, 99th: 1.322s, Worst: 1.874s
 * http://192.168.251.54:8080 - 840 requests: 
	- Avg: 1.326s Fastest: 249ms Slowest: 3.623s 50%: 1.302s 90%: 1.909s
	- First Byte: Avg: 329ms, Best: 5ms, 25th: 30ms, Median: 300ms, 75th: 533ms, 90th: 710ms, 99th: 1.271s, Worst: 1.748s
 * http://192.168.251.55:8080 - 972 requests: 
	- Avg: 1.204s Fastest: 185ms Slowest: 2.801s 50%: 1.175s 90%: 1.765s
	- First Byte: Avg: 320ms, Best: 5ms, 25th: 31ms, Median: 292ms, 75th: 513ms, 90th: 698ms, 99th: 1.121s, Worst: 1.383s

Operation: PUT - total: 879, 14.8%, Concurrency: 20, Ran 4m54s, starting 2022-08-18 16:22:08.238 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 10.72 MiB/s, 1.07 obj/s.
 * http://192.168.251.54:8080: Avg: 9.88 MiB/s, 0.99 obj/s.
 * http://192.168.251.55:8080: Avg: 9.83 MiB/s, 0.98 obj/s.

Requests considered: 880:
 * Avg: 2.431s, 50%: 2.365s, 90%: 3.352s, 99%: 4.65s, Fastest: 657ms, Slowest: 6.361s

Requests by host:
 * http://192.168.251.53:8080 - 315 requests: 
	- Avg: 2.432s Fastest: 934ms Slowest: 6.361s 50%: 2.326s 90%: 3.482s
 * http://192.168.251.54:8080 - 289 requests: 
	- Avg: 2.519s Fastest: 1.036s Slowest: 4.855s 50%: 2.495s 90%: 3.475s
 * http://192.168.251.55:8080 - 286 requests: 
	- Avg: 2.364s Fastest: 657ms Slowest: 4.842s 50%: 2.294s 90%: 3.24s

Operation: STAT - total: 1778, 30.0%, Concurrency: 20, Ran 4m54s, starting 2022-08-18 16:22:08.231 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 1.89 obj/s.
 * http://192.168.251.54:8080: Avg: 2.08 obj/s.
 * http://192.168.251.55:8080: Avg: 2.09 obj/s.

Requests considered: 1779:
 * Avg: 48ms, 50%: 18ms, 90%: 72ms, 99%: 600ms, Fastest: 1ms, Slowest: 1.557s
 * First Access: Avg: 49ms, 50%: 18ms, 90%: 99ms, 99%: 595ms, Fastest: 1ms, Slowest: 1.162s
 * Last Access: Avg: 50ms, 50%: 19ms, 90%: 107ms, 99%: 607ms, Fastest: 2ms, Slowest: 1.557s

Requests by host:
 * http://192.168.251.53:8080 - 556 requests: 
	- Avg: 60ms Fastest: 1ms Slowest: 1.162s 50%: 19ms 90%: 137ms
 * http://192.168.251.54:8080 - 609 requests: 
	- Avg: 42ms Fastest: 1ms Slowest: 820ms 50%: 18ms 90%: 50ms
 * http://192.168.251.55:8080 - 616 requests: 
	- Avg: 44ms Fastest: 1ms Slowest: 1.557s 50%: 18ms 90%: 43ms

Cluster Total: 120.87 MiB/s, 20.14 obj/s over 4m55s.
 * http://192.168.251.55:8080: 42.71 MiB/s, 7.04 obj/s
 * http://192.168.251.53:8080: 39.96 MiB/s, 6.53 obj/s
 * http://192.168.251.54:8080: 38.50 MiB/s, 6.62 obj/s
```

![image-20220818163030276](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163030276.png)

![image-20220818163045069](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163045069.png)

![image-20220818163055983](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163055983.png)

![image-20220818163111744](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163111744.png)

![image-20220818163124747](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163124747.png)

![image-20220818163135297](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818163135297.png)

#### 1MB

```
1MB: 25000obj
./warp mixed --host=192.168.251.53:8080,192.168.251.54:8080,192.168.251.55:8080 --objects=25000 --obj.size=1Mib --access-key W6XCJFJX2ETBB387IK4D --secret-key yh8wpPjiQ7wNfbGhKYkFHSNa7OBPHaIWjEQgOPlD --bucket edoc3 --autoterm --analyze.v
```

```
Throughput 15.6 objects/s within 7.500000% for 44.527s. Assuming stability. Terminating benchmark.
warp: Benchmark data written to "warp-mixed-2022-08-18[170605]-3SzX.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 2797, 10.0%, Concurrency: 20, Ran 2m38s, starting 2022-08-18 17:06:08.724 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 5.88 obj/s.
 * http://192.168.251.54:8080: Avg: 5.79 obj/s.
 * http://192.168.251.55:8080: Avg: 6.03 obj/s.

Requests considered: 2798:
 * Avg: 119ms, 50%: 90ms, 90%: 224ms, 99%: 432ms, Fastest: 24ms, Slowest: 935ms

Requests by host:
 * http://192.168.251.53:8080 - 930 requests: 
	- Avg: 119ms Fastest: 25ms Slowest: 567ms 50%: 92ms 90%: 225ms
 * http://192.168.251.54:8080 - 915 requests: 
	- Avg: 123ms Fastest: 24ms Slowest: 790ms 50%: 93ms 90%: 237ms
 * http://192.168.251.55:8080 - 956 requests: 
	- Avg: 116ms Fastest: 29ms Slowest: 935ms 50%: 86ms 90%: 216ms

Operation: GET - total: 12624, 45.0%, Concurrency: 20, Ran 2m39s, starting 2022-08-18 17:06:08.709 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 26.88 MiB/s, 26.88 obj/s.
 * http://192.168.251.54:8080: Avg: 25.32 MiB/s, 25.32 obj/s.
 * http://192.168.251.55:8080: Avg: 27.18 MiB/s, 27.18 obj/s.

Requests considered: 12625:
 * Avg: 111ms, 50%: 104ms, 90%: 189ms, 99%: 296ms, Fastest: 12ms, Slowest: 607ms
 * TTFB: Avg: 65ms, Best: 2ms, 25th: 14ms, Median: 59ms, 75th: 94ms, 90th: 133ms, 99th: 235ms, Worst: 581ms
 * First Access: Avg: 112ms, 50%: 105ms, 90%: 186ms, 99%: 294ms, Fastest: 16ms, Slowest: 607ms
 * First Access TTFB: Avg: 65ms, Best: 3ms, 25th: 16ms, Median: 60ms, 75th: 93ms, 90th: 131ms, 99th: 229ms, Worst: 581ms
 * Last Access: Avg: 114ms, 50%: 106ms, 90%: 194ms, 99%: 305ms, Fastest: 12ms, Slowest: 607ms
 * Last Access TTFB: Avg: 67ms, Best: 2ms, 25th: 15ms, Median: 62ms, 75th: 97ms, 90th: 138ms, 99th: 246ms, Worst: 581ms

Requests by host:
 * http://192.168.251.53:8080 - 4277 requests: 
	- Avg: 109ms Fastest: 13ms Slowest: 490ms 50%: 101ms 90%: 185ms
	- First Byte: Avg: 65ms, Best: 2ms, 25th: 12ms, Median: 59ms, 75th: 95ms, 90th: 135ms, 99th: 256ms, Worst: 459ms
 * http://192.168.251.54:8080 - 4029 requests: 
	- Avg: 118ms Fastest: 14ms Slowest: 591ms 50%: 111ms 90%: 199ms
	- First Byte: Avg: 63ms, Best: 2ms, 25th: 16ms, Median: 58ms, 75th: 93ms, 90th: 131ms, 99th: 225ms, Worst: 484ms
 * http://192.168.251.55:8080 - 4322 requests: 
	- Avg: 108ms Fastest: 12ms Slowest: 607ms 50%: 101ms 90%: 182ms
	- First Byte: Avg: 66ms, Best: 2ms, 25th: 16ms, Median: 61ms, 75th: 94ms, 90th: 133ms, 99th: 234ms, Worst: 581ms

Operation: PUT - total: 4195, 15.0%, Concurrency: 20, Ran 2m39s, starting 2022-08-18 17:06:08.772 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 8.98 MiB/s, 8.98 obj/s.
 * http://192.168.251.54:8080: Avg: 8.52 MiB/s, 8.52 obj/s.
 * http://192.168.251.55:8080: Avg: 8.98 MiB/s, 8.98 obj/s.

Requests considered: 4196:
 * Avg: 308ms, 50%: 283ms, 90%: 465ms, 99%: 727ms, Fastest: 89ms, Slowest: 1.241s

Requests by host:
 * http://192.168.251.53:8080 - 1425 requests: 
	- Avg: 305ms Fastest: 108ms Slowest: 970ms 50%: 284ms 90%: 455ms
 * http://192.168.251.54:8080 - 1353 requests: 
	- Avg: 313ms Fastest: 93ms Slowest: 1.169s 50%: 287ms 90%: 478ms
 * http://192.168.251.55:8080 - 1424 requests: 
	- Avg: 305ms Fastest: 89ms Slowest: 1.241s 50%: 279ms 90%: 467ms

Operation: STAT - total: 8415, 30.0%, Concurrency: 20, Ran 2m39s, starting 2022-08-18 17:06:08.718 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 17.32 obj/s.
 * http://192.168.251.54:8080: Avg: 17.48 obj/s.
 * http://192.168.251.55:8080: Avg: 18.13 obj/s.

Requests considered: 8416:
 * Avg: 17ms, 50%: 14ms, 90%: 27ms, 99%: 104ms, Fastest: 1ms, Slowest: 408ms
 * First Access: Avg: 17ms, 50%: 14ms, 90%: 27ms, 99%: 107ms, Fastest: 1ms, Slowest: 408ms
 * Last Access: Avg: 17ms, 50%: 14ms, 90%: 27ms, 99%: 109ms, Fastest: 1ms, Slowest: 374ms

Requests by host:
 * http://192.168.251.53:8080 - 2756 requests: 
	- Avg: 17ms Fastest: 1ms Slowest: 339ms 50%: 13ms 90%: 27ms
 * http://192.168.251.54:8080 - 2781 requests: 
	- Avg: 18ms Fastest: 1ms Slowest: 408ms 50%: 14ms 90%: 28ms
 * http://192.168.251.55:8080 - 2882 requests: 
	- Avg: 17ms Fastest: 1ms Slowest: 374ms 50%: 14ms 90%: 26ms

Cluster Total: 105.74 MiB/s, 176.22 obj/s over 2m39s.
 * http://192.168.251.55:8080: 36.13 MiB/s, 60.27 obj/s
 * http://192.168.251.53:8080: 35.83 MiB/s, 59.00 obj/s
 * http://192.168.251.54:8080: 33.82 MiB/s, 57.02 obj/s
warp: <ERROR> Truncated response should have continuation token set                                                                                                                          
warp: Cleanup Done.
```

![image-20220818171626254](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171626254.png)

![image-20220818171637858](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171637858.png)

![image-20220818171647936](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171647936.png)

![image-20220818171706770](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171706770.png)

![image-20220818171723154](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171723154.png)

![image-20220818171731010](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818171731010.png)

#### 100Kib

```
./warp mixed --host=192.168.251.53:8080,192.168.251.54:8080,192.168.251.55:8080 --objects=250000 --obj.size=100Kib --access-key W6XCJFJX2ETBB387IK4D --secret-key yh8wpPjiQ7wNfbGhKYkFHSNa7OBPHaIWjEQgOPlD --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-18[172418]-9p8t.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 41526, 10.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 17:24:21.861 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 45.72 obj/s.
 * http://192.168.251.54:8080: Avg: 47.03 obj/s.
 * http://192.168.251.55:8080: Avg: 45.79 obj/s.

Requests considered: 41527:
 * Avg: 26ms, 50%: 17ms, 90%: 36ms, 99%: 195ms, Fastest: 4ms, Slowest: 959ms

Requests by host:
 * http://192.168.251.53:8080 - 13706 requests: 
	- Avg: 26ms Fastest: 5ms Slowest: 888ms 50%: 17ms 90%: 37ms
 * http://192.168.251.54:8080 - 14101 requests: 
	- Avg: 25ms Fastest: 4ms Slowest: 959ms 50%: 16ms 90%: 35ms
 * http://192.168.251.55:8080 - 13726 requests: 
	- Avg: 27ms Fastest: 4ms Slowest: 861ms 50%: 17ms 90%: 37ms

Operation: GET - total: 186914, 45.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 17:24:21.841 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 20.26 MiB/s, 207.45 obj/s.
 * http://192.168.251.54:8080: Avg: 20.37 MiB/s, 208.62 obj/s.
 * http://192.168.251.55:8080: Avg: 20.24 MiB/s, 207.24 obj/s.

Requests considered: 186915:
 * Avg: 12ms, 50%: 8ms, 90%: 17ms, 99%: 79ms, Fastest: 2ms, Slowest: 993ms
 * TTFB: Avg: 10ms, Best: 1ms, 25th: 4ms, Median: 6ms, 75th: 9ms, 90th: 14ms, 99th: 77ms, Worst: 989ms
 * First Access: Avg: 15ms, 50%: 9ms, 90%: 21ms, 99%: 95ms, Fastest: 2ms, Slowest: 993ms
 * First Access TTFB: Avg: 12ms, Best: 1ms, 25th: 4ms, Median: 7ms, 75th: 10ms, 90th: 18ms, 99th: 92ms, Worst: 989ms
 * Last Access: Avg: 13ms, 50%: 8ms, 90%: 17ms, 99%: 85ms, Fastest: 2ms, Slowest: 993ms
 * Last Access TTFB: Avg: 10ms, Best: 1ms, 25th: 4ms, Median: 6ms, 75th: 9ms, 90th: 14ms, 99th: 83ms, Worst: 989ms

Requests by host:
 * http://192.168.251.53:8080 - 62212 requests: 
	- Avg: 12ms Fastest: 2ms Slowest: 898ms 50%: 8ms 90%: 17ms
	- First Byte: Avg: 10ms, Best: 1ms, 25th: 4ms, Median: 6ms, 75th: 9ms, 90th: 14ms, 99th: 79ms, Worst: 897ms
 * http://192.168.251.54:8080 - 62561 requests: 
	- Avg: 12ms Fastest: 2ms Slowest: 993ms 50%: 8ms 90%: 16ms
	- First Byte: Avg: 10ms, Best: 1ms, 25th: 4ms, Median: 6ms, 75th: 9ms, 90th: 13ms, 99th: 77ms, Worst: 989ms
 * http://192.168.251.55:8080 - 62148 requests: 
	- Avg: 12ms Fastest: 2ms Slowest: 889ms 50%: 8ms 90%: 17ms
	- First Byte: Avg: 10ms, Best: 1ms, 25th: 4ms, Median: 6ms, 75th: 9ms, 90th: 13ms, 99th: 76ms, Worst: 887ms

Operation: PUT - total: 62289, 15.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 17:24:21.846 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 6.78 MiB/s, 69.39 obj/s.
 * http://192.168.251.54:8080: Avg: 6.84 MiB/s, 70.03 obj/s.
 * http://192.168.251.55:8080: Avg: 6.67 MiB/s, 68.34 obj/s.

Requests considered: 62290:
 * Avg: 31ms, 50%: 22ms, 90%: 42ms, 99%: 199ms, Fastest: 7ms, Slowest: 979ms

Requests by host:
 * http://192.168.251.53:8080 - 20809 requests: 
	- Avg: 31ms Fastest: 8ms Slowest: 960ms 50%: 22ms 90%: 41ms
 * http://192.168.251.54:8080 - 20998 requests: 
	- Avg: 31ms Fastest: 7ms Slowest: 979ms 50%: 22ms 90%: 42ms
 * http://192.168.251.55:8080 - 20492 requests: 
	- Avg: 31ms Fastest: 8ms Slowest: 974ms 50%: 22ms 90%: 42ms

Operation: STAT - total: 124627, 30.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 17:24:21.843 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 136.87 obj/s.
 * http://192.168.251.54:8080: Avg: 140.58 obj/s.
 * http://192.168.251.55:8080: Avg: 138.15 obj/s.

Requests considered: 124628:
 * Avg: 5ms, 50%: 3ms, 90%: 7ms, 99%: 35ms, Fastest: 1ms, Slowest: 915ms
 * First Access: Avg: 5ms, 50%: 3ms, 90%: 7ms, 99%: 34ms, Fastest: 1ms, Slowest: 842ms
 * Last Access: Avg: 5ms, 50%: 3ms, 90%: 7ms, 99%: 36ms, Fastest: 1ms, Slowest: 848ms

Requests by host:
 * http://192.168.251.53:8080 - 41044 requests: 
	- Avg: 5ms Fastest: 1ms Slowest: 915ms 50%: 3ms 90%: 7ms
 * http://192.168.251.54:8080 - 42159 requests: 
	- Avg: 5ms Fastest: 1ms Slowest: 848ms 50%: 3ms 90%: 7ms
 * http://192.168.251.55:8080 - 41429 requests: 
	- Avg: 5ms Fastest: 1ms Slowest: 801ms 50%: 3ms 90%: 7ms

Cluster Total: 81.16 MiB/s, 1385.14 obj/s over 5m0s.
 * http://192.168.251.53:8080: 27.04 MiB/s, 459.42 obj/s
 * http://192.168.251.54:8080: 27.21 MiB/s, 466.24 obj/s
 * http://192.168.251.55:8080: 26.91 MiB/s, 459.49 obj/s
warp: <ERROR> Truncated response should have continuation token set 
```

![image-20220818173045228](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818173045228.png)

![image-20220818173057627](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818173057627.png)

![image-20220818173107826](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818173107826.png)

![image-20220818173121784](C:\Users\XYB\Desktop\k8s调研\assets\image-20220818173121784.png)

#### 10Kib

```
./warp mixed --host=192.168.251.53:8080,192.168.251.54:8080,192.168.251.55:8080 --objects=2500000 --obj.size=10Kib --access-key W6XCJFJX2ETBB387IK4D --secret-key yh8wpPjiQ7wNfbGhKYkFHSNa7OBPHaIWjEQgOPlD --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-18[182256]-3RMi.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 76566, 10.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 18:22:59.49 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 84.73 obj/s.
 * http://192.168.251.54:8080: Avg: 86.43 obj/s.
 * http://192.168.251.55:8080: Avg: 84.23 obj/s.

Requests considered: 76567:
 * Avg: 15ms, 50%: 6ms, 90%: 24ms, 99%: 119ms, Fastest: 3ms, Slowest: 2.619s

Requests by host:
 * http://192.168.251.53:8080 - 25398 requests: 
	- Avg: 15ms Fastest: 3ms Slowest: 2.564s 50%: 6ms 90%: 25ms
 * http://192.168.251.54:8080 - 25914 requests: 
	- Avg: 15ms Fastest: 3ms Slowest: 2.578s 50%: 6ms 90%: 24ms
 * http://192.168.251.55:8080 - 25258 requests: 
	- Avg: 15ms Fastest: 3ms Slowest: 2.619s 50%: 7ms 90%: 25ms

Operation: GET - total: 344555, 45.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 18:22:59.482 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 3.71 MiB/s, 380.10 obj/s.
 * http://192.168.251.54:8080: Avg: 3.79 MiB/s, 388.04 obj/s.
 * http://192.168.251.55:8080: Avg: 3.72 MiB/s, 380.84 obj/s.

Requests considered: 344556:
 * Avg: 7ms, 50%: 3ms, 90%: 12ms, 99%: 57ms, Fastest: 1ms, Slowest: 2.603s
 * TTFB: Avg: 7ms, Best: 1ms, 25th: 2ms, Median: 2ms, 75th: 5ms, 90th: 11ms, 99th: 55ms, Worst: 2.603s
 * First Access: Avg: 7ms, 50%: 3ms, 90%: 13ms, 99%: 60ms, Fastest: 1ms, Slowest: 2.603s
 * First Access TTFB: Avg: 7ms, Best: 1ms, 25th: 2ms, Median: 3ms, 75th: 5ms, 90th: 12ms, 99th: 58ms, Worst: 2.603s
 * Last Access: Avg: 7ms, 50%: 3ms, 90%: 12ms, 99%: 58ms, Fastest: 1ms, Slowest: 2.603s
 * Last Access TTFB: Avg: 7ms, Best: 1ms, 25th: 2ms, Median: 2ms, 75th: 5ms, 90th: 11ms, 99th: 56ms, Worst: 2.603s

Requests by host:
 * http://192.168.251.53:8080 - 113985 requests: 
	- Avg: 7ms Fastest: 1ms Slowest: 2.59s 50%: 3ms 90%: 12ms
	- First Byte: Avg: 7ms, Best: 1ms, 25th: 2ms, Median: 2ms, 75th: 5ms, 90th: 11ms, 99th: 57ms, Worst: 2.59s
 * http://192.168.251.54:8080 - 116367 requests: 
	- Avg: 7ms Fastest: 1ms Slowest: 2.6s 50%: 3ms 90%: 12ms
	- First Byte: Avg: 6ms, Best: 1ms, 25th: 2ms, Median: 2ms, 75th: 5ms, 90th: 11ms, 99th: 54ms, Worst: 2.597s
 * http://192.168.251.55:8080 - 114207 requests: 
	- Avg: 7ms Fastest: 1ms Slowest: 2.603s 50%: 3ms 90%: 12ms
	- First Byte: Avg: 7ms, Best: 1ms, 25th: 2ms, Median: 2ms, 75th: 5ms, 90th: 11ms, 99th: 55ms, Worst: 2.603s

Operation: PUT - total: 114840, 15.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 18:22:59.484 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 1.24 MiB/s, 126.59 obj/s.
 * http://192.168.251.54:8080: Avg: 1.26 MiB/s, 128.86 obj/s.
 * http://192.168.251.55:8080: Avg: 1.25 MiB/s, 127.53 obj/s.

Requests considered: 114841:
 * Avg: 15ms, 50%: 7ms, 90%: 24ms, 99%: 113ms, Fastest: 3ms, Slowest: 2.603s

Requests by host:
 * http://192.168.251.53:8080 - 37960 requests: 
	- Avg: 15ms Fastest: 3ms Slowest: 2.603s 50%: 6ms 90%: 25ms
 * http://192.168.251.54:8080 - 38645 requests: 
	- Avg: 15ms Fastest: 4ms Slowest: 2.574s 50%: 7ms 90%: 24ms
 * http://192.168.251.55:8080 - 38243 requests: 
	- Avg: 15ms Fastest: 4ms Slowest: 2.582s 50%: 7ms 90%: 24ms

Operation: STAT - total: 229698, 30.0%, Concurrency: 20, Ran 4m59s, starting 2022-08-18 18:22:59.481 +0800 CST

Throughput by host:
 * http://192.168.251.53:8080: Avg: 252.81 obj/s.
 * http://192.168.251.54:8080: Avg: 259.03 obj/s.
 * http://192.168.251.55:8080: Avg: 254.14 obj/s.

Requests considered: 229699:
 * Avg: 3ms, 50%: 2ms, 90%: 4ms, 99%: 27ms, Fastest: 1ms, Slowest: 995ms
 * First Access: Avg: 3ms, 50%: 2ms, 90%: 4ms, 99%: 27ms, Fastest: 1ms, Slowest: 995ms
 * Last Access: Avg: 3ms, 50%: 2ms, 90%: 4ms, 99%: 27ms, Fastest: 1ms, Slowest: 995ms

Requests by host:
 * http://192.168.251.53:8080 - 75814 requests: 
	- Avg: 3ms Fastest: 1ms Slowest: 794ms 50%: 1ms 90%: 4ms
 * http://192.168.251.54:8080 - 77678 requests: 
	- Avg: 3ms Fastest: 1ms Slowest: 969ms 50%: 1ms 90%: 4ms
 * http://192.168.251.55:8080 - 76210 requests: 
	- Avg: 3ms Fastest: 1ms Slowest: 995ms 50%: 2ms 90%: 4ms

Cluster Total: 14.96 MiB/s, 2553.25 obj/s over 5m0s.
 * http://192.168.251.53:8080: 4.95 MiB/s, 844.18 obj/s
 * http://192.168.251.55:8080: 4.96 MiB/s, 846.72 obj/s
 * http://192.168.251.54:8080: 5.05 MiB/s, 862.34 obj/s
```

![image-20220819085418398](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085418398.png)

![image-20220819085516032](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085516032.png)

![image-20220819085528092](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085528092.png)

![image-20220819085539626](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085539626.png)

![image-20220819085558211](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085558211.png)

![image-20220819085612247](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085612247.png)

![image-20220819085621642](C:\Users\XYB\Desktop\k8s调研\assets\image-20220819085621642.png)

### minio上传下载

```
[root@centos158 storgetest]# mc cp 10g.dat minio/edoc2
/root/storgetest/10g.dat:          10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 54.02 MiB/s 3m9s
```

```
[root@centos158 storgetest]# mc cp minio/edoc2/10g.dat /tmp
...68.251.54:19000/edoc2/10g.dat:  10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 81.44 MiB/s 2m5s
```

### minio混合压测

#### 10MB

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=2500 --obj.size=10Mib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[140443]-wKzI.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 701, 9.9%, Concurrency: 20, Ran 4m55s, starting 2022-08-22 14:04:48.962 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 0.81 obj/s.
 * http://192.168.251.54:19000: Avg: 0.75 obj/s.
 * http://192.168.251.55:19000: Avg: 0.90 obj/s.

Requests considered: 702:
 * Avg: 231ms, 50%: 236ms, 90%: 314ms, 99%: 361ms, Fastest: 76ms, Slowest: 1.204s

Requests by host:
 * http://192.168.251.53:19000 - 232 requests: 
	- Avg: 192ms Fastest: 76ms Slowest: 497ms 50%: 209ms 90%: 261ms
 * http://192.168.251.54:19000 - 211 requests: 
	- Avg: 245ms Fastest: 133ms Slowest: 363ms 50%: 254ms 90%: 323ms
 * http://192.168.251.55:19000 - 261 requests: 
	- Avg: 255ms Fastest: 109ms Slowest: 1.204s 50%: 258ms 90%: 325ms

Operation: GET - total: 3183, 44.9%, Concurrency: 20, Ran 4m55s, starting 2022-08-22 14:04:49.037 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 36.27 MiB/s, 3.63 obj/s.
 * http://192.168.251.54:19000: Avg: 34.21 MiB/s, 3.42 obj/s.
 * http://192.168.251.55:19000: Avg: 38.01 MiB/s, 3.80 obj/s.

Requests considered: 3184:
 * Avg: 1.359s, 50%: 1.215s, 90%: 2.078s, 99%: 4.412s, Fastest: 231ms, Slowest: 6.861s
 * TTFB: Avg: 257ms, Best: 13ms, 25th: 73ms, Median: 213ms, 75th: 366ms, 90th: 556ms, 99th: 904ms, Worst: 1.151s
 * First Access: Avg: 1.36s, 50%: 1.223s, 90%: 2.072s, 99%: 4.433s, Fastest: 231ms, Slowest: 6.017s
 * First Access TTFB: Avg: 255ms, Best: 17ms, 25th: 73ms, Median: 217ms, 75th: 361ms, 90th: 543ms, 99th: 928ms, Worst: 1.12s
 * Last Access: Avg: 1.381s, 50%: 1.227s, 90%: 2.099s, 99%: 4.677s, Fastest: 231ms, Slowest: 6.861s
 * Last Access TTFB: Avg: 268ms, Best: 17ms, 25th: 76ms, Median: 217ms, 75th: 375ms, 90th: 577ms, 99th: 910ms, Worst: 1.151s

Requests by host:
 * http://192.168.251.53:19000 - 1065 requests: 
	- Avg: 1.369s Fastest: 311ms Slowest: 6.861s 50%: 1.254s 90%: 1.997s
	- First Byte: Avg: 222ms, Best: 13ms, 25th: 38ms, Median: 181ms, 75th: 333ms, 90th: 509ms, 99th: 865ms, Worst: 1.073s
 * http://192.168.251.54:19000 - 1008 requests: 
	- Avg: 1.43s Fastest: 231ms Slowest: 6.621s 50%: 1.296s 90%: 2.163s
	- First Byte: Avg: 267ms, Best: 38ms, 25th: 78ms, Median: 212ms, 75th: 372ms, 90th: 593ms, 99th: 932ms, Worst: 1.091s
 * http://192.168.251.55:19000 - 1121 requests: 
	- Avg: 1.292s Fastest: 247ms Slowest: 6.069s 50%: 1.116s 90%: 2.078s
	- First Byte: Avg: 282ms, Best: 18ms, 25th: 92ms, Median: 240ms, 75th: 388ms, 90th: 574ms, 99th: 907ms, Worst: 1.151s

Operation: PUT - total: 1055, 14.9%, Concurrency: 20, Ran 4m54s, starting 2022-08-22 14:04:49.427 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 11.11 MiB/s, 1.11 obj/s.
 * http://192.168.251.54:19000: Avg: 11.97 MiB/s, 1.20 obj/s.
 * http://192.168.251.55:19000: Avg: 13.28 MiB/s, 1.33 obj/s.

Requests considered: 1056:
 * Avg: 1.143s, 50%: 909ms, 90%: 2.179s, 99%: 4.782s, Fastest: 197ms, Slowest: 6.68s

Requests by host:
 * http://192.168.251.53:19000 - 325 requests: 
	- Avg: 1.341s Fastest: 197ms Slowest: 6.68s 50%: 982ms 90%: 2.993s
 * http://192.168.251.54:19000 - 351 requests: 
	- Avg: 1.166s Fastest: 252ms Slowest: 5.713s 50%: 953ms 90%: 2.154s
 * http://192.168.251.55:19000 - 386 requests: 
	- Avg: 960ms Fastest: 228ms Slowest: 4.573s 50%: 863ms 90%: 1.727s

Operation: STAT - total: 2130, 30.1%, Concurrency: 20, Ran 4m54s, starting 2022-08-22 14:04:49.205 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 2.34 obj/s.
 * http://192.168.251.54:19000: Avg: 2.26 obj/s.
 * http://192.168.251.55:19000: Avg: 2.67 obj/s.

Requests considered: 2131:
 * Avg: 71ms, 50%: 79ms, 90%: 107ms, 99%: 124ms, Fastest: 9ms, Slowest: 748ms
 * First Access: Avg: 70ms, 50%: 79ms, 90%: 106ms, 99%: 122ms, Fastest: 9ms, Slowest: 526ms
 * Last Access: Avg: 70ms, 50%: 78ms, 90%: 107ms, 99%: 124ms, Fastest: 12ms, Slowest: 748ms

Requests by host:
 * http://192.168.251.53:19000 - 688 requests: 
	- Avg: 30ms Fastest: 9ms Slowest: 78ms 50%: 30ms 90%: 37ms
 * http://192.168.251.54:19000 - 659 requests: 
	- Avg: 94ms Fastest: 51ms Slowest: 130ms 50%: 95ms 90%: 111ms
 * http://192.168.251.55:19000 - 786 requests: 
	- Avg: 87ms Fastest: 24ms Slowest: 748ms 50%: 87ms 90%: 108ms

Cluster Total: 144.21 MiB/s, 24.03 obj/s over 4m55s.
 * http://192.168.251.53:19000: 47.20 MiB/s, 7.84 obj/s
 * http://192.168.251.54:19000: 46.06 MiB/s, 7.55 obj/s
 * http://192.168.251.55:19000: 51.09 MiB/s, 8.66 obj/s
warp: Cleanup Done.
```

![image-20220822141352534](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822141352534.png)

![image-20220822141403711](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822141403711.png)

![image-20220822141420957](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822141420957.png)

![image-20220822141433148](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822141433148.png)

![image-20220822141445863](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822141445863.png)

#### 1MB

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=25000 --obj.size=1Mib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --autoterm --analyze.v
```

```
Throughput 96.7MiB/s within 7.500000% for 12.775s. Assuming stability. Terminating benchmark.
warp: Benchmark data written to "warp-mixed-2022-08-22[142816]-VhHc.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 949, 10.1%, Concurrency: 20, Ran 45s, starting 2022-08-22 14:28:20.454 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 7.52 obj/s.
 * http://192.168.251.54:19000: Avg: 7.30 obj/s.
 * http://192.168.251.55:19000: Avg: 6.23 obj/s.

Requests considered: 950:
 * Avg: 125ms, 50%: 118ms, 90%: 168ms, 99%: 785ms, Fastest: 9ms, Slowest: 927ms

Requests by host:
 * http://192.168.251.53:19000 - 342 requests: 
	- Avg: 106ms Fastest: 11ms Slowest: 863ms 50%: 100ms 90%: 143ms
 * http://192.168.251.54:19000 - 330 requests: 
	- Avg: 133ms Fastest: 9ms Slowest: 866ms 50%: 125ms 90%: 174ms
 * http://192.168.251.55:19000 - 280 requests: 
	- Avg: 137ms Fastest: 20ms Slowest: 927ms 50%: 132ms 90%: 175ms

Operation: GET - total: 4227, 44.8%, Concurrency: 20, Ran 45s, starting 2022-08-22 14:28:20.327 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 36.43 MiB/s, 36.43 obj/s.
 * http://192.168.251.54:19000: Avg: 27.88 MiB/s, 27.88 obj/s.
 * http://192.168.251.55:19000: Avg: 28.43 MiB/s, 28.43 obj/s.

Requests considered: 4228:
 * Avg: 125ms, 50%: 111ms, 90%: 182ms, 99%: 791ms, Fastest: 14ms, Slowest: 1.304s
 * TTFB: Avg: 89ms, Best: 5ms, 25th: 37ms, Median: 77ms, 75th: 110ms, 90th: 140ms, 99th: 688ms, Worst: 1.292s
 * First Access: Avg: 125ms, 50%: 111ms, 90%: 181ms, 99%: 766ms, Fastest: 14ms, Slowest: 1.232s
 * First Access TTFB: Avg: 89ms, Best: 5ms, 25th: 37ms, Median: 77ms, 75th: 110ms, 90th: 139ms, 99th: 684ms, Worst: 1.158s
 * Last Access: Avg: 123ms, 50%: 110ms, 90%: 181ms, 99%: 738ms, Fastest: 14ms, Slowest: 1.304s
 * Last Access TTFB: Avg: 88ms, Best: 5ms, 25th: 37ms, Median: 77ms, 75th: 109ms, 90th: 140ms, 99th: 673ms, Worst: 1.292s

Requests by host:
 * http://192.168.251.53:19000 - 1666 requests: 
	- Avg: 118ms Fastest: 14ms Slowest: 1.304s 50%: 103ms 90%: 177ms
	- First Byte: Avg: 79ms, Best: 5ms, 25th: 22ms, Median: 67ms, 75th: 100ms, 90th: 130ms, 99th: 688ms, Worst: 1.292s
 * http://192.168.251.54:19000 - 1271 requests: 
	- Avg: 126ms Fastest: 17ms Slowest: 1.146s 50%: 112ms 90%: 187ms
	- First Byte: Avg: 92ms, Best: 7ms, 25th: 42ms, Median: 80ms, 75th: 115ms, 90th: 145ms, 99th: 529ms, Worst: 1.106s
 * http://192.168.251.55:19000 - 1300 requests: 
	- Avg: 132ms Fastest: 25ms Slowest: 1.303s 50%: 116ms 90%: 182ms
	- First Byte: Avg: 100ms, Best: 6ms, 25th: 49ms, Median: 87ms, 75th: 118ms, 90th: 145ms, 99th: 795ms, Worst: 1.287s

Operation: PUT - total: 1411, 14.9%, Concurrency: 20, Ran 45s, starting 2022-08-22 14:28:20.398 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 11.93 MiB/s, 11.93 obj/s.
 * http://192.168.251.54:19000: Avg: 9.54 MiB/s, 9.54 obj/s.
 * http://192.168.251.55:19000: Avg: 9.58 MiB/s, 9.58 obj/s.

Requests considered: 1412:
 * Avg: 116ms, 50%: 116ms, 90%: 193ms, 99%: 257ms, Fastest: 18ms, Slowest: 285ms

Requests by host:
 * http://192.168.251.53:19000 - 544 requests: 
	- Avg: 93ms Fastest: 18ms Slowest: 264ms 50%: 88ms 90%: 169ms
 * http://192.168.251.54:19000 - 435 requests: 
	- Avg: 133ms Fastest: 18ms Slowest: 285ms 50%: 136ms 90%: 207ms
 * http://192.168.251.55:19000 - 437 requests: 
	- Avg: 127ms Fastest: 22ms Slowest: 284ms 50%: 125ms 90%: 196ms

Operation: STAT - total: 2838, 30.1%, Concurrency: 20, Ran 45s, starting 2022-08-22 14:28:20.334 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 23.74 obj/s.
 * http://192.168.251.54:19000: Avg: 19.47 obj/s.
 * http://192.168.251.55:19000: Avg: 19.05 obj/s.

Requests considered: 2839:
 * Avg: 36ms, 50%: 32ms, 90%: 60ms, 99%: 80ms, Fastest: 2ms, Slowest: 962ms
 * First Access: Avg: 36ms, 50%: 32ms, 90%: 60ms, 99%: 80ms, Fastest: 2ms, Slowest: 962ms
 * Last Access: Avg: 35ms, 50%: 32ms, 90%: 60ms, 99%: 80ms, Fastest: 2ms, Slowest: 962ms

Requests by host:
 * http://192.168.251.53:19000 - 1084 requests: 
	- Avg: 17ms Fastest: 2ms Slowest: 752ms 50%: 16ms 90%: 25ms
 * http://192.168.251.54:19000 - 890 requests: 
	- Avg: 47ms Fastest: 3ms Slowest: 962ms 50%: 45ms 90%: 66ms
 * http://192.168.251.55:19000 - 868 requests: 
	- Avg: 46ms Fastest: 3ms Slowest: 684ms 50%: 45ms 90%: 64ms

Cluster Total: 123.57 MiB/s, 206.49 obj/s over 46s.
 * http://192.168.251.55:19000: 37.99 MiB/s, 63.09 obj/s
 * http://192.168.251.53:19000: 48.33 MiB/s, 79.52 obj/s
 * http://192.168.251.54:19000: 37.38 MiB/s, 64.06 obj/s
warp: Cleanup Done.
```

![image-20220822143325444](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143325444.png)

![image-20220822143336487](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143336487.png)

![image-20220822143347458](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143347458.png)

![image-20220822143357324](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143357324.png)

![image-20220822143414065](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143414065.png)

![image-20220822143427045](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822143427045.png)

#### 100kib

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[143603]-h99U.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 33576, 10.0%, Concurrency: 20, Ran 4m58s, starting 2022-08-22 14:36:08.722 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 45.63 obj/s.
 * http://192.168.251.54:19000: Avg: 32.97 obj/s.
 * http://192.168.251.55:19000: Avg: 34.12 obj/s.

Requests considered: 33577:
 * Avg: 31ms, 50%: 22ms, 90%: 34ms, 99%: 286ms, Fastest: 4ms, Slowest: 4.886s

Requests by host:
 * http://192.168.251.53:19000 - 13597 requests: 
	- Avg: 28ms Fastest: 4ms Slowest: 4.671s 50%: 19ms 90%: 31ms
 * http://192.168.251.54:19000 - 9818 requests: 
	- Avg: 34ms Fastest: 6ms Slowest: 4.886s 50%: 23ms 90%: 35ms
 * http://192.168.251.55:19000 - 10169 requests: 
	- Avg: 34ms Fastest: 5ms Slowest: 3.151s 50%: 23ms 90%: 34ms

Operation: GET - total: 151129, 45.0%, Concurrency: 20, Ran 4m58s, starting 2022-08-22 14:36:08.7 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 19.77 MiB/s, 202.49 obj/s.
 * http://192.168.251.54:19000: Avg: 14.70 MiB/s, 150.53 obj/s.
 * http://192.168.251.55:19000: Avg: 15.05 MiB/s, 154.12 obj/s.

Requests considered: 151130:
 * Avg: 22ms, 50%: 12ms, 90%: 20ms, 99%: 258ms, Fastest: 3ms, Slowest: 4.903s
 * TTFB: Avg: 20ms, Best: 2ms, 25th: 7ms, Median: 10ms, 75th: 13ms, 90th: 18ms, 99th: 255ms, Worst: 4.897s
 * First Access: Avg: 23ms, 50%: 12ms, 90%: 20ms, 99%: 276ms, Fastest: 3ms, Slowest: 4.903s
 * First Access TTFB: Avg: 21ms, Best: 2ms, 25th: 7ms, Median: 10ms, 75th: 13ms, 90th: 17ms, 99th: 273ms, Worst: 4.897s
 * Last Access: Avg: 21ms, 50%: 12ms, 90%: 20ms, 99%: 236ms, Fastest: 3ms, Slowest: 4.903s
 * Last Access TTFB: Avg: 19ms, Best: 2ms, 25th: 7ms, Median: 10ms, 75th: 13ms, 90th: 18ms, 99th: 233ms, Worst: 4.897s

Requests by host:
 * http://192.168.251.53:19000 - 60348 requests: 
	- Avg: 19ms Fastest: 3ms Slowest: 4.903s 50%: 10ms 90%: 18ms
	- First Byte: Avg: 17ms, Best: 2ms, 25th: 6ms, Median: 8ms, 75th: 11ms, 90th: 16ms, 99th: 218ms, Worst: 4.897s
 * http://192.168.251.54:19000 - 44859 requests: 
	- Avg: 24ms Fastest: 4ms Slowest: 4.87s 50%: 13ms 90%: 21ms
	- First Byte: Avg: 22ms, Best: 3ms, 25th: 8ms, Median: 11ms, 75th: 14ms, 90th: 19ms, 99th: 280ms, Worst: 4.863s
 * http://192.168.251.55:19000 - 45933 requests: 
	- Avg: 23ms Fastest: 3ms Slowest: 4.877s 50%: 13ms 90%: 21ms
	- First Byte: Avg: 21ms, Best: 2ms, 25th: 8ms, Median: 11ms, 75th: 14ms, 90th: 19ms, 99th: 268ms, Worst: 4.871s

Operation: PUT - total: 50374, 15.0%, Concurrency: 20, Ran 4m58s, starting 2022-08-22 14:36:08.695 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 6.70 MiB/s, 68.56 obj/s.
 * http://192.168.251.54:19000: Avg: 4.81 MiB/s, 49.30 obj/s.
 * http://192.168.251.55:19000: Avg: 5.00 MiB/s, 51.21 obj/s.

Requests considered: 50375:
 * Avg: 14ms, 50%: 13ms, 90%: 21ms, 99%: 28ms, Fastest: 3ms, Slowest: 990ms

Requests by host:
 * http://192.168.251.53:19000 - 20424 requests: 
	- Avg: 10ms Fastest: 3ms Slowest: 955ms 50%: 10ms 90%: 15ms
 * http://192.168.251.54:19000 - 14693 requests: 
	- Avg: 17ms Fastest: 5ms Slowest: 349ms 50%: 16ms 90%: 23ms
 * http://192.168.251.55:19000 - 15260 requests: 
	- Avg: 16ms Fastest: 4ms Slowest: 990ms 50%: 15ms 90%: 22ms

Operation: STAT - total: 100748, 30.0%, Concurrency: 20, Ran 4m58s, starting 2022-08-22 14:36:08.708 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 135.98 obj/s.
 * http://192.168.251.54:19000: Avg: 99.37 obj/s.
 * http://192.168.251.55:19000: Avg: 102.73 obj/s.

Requests considered: 100749:
 * Avg: 9ms, 50%: 6ms, 90%: 12ms, 99%: 30ms, Fastest: 1ms, Slowest: 2.789s
 * First Access: Avg: 9ms, 50%: 6ms, 90%: 12ms, 99%: 31ms, Fastest: 1ms, Slowest: 2.789s
 * Last Access: Avg: 9ms, 50%: 6ms, 90%: 12ms, 99%: 30ms, Fastest: 1ms, Slowest: 2.789s

Requests by host:
 * http://192.168.251.53:19000 - 40524 requests: 
	- Avg: 6ms Fastest: 1ms Slowest: 2.789s 50%: 4ms 90%: 7ms
 * http://192.168.251.54:19000 - 29611 requests: 
	- Avg: 11ms Fastest: 2ms Slowest: 1.774s 50%: 9ms 90%: 14ms
 * http://192.168.251.55:19000 - 30618 requests: 
	- Avg: 10ms Fastest: 2ms Slowest: 2.75s 50%: 8ms 90%: 13ms

Cluster Total: 66.03 MiB/s, 1126.86 obj/s over 4m58s.
 * http://192.168.251.54:19000: 19.51 MiB/s, 332.11 obj/s
 * http://192.168.251.53:19000: 26.47 MiB/s, 452.61 obj/s
 * http://192.168.251.55:19000: 20.05 MiB/s, 342.17 obj/s
```

![image-20220822144328279](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822144328279.png)

![image-20220822144338621](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822144338621.png)

![image-20220822144348842](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822144348842.png)

![image-20220822144358675](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822144358675.png)

![image-20220822144412818](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822144412818.png)

#### 10kib

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=2500000 --obj.size=10Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --autoterm --analyze.v
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[145959]-M1gb.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 43878, 10.0%, Concurrency: 20, Ran 4m57s, starting 2022-08-22 15:00:04.541 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 52.67 obj/s.
 * http://192.168.251.54:19000: Avg: 47.39 obj/s.
 * http://192.168.251.55:19000: Avg: 47.30 obj/s.

Requests considered: 43879:
 * Avg: 25ms, 50%: 10ms, 90%: 39ms, 99%: 259ms, Fastest: 3ms, Slowest: 6.009s

Requests by host:
 * http://192.168.251.53:19000 - 15694 requests: 
	- Avg: 24ms Fastest: 3ms Slowest: 4.68s 50%: 10ms 90%: 39ms
 * http://192.168.251.54:19000 - 14119 requests: 
	- Avg: 25ms Fastest: 5ms Slowest: 4.36s 50%: 11ms 90%: 38ms
 * http://192.168.251.55:19000 - 14070 requests: 
	- Avg: 25ms Fastest: 4ms Slowest: 6.009s 50%: 10ms 90%: 40ms

Operation: GET - total: 197468, 45.0%, Concurrency: 20, Ran 4m57s, starting 2022-08-22 15:00:04.537 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 2.35 MiB/s, 240.47 obj/s.
 * http://192.168.251.54:19000: Avg: 2.07 MiB/s, 211.74 obj/s.
 * http://192.168.251.55:19000: Avg: 2.06 MiB/s, 210.53 obj/s.

Requests considered: 197469:
 * Avg: 20ms, 50%: 7ms, 90%: 36ms, 99%: 166ms, Fastest: 2ms, Slowest: 6.121s
 * TTFB: Avg: 20ms, Best: 2ms, 25th: 3ms, Median: 6ms, 75th: 20ms, 90th: 35ms, 99th: 165ms, Worst: 6.12s
 * First Access: Avg: 20ms, 50%: 7ms, 90%: 35ms, 99%: 158ms, Fastest: 2ms, Slowest: 6.121s
 * First Access TTFB: Avg: 19ms, Best: 2ms, 25th: 3ms, Median: 6ms, 75th: 20ms, 90th: 34ms, 99th: 157ms, Worst: 6.12s
 * Last Access: Avg: 20ms, 50%: 7ms, 90%: 36ms, 99%: 161ms, Fastest: 2ms, Slowest: 6.011s
 * Last Access TTFB: Avg: 20ms, Best: 2ms, 25th: 3ms, Median: 6ms, 75th: 20ms, 90th: 35ms, 99th: 160ms, Worst: 6.01s

Requests by host:
 * http://192.168.251.53:19000 - 71650 requests: 
	- Avg: 19ms Fastest: 2ms Slowest: 6.011s 50%: 6ms 90%: 35ms
	- First Byte: Avg: 19ms, Best: 2ms, 25th: 2ms, Median: 6ms, 75th: 20ms, 90th: 35ms, 99th: 144ms, Worst: 6.01s
 * http://192.168.251.54:19000 - 63091 requests: 
	- Avg: 21ms Fastest: 3ms Slowest: 5.664s 50%: 7ms 90%: 36ms
	- First Byte: Avg: 20ms, Best: 2ms, 25th: 3ms, Median: 6ms, 75th: 20ms, 90th: 35ms, 99th: 182ms, Worst: 5.663s
 * http://192.168.251.55:19000 - 62732 requests: 
	- Avg: 21ms Fastest: 3ms Slowest: 6.121s 50%: 7ms 90%: 37ms
	- First Byte: Avg: 20ms, Best: 2ms, 25th: 3ms, Median: 6ms, 75th: 21ms, 90th: 36ms, 99th: 179ms, Worst: 6.12s

Operation: PUT - total: 65820, 15.0%, Concurrency: 20, Ran 4m57s, starting 2022-08-22 15:00:04.538 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 0.78 MiB/s, 80.18 obj/s.
 * http://192.168.251.54:19000: Avg: 0.69 MiB/s, 70.75 obj/s.
 * http://192.168.251.55:19000: Avg: 0.68 MiB/s, 70.04 obj/s.

Requests considered: 65821:
 * Avg: 6ms, 50%: 4ms, 90%: 6ms, 99%: 28ms, Fastest: 2ms, Slowest: 6.312s

Requests by host:
 * http://192.168.251.53:19000 - 23879 requests: 
	- Avg: 5ms Fastest: 2ms Slowest: 2.306s 50%: 3ms 90%: 5ms
 * http://192.168.251.54:19000 - 21077 requests: 
	- Avg: 7ms Fastest: 3ms Slowest: 6.289s 50%: 5ms 90%: 6ms
 * http://192.168.251.55:19000 - 20869 requests: 
	- Avg: 7ms Fastest: 3ms Slowest: 6.312s 50%: 5ms 90%: 6ms

Operation: STAT - total: 131644, 30.0%, Concurrency: 20, Ran 4m57s, starting 2022-08-22 15:00:04.537 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 159.04 obj/s.
 * http://192.168.251.54:19000: Avg: 142.57 obj/s.
 * http://192.168.251.55:19000: Avg: 140.21 obj/s.

Requests considered: 131645:
 * Avg: 3ms, 50%: 2ms, 90%: 3ms, 99%: 28ms, Fastest: 1ms, Slowest: 6.105s
 * First Access: Avg: 3ms, 50%: 2ms, 90%: 3ms, 99%: 28ms, Fastest: 1ms, Slowest: 6.105s
 * Last Access: Avg: 3ms, 50%: 2ms, 90%: 3ms, 99%: 28ms, Fastest: 1ms, Slowest: 6.105s

Requests by host:
 * http://192.168.251.53:19000 - 47390 requests: 
	- Avg: 3ms Fastest: 1ms Slowest: 6.105s 50%: 2ms 90%: 2ms
 * http://192.168.251.54:19000 - 42480 requests: 
	- Avg: 4ms Fastest: 2ms Slowest: 3.142s 50%: 3ms 90%: 3ms
 * http://192.168.251.55:19000 - 41778 requests: 
	- Avg: 4ms Fastest: 2ms Slowest: 1.298s 50%: 3ms 90%: 3ms

Cluster Total: 8.63 MiB/s, 1472.73 obj/s over 4m58s.
 * http://192.168.251.53:19000: 3.13 MiB/s, 532.31 obj/s
 * http://192.168.251.55:19000: 2.74 MiB/s, 468.00 obj/s
 * http://192.168.251.54:19000: 2.76 MiB/s, 472.43 obj/s
```

![image-20220822150720388](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822150720388.png)

![image-20220822150730869](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822150730869.png)

![image-20220822150745885](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822150745885.png)

![image-20220822150757359](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822150757359.png)

![image-20220822150808498](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822150808498.png)

### minio 不同并发测试

#### 100Kib 200并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 200 --autoterm --analyze.v --noclear 
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[162418]-bRIS.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 17873, 10.0%, Concurrency: 200, Ran 1m31s, starting 2022-08-22 16:24:21.916 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 79.34 obj/s.
 * http://192.168.251.54:19000: Avg: 57.83 obj/s.
 * http://192.168.251.55:19000: Avg: 59.12 obj/s.

Requests considered: 17874:
 * Avg: 197ms, 50%: 173ms, 90%: 242ms, 99%: 1.049s, Fastest: 5ms, Slowest: 3.768s

Requests by host:
 * http://192.168.251.53:19000 - 7239 requests: 
	- Avg: 180ms Fastest: 5ms Slowest: 3.137s 50%: 172ms 90%: 219ms
 * http://192.168.251.54:19000 - 5270 requests: 
	- Avg: 210ms Fastest: 7ms Slowest: 3.711s 50%: 174ms 90%: 247ms
 * http://192.168.251.55:19000 - 5389 requests: 
	- Avg: 205ms Fastest: 6ms Slowest: 3.768s 50%: 175ms 90%: 246ms

Operation: GET - total: 80573, 45.0%, Concurrency: 200, Ran 1m31s, starting 2022-08-22 16:24:21.916 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 34.15 MiB/s, 349.68 obj/s.
 * http://192.168.251.54:19000: Avg: 26.07 MiB/s, 266.98 obj/s.
 * http://192.168.251.55:19000: Avg: 26.08 MiB/s, 267.10 obj/s.

Requests considered: 80574:
 * Avg: 113ms, 50%: 77ms, 90%: 149ms, 99%: 950ms, Fastest: 3ms, Slowest: 3.409s
 * TTFB: Avg: 101ms, Best: 2ms, 25th: 44ms, Median: 63ms, 75th: 95ms, 90th: 141ms, 99th: 937ms, Worst: 3.397s
 * First Access: Avg: 111ms, 50%: 78ms, 90%: 148ms, 99%: 930ms, Fastest: 3ms, Slowest: 3.121s
 * First Access TTFB: Avg: 99ms, Best: 2ms, 25th: 44ms, Median: 63ms, 75th: 94ms, 90th: 139ms, 99th: 917ms, Worst: 3.116s
 * Last Access: Avg: 112ms, 50%: 77ms, 90%: 148ms, 99%: 933ms, Fastest: 3ms, Slowest: 3.409s
 * Last Access TTFB: Avg: 99ms, Best: 2ms, 25th: 44ms, Median: 63ms, 75th: 95ms, 90th: 139ms, 99th: 923ms, Worst: 3.395s

Requests by host:
 * http://192.168.251.53:19000 - 31900 requests: 
	- Avg: 103ms Fastest: 3ms Slowest: 3.163s 50%: 74ms 90%: 130ms
	- First Byte: Avg: 83ms, Best: 2ms, 25th: 27ms, Median: 53ms, 75th: 70ms, 90th: 109ms, 99th: 897ms, Worst: 3.159s
 * http://192.168.251.54:19000 - 24351 requests: 
	- Avg: 120ms Fastest: 4ms Slowest: 3.409s 50%: 82ms 90%: 154ms
	- First Byte: Avg: 113ms, Best: 3ms, 25th: 53ms, Median: 74ms, 75th: 108ms, 90th: 146ms, 99th: 965ms, Worst: 3.395s
 * http://192.168.251.55:19000 - 24368 requests: 
	- Avg: 121ms Fastest: 4ms Slowest: 3.402s 50%: 80ms 90%: 155ms
	- First Byte: Avg: 114ms, Best: 3ms, 25th: 51ms, Median: 72ms, 75th: 109ms, 90th: 148ms, 99th: 978ms, Worst: 3.397s

Operation: PUT - total: 26853, 15.0%, Concurrency: 200, Ran 1m31s, starting 2022-08-22 16:24:21.916 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 11.64 MiB/s, 119.17 obj/s.
 * http://192.168.251.54:19000: Avg: 8.48 MiB/s, 86.86 obj/s.
 * http://192.168.251.55:19000: Avg: 8.65 MiB/s, 88.53 obj/s.

Requests considered: 26854:
 * Avg: 100ms, 50%: 100ms, 90%: 146ms, 99%: 203ms, Fastest: 4ms, Slowest: 2.426s

Requests by host:
 * http://192.168.251.53:19000 - 10871 requests: 
	- Avg: 83ms Fastest: 4ms Slowest: 2.417s 50%: 83ms 90%: 136ms
 * http://192.168.251.54:19000 - 7925 requests: 
	- Avg: 112ms Fastest: 6ms Slowest: 2.426s 50%: 106ms 90%: 152ms
 * http://192.168.251.55:19000 - 8071 requests: 
	- Avg: 111ms Fastest: 5ms Slowest: 2.42s 50%: 107ms 90%: 150ms

Operation: STAT - total: 53751, 30.0%, Concurrency: 200, Ran 1m31s, starting 2022-08-22 16:24:21.917 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 232.75 obj/s.
 * http://192.168.251.54:19000: Avg: 177.10 obj/s.
 * http://192.168.251.55:19000: Avg: 179.54 obj/s.

Requests considered: 53752:
 * Avg: 54ms, 50%: 48ms, 90%: 85ms, 99%: 146ms, Fastest: 1ms, Slowest: 2.784s
 * First Access: Avg: 54ms, 50%: 47ms, 90%: 85ms, 99%: 155ms, Fastest: 1ms, Slowest: 2.784s
 * Last Access: Avg: 54ms, 50%: 48ms, 90%: 86ms, 99%: 139ms, Fastest: 1ms, Slowest: 2.784s

Requests by host:
 * http://192.168.251.53:19000 - 21235 requests: 
	- Avg: 28ms Fastest: 1ms Slowest: 2.69s 50%: 24ms 90%: 31ms
 * http://192.168.251.54:19000 - 16155 requests: 
	- Avg: 72ms Fastest: 2ms Slowest: 2.784s 50%: 69ms 90%: 90ms
 * http://192.168.251.55:19000 - 16377 requests: 
	- Avg: 70ms Fastest: 2ms Slowest: 2.736s 50%: 67ms 90%: 89ms

Cluster Total: 115.05 MiB/s, 1963.62 obj/s over 1m31s.
 * http://192.168.251.54:19000: 34.55 MiB/s, 588.71 obj/s
 * http://192.168.251.55:19000: 34.73 MiB/s, 594.22 obj/s
 * http://192.168.251.53:19000: 45.78 MiB/s, 780.88 obj/s
warp: Cleanup Done.
```

![image-20220822163307064](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822163307064.png)

![image-20220822163321056](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822163321056-16611572015611.png)

![image-20220822163331573](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822163331573.png)

![image-20220822163343383](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822163343383.png)

![image-20220822163355689](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822163355689.png)

#### 100Kib 500并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 500 --autoterm --analyze.v --noclear 
```

```
warp: opening server on 192.168.251.158:8888                                                                                                                                                 
Throughput 756.3 objects/s within 7.500000% for 11.445s. Assuming stability. Terminating benchmark.
warp: Benchmark data written to "warp-mixed-2022-08-22[165736]-ZlqW.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 9585, 9.9%, Concurrency: 500, Ran 41s, starting 2022-08-22 16:57:40.635 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 78.79 obj/s.
 * http://192.168.251.54:19000: Avg: 77.15 obj/s.
 * http://192.168.251.55:19000: Avg: 78.45 obj/s.

Requests considered: 9586:
 * Avg: 326ms, 50%: 312ms, 90%: 416ms, 99%: 1.414s, Fastest: 6ms, Slowest: 2.893s

Requests by host:
 * http://192.168.251.53:19000 - 3245 requests: 
	- Avg: 292ms Fastest: 6ms Slowest: 2.822s 50%: 294ms 90%: 372ms
 * http://192.168.251.54:19000 - 3170 requests: 
	- Avg: 346ms Fastest: 8ms Slowest: 2.893s 50%: 338ms 90%: 421ms
 * http://192.168.251.55:19000 - 3231 requests: 
	- Avg: 342ms Fastest: 8ms Slowest: 2.78s 50%: 335ms 90%: 428ms

Operation: GET - total: 43334, 44.8%, Concurrency: 500, Ran 41s, starting 2022-08-22 16:57:40.634 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 33.77 MiB/s, 345.78 obj/s.
 * http://192.168.251.54:19000: Avg: 34.31 MiB/s, 351.30 obj/s.
 * http://192.168.251.55:19000: Avg: 34.95 MiB/s, 357.89 obj/s.

Requests considered: 43335:
 * Avg: 262ms, 50%: 239ms, 90%: 368ms, 99%: 1.32s, Fastest: 4ms, Slowest: 2.946s
 * TTFB: Avg: 167ms, Best: 2ms, 25th: 79ms, Median: 142ms, 75th: 190ms, 90th: 217ms, 99th: 1.279s, Worst: 2.907s
 * First Access: Avg: 258ms, 50%: 240ms, 90%: 367ms, 99%: 1.071s, Fastest: 4ms, Slowest: 2.648s
 * First Access TTFB: Avg: 162ms, Best: 2ms, 25th: 79ms, Median: 141ms, 75th: 189ms, 90th: 216ms, 99th: 1.036s, Worst: 2.615s
 * Last Access: Avg: 262ms, 50%: 239ms, 90%: 369ms, 99%: 1.309s, Fastest: 4ms, Slowest: 2.946s
 * Last Access TTFB: Avg: 168ms, Best: 2ms, 25th: 79ms, Median: 142ms, 75th: 190ms, 90th: 218ms, 99th: 1.273s, Worst: 2.906s

Requests by host:
 * http://192.168.251.53:19000 - 14251 requests: 
	- Avg: 323ms Fastest: 4ms Slowest: 2.946s 50%: 317ms 90%: 389ms
	- First Byte: Avg: 140ms, Best: 2ms, 25th: 40ms, Median: 119ms, 75th: 146ms, 90th: 174ms, 99th: 1.315s, Worst: 2.894s
 * http://192.168.251.54:19000 - 14486 requests: 
	- Avg: 232ms Fastest: 4ms Slowest: 2.917s 50%: 214ms 90%: 306ms
	- First Byte: Avg: 179ms, Best: 3ms, 25th: 85ms, Median: 164ms, 75th: 198ms, 90th: 221ms, 99th: 1.208s, Worst: 2.906s
 * http://192.168.251.55:19000 - 14755 requests: 
	- Avg: 232ms Fastest: 6ms Slowest: 2.927s 50%: 213ms 90%: 309ms
	- First Byte: Avg: 183ms, Best: 5ms, 25th: 84ms, Median: 168ms, 75th: 200ms, 90th: 222ms, 99th: 1.273s, Worst: 2.907s

Operation: PUT - total: 14472, 15.0%, Concurrency: 500, Ran 41s, starting 2022-08-22 16:57:40.633 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 11.26 MiB/s, 115.27 obj/s.
 * http://192.168.251.54:19000: Avg: 11.82 MiB/s, 121.04 obj/s.
 * http://192.168.251.55:19000: Avg: 11.30 MiB/s, 115.69 obj/s.

Requests considered: 14473:
 * Avg: 221ms, 50%: 214ms, 90%: 312ms, 99%: 836ms, Fastest: 5ms, Slowest: 1.963s

Requests by host:
 * http://192.168.251.53:19000 - 4759 requests: 
	- Avg: 183ms Fastest: 5ms Slowest: 1.943s 50%: 200ms 90%: 255ms
 * http://192.168.251.54:19000 - 4983 requests: 
	- Avg: 242ms Fastest: 6ms Slowest: 1.959s 50%: 236ms 90%: 324ms
 * http://192.168.251.55:19000 - 4765 requests: 
	- Avg: 238ms Fastest: 8ms Slowest: 1.963s 50%: 235ms 90%: 322ms

Operation: STAT - total: 29068, 30.1%, Concurrency: 500, Ran 41s, starting 2022-08-22 16:57:40.635 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 234.85 obj/s.
 * http://192.168.251.54:19000: Avg: 234.43 obj/s.
 * http://192.168.251.55:19000: Avg: 235.77 obj/s.

Requests considered: 29069:
 * Avg: 94ms, 50%: 103ms, 90%: 132ms, 99%: 340ms, Fastest: 1ms, Slowest: 2.231s
 * First Access: Avg: 95ms, 50%: 103ms, 90%: 132ms, 99%: 340ms, Fastest: 1ms, Slowest: 2.231s
 * Last Access: Avg: 94ms, 50%: 103ms, 90%: 132ms, 99%: 339ms, Fastest: 1ms, Slowest: 2.231s

Requests by host:
 * http://192.168.251.53:19000 - 9702 requests: 
	- Avg: 43ms Fastest: 1ms Slowest: 2.208s 50%: 38ms 90%: 43ms
 * http://192.168.251.54:19000 - 9671 requests: 
	- Avg: 120ms Fastest: 3ms Slowest: 2.212s 50%: 117ms 90%: 137ms
 * http://192.168.251.55:19000 - 9730 requests: 
	- Avg: 120ms Fastest: 2ms Slowest: 2.231s 50%: 115ms 90%: 134ms

Cluster Total: 137.16 MiB/s, 2342.72 obj/s over 41s.
 * http://192.168.251.55:19000: 46.23 MiB/s, 787.50 obj/s
 * http://192.168.251.54:19000: 46.10 MiB/s, 783.28 obj/s
 * http://192.168.251.53:19000: 44.96 MiB/s, 773.77 obj/s
warp: Cleanup Done.                                                
```

![image-20220822170305940](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822170305940-16611589866083.png)

![image-20220822170318372](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822170318372.png)

![image-20220822170329605](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822170329605.png)

![image-20220822170342290](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822170342290.png)

![image-20220822170413689](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822170413689.png)

#### 100Kib 1000并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 1000 --analyze.v --noclear
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[171445]-hJRO.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 59132, 10.0%, Concurrency: 1000, Ran 4m51s, starting 2022-08-22 17:14:50.822 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 69.67 obj/s.
 * http://192.168.251.54:19000: Avg: 67.39 obj/s.
 * http://192.168.251.55:19000: Avg: 66.58 obj/s.

Requests considered: 59133:
 * Avg: 729ms, 50%: 556ms, 90%: 1.227s, 99%: 4.144s, Fastest: 7ms, Slowest: 8.156s

Requests by host:
 * http://192.168.251.53:19000 - 20197 requests: 
	- Avg: 719ms Fastest: 7ms Slowest: 8.083s 50%: 549ms 90%: 1.224s
 * http://192.168.251.54:19000 - 19545 requests: 
	- Avg: 740ms Fastest: 7ms Slowest: 8.156s 50%: 563ms 90%: 1.245s
 * http://192.168.251.55:19000 - 19400 requests: 
	- Avg: 728ms Fastest: 7ms Slowest: 7.958s 50%: 561ms 90%: 1.21s

Operation: GET - total: 266264, 45.0%, Concurrency: 1000, Ran 4m51s, starting 2022-08-22 17:14:50.822 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 30.60 MiB/s, 313.37 obj/s.
 * http://192.168.251.54:19000: Avg: 29.38 MiB/s, 300.85 obj/s.
 * http://192.168.251.55:19000: Avg: 29.28 MiB/s, 299.82 obj/s.

Requests considered: 266265:
 * Avg: 585ms, 50%: 398ms, 90%: 1.057s, 99%: 3.987s, Fastest: 4ms, Slowest: 7.931s
 * TTFB: Avg: 462ms, Best: 2ms, 25th: 104ms, Median: 252ms, 75th: 509ms, 90th: 929ms, 99th: 3.9s, Worst: 7.928s
 * First Access: Avg: 557ms, 50%: 396ms, 90%: 1.016s, 99%: 3.282s, Fastest: 4ms, Slowest: 7.72s
 * First Access TTFB: Avg: 435ms, Best: 3ms, 25th: 104ms, Median: 251ms, 75th: 496ms, 90th: 889ms, 99th: 3.232s, Worst: 7.493s
 * Last Access: Avg: 586ms, 50%: 399ms, 90%: 1.06s, 99%: 3.968s, Fastest: 4ms, Slowest: 7.93s
 * Last Access TTFB: Avg: 463ms, Best: 2ms, 25th: 104ms, Median: 252ms, 75th: 510ms, 90th: 933ms, 99th: 3.885s, Worst: 7.928s

Requests by host:
 * http://192.168.251.53:19000 - 91269 requests: 
	- Avg: 599ms Fastest: 4ms Slowest: 7.931s 50%: 422ms 90%: 1.005s
	- First Byte: Avg: 396ms, Best: 2ms, 25th: 47ms, Median: 195ms, 75th: 402ms, 90th: 782ms, 99th: 3.832s, Worst: 7.928s
 * http://192.168.251.54:19000 - 87656 requests: 
	- Avg: 574ms Fastest: 5ms Slowest: 7.896s 50%: 372ms 90%: 1.078s
	- First Byte: Avg: 498ms, Best: 4ms, 25th: 115ms, Median: 291ms, 75th: 573ms, 90th: 1.001s, 99th: 3.959s, Worst: 7.835s
 * http://192.168.251.55:19000 - 87370 requests: 
	- Avg: 582ms Fastest: 5ms Slowest: 7.879s 50%: 381ms 90%: 1.083s
	- First Byte: Avg: 496ms, Best: 4ms, 25th: 120ms, Median: 288ms, 75th: 561ms, 90th: 978ms, 99th: 3.915s, Worst: 7.872s

Operation: PUT - total: 88764, 15.0%, Concurrency: 1000, Ran 4m51s, starting 2022-08-22 17:14:50.826 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 10.27 MiB/s, 105.21 obj/s.
 * http://192.168.251.54:19000: Avg: 9.78 MiB/s, 100.12 obj/s.
 * http://192.168.251.55:19000: Avg: 9.72 MiB/s, 99.52 obj/s.

Requests considered: 88765:
 * Avg: 571ms, 50%: 419ms, 90%: 1.054s, 99%: 3.21s, Fastest: 5ms, Slowest: 7.562s

Requests by host:
 * http://192.168.251.53:19000 - 30639 requests: 
	- Avg: 599ms Fastest: 5ms Slowest: 6.936s 50%: 446ms 90%: 1.155s
 * http://192.168.251.54:19000 - 29150 requests: 
	- Avg: 552ms Fastest: 7ms Slowest: 5.465s 50%: 406ms 90%: 974ms
 * http://192.168.251.55:19000 - 28987 requests: 
	- Avg: 559ms Fastest: 7ms Slowest: 7.562s 50%: 415ms 90%: 991ms

Operation: STAT - total: 177743, 30.0%, Concurrency: 1000, Ran 4m51s, starting 2022-08-22 17:14:50.824 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 209.30 obj/s.
 * http://192.168.251.54:19000: Avg: 201.87 obj/s.
 * http://192.168.251.55:19000: Avg: 198.91 obj/s.

Requests considered: 177744:
 * Avg: 223ms, 50%: 115ms, 90%: 467ms, 99%: 2.368s, Fastest: 2ms, Slowest: 5.266s
 * First Access: Avg: 223ms, 50%: 115ms, 90%: 468ms, 99%: 2.386s, Fastest: 2ms, Slowest: 5.266s
 * Last Access: Avg: 222ms, 50%: 115ms, 90%: 463ms, 99%: 2.324s, Fastest: 2ms, Slowest: 5.246s

Requests by host:
 * http://192.168.251.53:19000 - 60983 requests: 
	- Avg: 145ms Fastest: 2ms Slowest: 5.229s 50%: 40ms 90%: 269ms
 * http://192.168.251.54:19000 - 58815 requests: 
	- Avg: 264ms Fastest: 2ms Slowest: 5.266s 50%: 137ms 90%: 538ms
 * http://192.168.251.55:19000 - 57962 requests: 
	- Avg: 262ms Fastest: 2ms Slowest: 5.257s 50%: 135ms 90%: 537ms

Cluster Total: 118.99 MiB/s, 2031.44 obj/s over 4m51s.
 * http://192.168.251.53:19000: 40.86 MiB/s, 697.03 obj/s
 * http://192.168.251.55:19000: 38.99 MiB/s, 664.77 obj/s
 * http://192.168.251.54:19000: 39.15 MiB/s, 669.82 obj/s
warp: Cleanup Done.
```

![image-20220822172811793](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822172811793.png)

![image-20220822172824623](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822172824623.png)

![image-20220822172834274](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822172834274.png)

![image-20220822172843707](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822172843707-16611605241677.png)

![image-20220822172856197](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822172856197.png)

#### 100Kib 1500并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 1500 --analyze.v --noclear
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[173326]-WQIb.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 58211, 10.0%, Concurrency: 1500, Ran 4m52s, starting 2022-08-22 17:33:33.064 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 67.77 obj/s.
 * http://192.168.251.54:19000: Avg: 65.89 obj/s.
 * http://192.168.251.55:19000: Avg: 65.70 obj/s.

Requests considered: 58212:
 * Avg: 1.09s, 50%: 833ms, 90%: 1.982s, 99%: 5.458s, Fastest: 7ms, Slowest: 10.027s

Requests by host:
 * http://192.168.251.53:19000 - 19833 requests: 
	- Avg: 1.1s Fastest: 11ms Slowest: 9.993s 50%: 823ms 90%: 2.005s
 * http://192.168.251.54:19000 - 19281 requests: 
	- Avg: 1.091s Fastest: 7ms Slowest: 10.027s 50%: 841ms 90%: 1.972s
 * http://192.168.251.55:19000 - 19216 requests: 
	- Avg: 1.079s Fastest: 7ms Slowest: 9.682s 50%: 839ms 90%: 1.968s

Operation: GET - total: 262347, 44.9%, Concurrency: 1500, Ran 4m52s, starting 2022-08-22 17:33:33.054 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 29.79 MiB/s, 305.02 obj/s.
 * http://192.168.251.54:19000: Avg: 28.87 MiB/s, 295.67 obj/s.
 * http://192.168.251.55:19000: Avg: 29.00 MiB/s, 296.92 obj/s.

Requests considered: 262348:
 * Avg: 899ms, 50%: 610ms, 90%: 1.79s, 99%: 5.009s, Fastest: 4ms, Slowest: 27.886s
 * TTFB: Avg: 734ms, Best: 2ms, 25th: 188ms, Median: 423ms, 75th: 884ms, 90th: 1.606s, 99th: 4.904s, Worst: 27.653s
 * First Access: Avg: 834ms, 50%: 600ms, 90%: 1.627s, 99%: 4.222s, Fastest: 5ms, Slowest: 27.886s
 * First Access TTFB: Avg: 663ms, Best: 3ms, 25th: 187ms, Median: 411ms, 75th: 832ms, 90th: 1.429s, 99th: 4.124s, Worst: 27.653s
 * Last Access: Avg: 932ms, 50%: 617ms, 90%: 1.945s, 99%: 5.198s, Fastest: 4ms, Slowest: 12.638s
 * Last Access TTFB: Avg: 774ms, Best: 2ms, 25th: 188ms, Median: 435ms, 75th: 923ms, 90th: 1.77s, 99th: 5.12s, Worst: 12.636s

Requests by host:
 * http://192.168.251.53:19000 - 89270 requests: 
	- Avg: 905ms Fastest: 4ms Slowest: 27.886s 50%: 623ms 90%: 1.785s
	- First Byte: Avg: 667ms, Best: 2ms, 25th: 166ms, Median: 369ms, 75th: 750ms, 90th: 1.503s, 99th: 4.858s, Worst: 27.653s
 * http://192.168.251.54:19000 - 86526 requests: 
	- Avg: 894ms Fastest: 5ms Slowest: 10.085s 50%: 608ms 90%: 1.768s
	- First Byte: Avg: 766ms, Best: 4ms, 25th: 204ms, Median: 461ms, 75th: 938ms, 90th: 1.621s, 99th: 4.766s, Worst: 10.073s
 * http://192.168.251.55:19000 - 86870 requests: 
	- Avg: 899ms Fastest: 5ms Slowest: 9.213s 50%: 598ms 90%: 1.819s
	- First Byte: Avg: 770ms, Best: 4ms, 25th: 198ms, Median: 446ms, 75th: 945ms, 90th: 1.671s, 99th: 5.083s, Worst: 9.211s

Operation: PUT - total: 87553, 15.0%, Concurrency: 1500, Ran 4m52s, starting 2022-08-22 17:33:33.057 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 9.98 MiB/s, 102.25 obj/s.
 * http://192.168.251.54:19000: Avg: 9.57 MiB/s, 98.02 obj/s.
 * http://192.168.251.55:19000: Avg: 9.67 MiB/s, 99.07 obj/s.

Requests considered: 87554:
 * Avg: 861ms, 50%: 647ms, 90%: 1.68s, 99%: 4.498s, Fastest: 6ms, Slowest: 11.295s

Requests by host:
 * http://192.168.251.53:19000 - 29933 requests: 
	- Avg: 912ms Fastest: 6ms Slowest: 7.834s 50%: 740ms 90%: 1.784s
 * http://192.168.251.54:19000 - 28688 requests: 
	- Avg: 835ms Fastest: 8ms Slowest: 11.295s 50%: 621ms 90%: 1.577s
 * http://192.168.251.55:19000 - 28971 requests: 
	- Avg: 833ms Fastest: 7ms Slowest: 9.041s 50%: 621ms 90%: 1.607s

Operation: STAT - total: 175453, 30.0%, Concurrency: 1500, Ran 4m52s, starting 2022-08-22 17:33:33.055 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 204.61 obj/s.
 * http://192.168.251.54:19000: Avg: 197.70 obj/s.
 * http://192.168.251.55:19000: Avg: 197.09 obj/s.

Requests considered: 175454:
 * Avg: 350ms, 50%: 193ms, 90%: 691ms, 99%: 3.177s, Fastest: 2ms, Slowest: 6.376s
 * First Access: Avg: 346ms, 50%: 211ms, 90%: 676ms, 99%: 3.098s, Fastest: 2ms, Slowest: 6.376s
 * Last Access: Avg: 359ms, 50%: 190ms, 90%: 728ms, 99%: 3.317s, Fastest: 2ms, Slowest: 6.376s

Requests by host:
 * http://192.168.251.53:19000 - 59919 requests: 
	- Avg: 260ms Fastest: 2ms Slowest: 6.108s 50%: 47ms 90%: 494ms
 * http://192.168.251.54:19000 - 57875 requests: 
	- Avg: 399ms Fastest: 2ms Slowest: 6.128s 50%: 304ms 90%: 774ms
 * http://192.168.251.55:19000 - 57700 requests: 
	- Avg: 393ms Fastest: 2ms Slowest: 6.376s 50%: 300ms 90%: 764ms

Cluster Total: 116.81 MiB/s, 1994.65 obj/s over 4m53s.
 * http://192.168.251.55:19000: 38.65 MiB/s, 658.49 obj/s
 * http://192.168.251.53:19000: 39.76 MiB/s, 679.43 obj/s
 * http://192.168.251.54:19000: 38.44 MiB/s, 657.15 obj/s
warp: Cleanup Done.
```

![image-20220822174319354](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822174319354.png)

![image-20220822174329191](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822174329191.png)

![image-20220822174340165](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822174340165.png)

![image-20220822174349535](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822174349535.png)

![image-20220822174400097](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822174400097.png)

#### 100Kib 2000并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 2000 --analyze.v --noclear
```

```
warp: Benchmark data written to "warp-mixed-2022-08-22[175607]-LUZb.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 57403, 10.0%, Concurrency: 2000, Ran 4m51s, starting 2022-08-22 17:56:14.361 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 67.11 obj/s.
 * http://192.168.251.54:19000: Avg: 64.03 obj/s.
 * http://192.168.251.55:19000: Avg: 67.43 obj/s.

Requests considered: 57404:
 * Avg: 1.429s, 50%: 1.11s, 90%: 2.678s, 99%: 7.155s, Fastest: 8ms, Slowest: 14.322s

Requests by host:
 * http://192.168.251.53:19000 - 19368 requests: 
	- Avg: 1.46s Fastest: 84ms Slowest: 14.669s 50%: 1.082s 90%: 2.797s
 * http://192.168.251.54:19000 - 18474 requests: 
	- Avg: 1.476s Fastest: 8ms Slowest: 14.88s 50%: 1.15s 90%: 2.736s
 * http://192.168.251.55:19000 - 19607 requests: 
	- Avg: 1.367s Fastest: 8ms Slowest: 11.413s 50%: 1.08s 90%: 2.552s

Operation: GET - total: 258722, 45.0%, Concurrency: 2000, Ran 4m51s, starting 2022-08-22 17:56:14.361 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 28.94 MiB/s, 296.39 obj/s.
 * http://192.168.251.54:19000: Avg: 28.08 MiB/s, 287.51 obj/s.
 * http://192.168.251.55:19000: Avg: 30.01 MiB/s, 307.34 obj/s.

Requests considered: 258723:
 * Avg: 1.194s, 50%: 837ms, 90%: 2.434s, 99%: 6.368s, Fastest: 5ms, Slowest: 27.017s
 * TTFB: Avg: 984ms, Best: 4ms, 25th: 284ms, Median: 606ms, 75th: 1.217s, 90th: 2.205s, 99th: 6.289s, Worst: 26.806s
 * First Access: Avg: 1.13s, 50%: 829ms, 90%: 2.275s, 99%: 5.313s, Fastest: 5ms, Slowest: 24.313s
 * First Access TTFB: Avg: 915ms, Best: 4ms, 25th: 283ms, Median: 594ms, 75th: 1.175s, 90th: 2.033s, 99th: 5.212s, Worst: 24.307s
 * Last Access: Avg: 1.228s, 50%: 852ms, 90%: 2.577s, 99%: 6.421s, Fastest: 5ms, Slowest: 27.017s
 * Last Access TTFB: Avg: 1.026s, Best: 4ms, 25th: 290ms, Median: 628ms, 75th: 1.266s, 90th: 2.382s, 99th: 6.355s, Worst: 26.806s

Requests by host:
 * http://192.168.251.53:19000 - 85904 requests: 
	- Avg: 1.232s Fastest: 18ms Slowest: 27.017s 50%: 881ms 90%: 2.514s
	- First Byte: Avg: 933ms, Best: 15ms, 25th: 262ms, Median: 556ms, 75th: 1.091s, 90th: 2.202s, 99th: 6.379s, Worst: 26.806s
 * http://192.168.251.54:19000 - 83333 requests: 
	- Avg: 1.2s Fastest: 6ms Slowest: 12.75s 50%: 858ms 90%: 2.391s
	- First Byte: Avg: 1.026s, Best: 5ms, 25th: 323ms, Median: 678ms, 75th: 1.294s, 90th: 2.216s, 99th: 6.297s, Worst: 12.655s
 * http://192.168.251.55:19000 - 89551 requests: 
	- Avg: 1.153s Fastest: 5ms Slowest: 11.082s 50%: 781ms 90%: 2.395s
	- First Byte: Avg: 995ms, Best: 4ms, 25th: 301ms, Median: 601ms, 75th: 1.248s, 90th: 2.2s, 99th: 6.243s, Worst: 11.014s

Operation: PUT - total: 86258, 15.0%, Concurrency: 2000, Ran 4m51s, starting 2022-08-22 17:56:14.358 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 9.77 MiB/s, 100.03 obj/s.
 * http://192.168.251.54:19000: Avg: 9.34 MiB/s, 95.64 obj/s.
 * http://192.168.251.55:19000: Avg: 9.91 MiB/s, 101.52 obj/s.

Requests considered: 86259:
 * Avg: 1.183s, 50%: 919ms, 90%: 2.318s, 99%: 6.297s, Fastest: 8ms, Slowest: 28.8s

Requests by host:
 * http://192.168.251.53:19000 - 28987 requests: 
	- Avg: 1.243s Fastest: 18ms Slowest: 13.624s 50%: 1.045s 90%: 2.423s
 * http://192.168.251.54:19000 - 27718 requests: 
	- Avg: 1.191s Fastest: 10ms Slowest: 28.8s 50%: 919ms 90%: 2.252s
 * http://192.168.251.55:19000 - 29572 requests: 
	- Avg: 1.118s Fastest: 8ms Slowest: 25.618s 50%: 842ms 90%: 2.244s

Operation: STAT - total: 172953, 30.1%, Concurrency: 2000, Ran 4m51s, starting 2022-08-22 17:56:14.357 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 198.40 obj/s.
 * http://192.168.251.54:19000: Avg: 192.96 obj/s.
 * http://192.168.251.55:19000: Avg: 204.30 obj/s.

Requests considered: 172954:
 * Avg: 467ms, 50%: 320ms, 90%: 933ms, 99%: 3.166s, Fastest: 2ms, Slowest: 7.953s
 * First Access: Avg: 465ms, 50%: 326ms, 90%: 914ms, 99%: 3.159s, Fastest: 2ms, Slowest: 7.938s
 * Last Access: Avg: 479ms, 50%: 321ms, 90%: 988ms, 99%: 3.221s, Fastest: 2ms, Slowest: 7.953s

Requests by host:
 * http://192.168.251.53:19000 - 57502 requests: 
	- Avg: 365ms Fastest: 14ms Slowest: 7.895s 50%: 245ms 90%: 817ms
 * http://192.168.251.54:19000 - 55930 requests: 
	- Avg: 554ms Fastest: 2ms Slowest: 7.953s 50%: 377ms 90%: 1.059s
 * http://192.168.251.55:19000 - 59531 requests: 
	- Avg: 485ms Fastest: 2ms Slowest: 6.991s 50%: 362ms 90%: 877ms

Cluster Total: 115.65 MiB/s, 1974.97 obj/s over 4m51s.
 * http://192.168.251.55:19000: 39.92 MiB/s, 680.41 obj/s
 * http://192.168.251.54:19000: 37.42 MiB/s, 639.81 obj/s
 * http://192.168.251.53:19000: 38.71 MiB/s, 661.58 obj/s
warp: Cleanup Done.
```

![image-20220822180343915](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822180343915.png)

![image-20220822180353307](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822180353307.png)

![image-20220822180405052](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822180405052.png)

![image-20220822180416094](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822180416094.png)

![image-20220822180427033](C:\Users\XYB\Desktop\k8s调研\assets\image-20220822180427033.png)

### minio更换部署方式

```
[root@ceph1 minio]# cat run.sh 
#!/bin/bash
export MINIO_ROOT_USER=admin 
export MINIO_ROOT_PASSWORD=edoc2@edoc2

#/opt/minio/minio server --config-dir /opt/minio/config/ --address ":19000" --console-address ":30000"\
#    http://192.168.251.53:19000/drive{1...3} \
#    http://192.168.251.54:19000/drive{1...3} \
#    http://192.168.251.55:19000/drive{1...3} 
/opt/minio/minio server --config-dir /opt/minio/config/ --address ":19000" --console-address ":30000"\
    http://node{1...3}:19000/drive1 \
    http://node{1...3}:19000/drive2 \
    http://node{1...3}:19000/drive3 
```

#### 上传下载测试

```
[root@centos158 storgetest]# mc cp 10g.dat minio/edoc2
/root/storgetest/10g.dat:          10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 90.09 MiB/s 1m53s
```

```
[root@centos158 storgetest]# mc cp minio/edoc2/10g.dat /tmp/
...68.251.54:19000/edoc2/10g.dat:  10.00 GiB / 10.00 GiB ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 109.76 MiB/s 1m33s
```

#### 100Kib 2000并发

```
./warp mixed --host=192.168.251.53:19000,192.168.251.54:19000,192.168.251.55:19000 --objects=250000 --obj.size=100Kib --access-key admin --secret-key edoc2@edoc2 --bucket edoc3 --concurrent 2000 --analyze.v --noclear
warp: Benchmark data written to "warp-mixed-2022-08-23[095551]-q1hS.csv.zst"                                                                                                                 
Mixed operations.
Operation: DELETE - total: 58019, 10.0%, Concurrency: 2000, Ran 4m48s, starting 2022-08-23 09:56:02.331 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 65.36 obj/s.
 * http://192.168.251.54:19000: Avg: 66.97 obj/s.
 * http://192.168.251.55:19000: Avg: 69.73 obj/s.

Requests considered: 58020:
 * Avg: 1.552s, 50%: 1.304s, 90%: 2.675s, 99%: 6.448s, Fastest: 11ms, Slowest: 12.976s

Requests by host:
 * http://192.168.251.53:19000 - 18810 requests: 
	- Avg: 1.597s Fastest: 182ms Slowest: 12.976s 50%: 1.311s 90%: 2.718s
 * http://192.168.251.54:19000 - 19282 requests: 
	- Avg: 1.568s Fastest: 18ms Slowest: 12.88s 50%: 1.309s 90%: 2.689s
 * http://192.168.251.55:19000 - 20084 requests: 
	- Avg: 1.493s Fastest: 11ms Slowest: 11.901s 50%: 1.288s 90%: 2.6s

Operation: GET - total: 261783, 44.9%, Concurrency: 2000, Ran 4m48s, starting 2022-08-23 09:56:02.325 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 28.68 MiB/s, 293.69 obj/s.
 * http://192.168.251.54:19000: Avg: 29.46 MiB/s, 301.68 obj/s.
 * http://192.168.251.55:19000: Avg: 30.75 MiB/s, 314.88 obj/s.

Requests considered: 261784:
 * Avg: 1.113s, 50%: 855ms, 90%: 1.877s, 99%: 5.775s, Fastest: 6ms, Slowest: 12.86s
 * TTFB: Avg: 949ms, Best: 4ms, 25th: 427ms, Median: 672ms, 75th: 1.039s, 90th: 1.738s, 99th: 5.67s, Worst: 12.853s
 * First Access: Avg: 1.033s, 50%: 840ms, 90%: 1.679s, 99%: 4.51s, Fastest: 6ms, Slowest: 12.86s
 * First Access TTFB: Avg: 865ms, Best: 4ms, 25th: 420ms, Median: 654ms, 75th: 979ms, 90th: 1.524s, 99th: 4.407s, Worst: 12.853s
 * Last Access: Avg: 1.139s, 50%: 859ms, 90%: 1.983s, 99%: 6.085s, Fastest: 6ms, Slowest: 12.86s
 * Last Access TTFB: Avg: 979ms, Best: 5ms, 25th: 425ms, Median: 677ms, 75th: 1.064s, 90th: 1.855s, 99th: 6.002s, Worst: 12.853s

Requests by host:
 * http://192.168.251.53:19000 - 84611 requests: 
	- Avg: 1.144s Fastest: 159ms Slowest: 12.482s 50%: 881ms 90%: 1.884s
	- First Byte: Avg: 987ms, Best: 128ms, 25th: 467ms, Median: 706ms, 75th: 1.083s, 90th: 1.775s, 99th: 5.831s, Worst: 12.47s
 * http://192.168.251.54:19000 - 86918 requests: 
	- Avg: 1.117s Fastest: 6ms Slowest: 12.86s 50%: 860ms 90%: 1.896s
	- First Byte: Avg: 952ms, Best: 4ms, 25th: 428ms, Median: 676ms, 75th: 1.047s, 90th: 1.762s, 99th: 5.742s, Worst: 12.853s
 * http://192.168.251.55:19000 - 90744 requests: 
	- Avg: 1.079s Fastest: 6ms Slowest: 12.106s 50%: 829ms 90%: 1.848s
	- First Byte: Avg: 909ms, Best: 5ms, 25th: 389ms, Median: 639ms, 75th: 984ms, 90th: 1.662s, 99th: 5.337s, Worst: 12.081s

Operation: PUT - total: 87195, 15.0%, Concurrency: 2000, Ran 4m48s, starting 2022-08-23 09:56:02.328 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 9.58 MiB/s, 98.07 obj/s.
 * http://192.168.251.54:19000: Avg: 9.80 MiB/s, 100.39 obj/s.
 * http://192.168.251.55:19000: Avg: 10.24 MiB/s, 104.91 obj/s.

Requests considered: 87196:
 * Avg: 1.168s, 50%: 959ms, 90%: 1.903s, 99%: 5.39s, Fastest: 7ms, Slowest: 13.318s

Requests by host:
 * http://192.168.251.53:19000 - 28240 requests: 
	- Avg: 1.191s Fastest: 105ms Slowest: 12.839s 50%: 958ms 90%: 1.941s
 * http://192.168.251.54:19000 - 28924 requests: 
	- Avg: 1.177s Fastest: 9ms Slowest: 13.318s 50%: 969ms 90%: 1.893s
 * http://192.168.251.55:19000 - 30218 requests: 
	- Avg: 1.137s Fastest: 7ms Slowest: 13.139s 50%: 951ms 90%: 1.876s

Operation: STAT - total: 175136, 30.1%, Concurrency: 2000, Ran 4m48s, starting 2022-08-23 09:56:02.326 +0800 CST

Throughput by host:
 * http://192.168.251.53:19000: Avg: 197.13 obj/s.
 * http://192.168.251.54:19000: Avg: 200.91 obj/s.
 * http://192.168.251.55:19000: Avg: 209.72 obj/s.

Requests considered: 175137:
 * Avg: 498ms, 50%: 354ms, 90%: 951ms, 99%: 3.084s, Fastest: 2ms, Slowest: 9.103s
 * First Access: Avg: 491ms, 50%: 355ms, 90%: 910ms, 99%: 3.023s, Fastest: 2ms, Slowest: 9.021s
 * Last Access: Avg: 506ms, 50%: 354ms, 90%: 990ms, 99%: 3.193s, Fastest: 2ms, Slowest: 9.103s

Requests by host:
 * http://192.168.251.53:19000 - 56840 requests: 
	- Avg: 526ms Fastest: 23ms Slowest: 9.061s 50%: 357ms 90%: 1.025s
 * http://192.168.251.54:19000 - 57924 requests: 
	- Avg: 500ms Fastest: 3ms Slowest: 9.103s 50%: 355ms 90%: 981ms
 * http://192.168.251.55:19000 - 60470 requests: 
	- Avg: 469ms Fastest: 2ms Slowest: 7.759s 50%: 351ms 90%: 854ms

Cluster Total: 118.43 MiB/s, 2022.16 obj/s over 4m48s.
 * http://192.168.251.53:19000: 38.23 MiB/s, 653.80 obj/s
 * http://192.168.251.55:19000: 40.97 MiB/s, 698.91 obj/s
 * http://192.168.251.54:19000: 39.24 MiB/s, 669.53 obj/s
warp: Cleanup Done.
```

![image-20220823100525303](C:\Users\XYB\Desktop\k8s调研\assets\image-20220823100525303.png)

![image-20220823100534123](C:\Users\XYB\Desktop\k8s调研\assets\image-20220823100534123.png)

![image-20220823100544880](C:\Users\XYB\Desktop\k8s调研\assets\image-20220823100544880.png)

![image-20220823100556721](C:\Users\XYB\Desktop\k8s调研\assets\image-20220823100556721.png)

![image-20220823100609862](C:\Users\XYB\Desktop\k8s调研\assets\image-20220823100609862.png)

