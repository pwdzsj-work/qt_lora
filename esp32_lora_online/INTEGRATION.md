# ESP32_MODBUS_RELAY 接入说明

`lora_online_scan.c/.h` 与 Modbus 业务独立，面向 RS485-LoRa 透明传输模块。

1. 把两个源文件复制到 `ESP32_MODBUS_RELAY/main/`。
2. 在该工程的 `main/CMakeLists.txt` 的 `SRCS` 中加入
   `"lora_online_scan.c"`。
3. 在 `modbus_slave.c` 中包含头文件：

   ```c
   #include "lora_online_scan.h"
   ```

4. 收到一帧 UART 数据后，先分流上线扫描帧，再处理 Modbus：

   ```c
   log_received_frame(rx, len);
   if (!lora_online_scan_process(rx, len))
       handle_request(rx, len);
   ```

扫描帧和上线应答均使用 `A5 5A` 帧头、长度字段及 Modbus CRC16。
默认扫描为 16 个时隙、每时隙 120 ms。每台设备使用扫描序号和自身
MAC 哈希选择应答时隙，以降低多个 LoRa 终端同时上线时的碰撞概率。

帧格式：

| 字节 | 含义 |
|---|---|
| 0..1 | 帧头 `A5 5A` |
| 2 | 协议版本 `01` |
| 3 | 类型：`01` 扫描，`02` 上线应答 |
| 4 | Payload 长度 |
| 5..6 | 扫描序号，大端 |
| 7..N | Payload |
| N+1..N+2 | CRC16，小端；计算范围为帧头至 Payload |

上线应答固定携带：6 字节 MAC、Modbus 地址、设备类型、通道数、能力
位图、固件主/次版本。上位机收到合法且序号匹配的应答后，更新设备表
并将设备标记为在线；连续三轮扫描没有应答时标记离线。

扫描示例（序号 `0x1234`）：

```text
A5 5A 01 01 02 12 34 10 0C 69 46
```
