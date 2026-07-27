# Qt LoRa 终端扫描与轮询

本实现与 `ESP32_MODBUS_RELAY` 的 LoRa 透明传输协议一致，不使用旧终端
上线协议，也不使用广播上线帧。Qt 同时支持两种透明传输入口：

- `QTcpSocket`：网络 LoRa 透明网关；
- `QSerialPort`：电脑 USB/串口 LoRa 模块，默认 `9600 8N1`。

两种入口共用同一个扫描、轮询、CRC 校验和离线判断状态机，可同时保持
连接。串口可在“配置 → 关于软件 → LoRa串口”中选择、刷新和连接。

## 通信流程

1. Qt 每 300 ms 执行一次 LoRa 状态机。
2. 对每个已连接的透明传输网关，依次扫描 Modbus 地址 `1..247`。
3. 扫描使用功能码 `0x11`（Report Server ID）：

   ```text
   01 11 C0 2C
   ```

4. 收到 CRC 正确、运行标志为 `FF` 的响应后，将该地址加入在线列表。
5. 在线终端使用功能码 `0x04` 读取输入寄存器 `0x0000..0x0011`：

   ```text
   01 04 00 00 00 12 70 07
   ```

6. 连续三次数据轮询超时后，终端被标记为离线。
7. 完整扫描结束后正常轮询 60 秒，然后重新扫描。

扫描期间如果已经发现终端，扫描请求和数据轮询交替发送，保证已上线终端
仍能及时刷新数据。所有请求均为单地址定向请求，因此不会导致多个 LoRa
终端同时应答。

## ESP32 寄存器映射

| 输入寄存器 | 数量 | Qt 用途 |
|---|---:|---|
| `0x0000` | 4 | ADS1115 原始值 |
| `0x0004` | 4 | ADC 毫伏值 |
| `0x0008` | 4 | 工程值 ×100 |
| `0x000C` | 4 | 通道模式：0=电压，1=电流 |
| `0x0010` | 1 | 四路继电器状态位图 |
| `0x0011` | 1 | 四路数字输入状态位图（使用 bit0～bit3） |

模拟量模式可在设备详情页的 AN1～AN4 卡片中选择。Qt 使用功能码
`0x06` 写保持寄存器 `0x0100～0x0103`：写入 `0` 选择 `0–10 V`，
写入 `1` 选择 `4–20 mA`。ESP32 返回写入回显后，下一次 `0x04`
轮询会按新模式刷新数值和单位。

设备详情页的“校时”按钮使用功能码 `0x10`，将电脑当前本地时间一次性
写入保持寄存器 `0x0300～0x0305`：年、月、日、时、分、秒。终端返回
起始地址和寄存器数量回显后，界面显示“校时成功”；连续三次无响应则显示
失败。

## 继电器状态协议

Qt 使用标准 Modbus RTU 功能码 `0x01`（Read Coils）读取四路继电器：

```text
请求：01 01 00 00 00 04 3D C9
响应：01 01 01 05 91 8B
```

响应数据字节按位表示继电器状态：bit0=CH1、bit1=CH2、bit2=CH3、
bit3=CH4；位值 `1` 表示开启，`0` 表示关闭。示例 `0x05` 表示
CH1、CH3 开启，CH2、CH4 关闭。Qt 对每个在线终端交替发送 `0x04`
数据轮询和 `0x01` 状态轮询，并把结果保存到 `dev_chswstate1`，
同时通过 `QmlModelShowData` 的命令 `4` 实时刷新设备详情页。

协议编解码位于 `cpp/lora_modbus_protocol.cpp/.h`，轮询状态机位于
`cpp/user_tcpserver.cpp`。

QML 也可以直接调用串口接口：

```qml
user_tcpserver_qmlobj.availableLoraSerialPorts()
user_tcpserver_qmlobj.openLoraSerialPort("COM3", 9600)
user_tcpserver_qmlobj.closeLoraSerialPort()
```

## Qt 编译

```powershell
cd F:\esp32\soft\FormalClientTools_211118172655
$env:Path = "C:\Qt\Tools\mingw1310_64\bin;$env:Path"
New-Item -ItemType Directory -Force build-qt6-release
cd build-qt6-release
C:\Qt\6.11.1\mingw_64\bin\qmake.exe ..\QTQuickTest.pro
mingw32-make -j4
```
