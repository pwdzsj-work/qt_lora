#ifndef DEVICEDATASTR_H
#define DEVICEDATASTR_H
#include<qobject.h>
class DeviceDataStr
{
public:
  DeviceDataStr();
  quint16 DeviceKind; //设备型号第一个字节：0-网口设备 1-4G设备 第二个字节1-4路，2-8路，3-16路，4-32路
  QString  Device_IP;  //设备ID
  QString Device_Volt[32];     //设备电压
  quint8  Device_ID[100];//MAC地址
  QString  Device_Current[32];  //设备电流
  QString  Device_Temp;		   //设备温度
  QString  Device_Name;        //设备名字
  quint32  Device_SW_State;     //设备开关状态
private:


};

#endif // UNIVERSALPROTOCALINTERFACE_H
