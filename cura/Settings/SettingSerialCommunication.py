
import serial
import serial.tools.list_ports
import threading
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty
import json
from UM.Resources import Resources
from UM.Application import Application

port_list = list(serial.tools.list_ports.comports())
print(port_list)
if len(port_list) == 0:
    print('无可用串口')
else:
    for i in range(0,len(port_list)):
        print(port_list[i])


BOOL = True  #读取标志位


class SettingSerialCommunication(QObject):
    def __init__(self, parent = None):
        super().__init__(parent)
        with open("D:/data_port.json", "r", encoding="utf-8") as file:
            strJson = json.load(file)

        self.port_list = [ {"port": strJson[0]["port"], "bps": strJson[0]["bps"]},{"port": strJson[1]["port"], "bps": strJson[1]["bps"]}]
        self.ser_arr = []
        self.redata_arr = [[0, 0, 0 ,0, 0], "Stop",False,False]
        self.temp = ""
        self.mutex = threading.Lock()

    reciveSignal = pyqtSignal(str, arguments=["showmessage"])
    reciveTipSignal = pyqtSignal(str,int, arguments=["showmessage","value"])
    conditionReadySignal = pyqtSignal()
    connectTempSignal = pyqtSignal()
    noconnectTempSignal = pyqtSignal()
    def read_utf_data(self, ser):
        #循环接收数据，此为死循环，可用线程实现
        try:
            global BOOL
            while BOOL:
                if ser.in_waiting:
                    print(ser.in_waiting)
                    receive_data = ser.read(ser.in_waiting).decode('utf-8')
                    self.redata_arr[1] = receive_data
                    print(receive_data)
                    if receive_data[0:1] == "G":
                        self.redata_arr[2] = True
                    elif receive_data[0:1] == "L":
                        self.redata_arr[2] = True    #为了让发送G代码过程中的while循环退出
                        SettingSerialCommunication.handleData(self,receive_data)
                    elif receive_data == "p_location":
                        self.reciveTipSignal.emit("拨片定位操作完成",1)
                    elif receive_data == "nozzle":
                        self.connectTempSignal.emit()
                    elif receive_data == "n_location":
                        self.reciveTipSignal.emit("针头定位操作完成",0)
                    elif receive_data == "no_nozzle":
                        self.noconnectTempSignal.emit()
                    else:
                        self.redata_arr[2] = False

        except Exception as e:
            print(e)

    def handleData(self,content):
        showcontent = "111"
        if content[1:] == "IMITPOS_X":
            showcontent = "到达X正限位，请点击寸动模块中的回原点按钮"
        elif content[1:] == "IMITNEG_X" :
            showcontent =  "到达X负限位，请点击寸动模块中的回原点按钮"
        elif content[1:] == "IMITPOS_Y":
            showcontent = "到达Y正限位，请点击寸动模块中的回原点按钮"
        elif content[1:] == "IMITNEG_Y":
            showcontent = "到达Y负限位，请点击寸动模块中的回原点按钮"
        elif content[1:] == "IMITPOS_Z" :
            showcontent =  "到达Z正限位，请点击寸动模块中的回原点按钮"
        elif content[1:] == "IMITNEG_Z" :
            showcontent =  "到达Z负限位，请点击寸动模块中的回原点按钮"
        self.reciveSignal.emit(showcontent)

    def read_byte_data(self, ser):
        #循环接收数据，此为死循环，可用线程实现
        try:
            global BOOL
            while BOOL:
                if ser.in_waiting:
                    receive_data = ser.read(10)
                    self.temp = receive_data.hex()

                    if( len(self.temp) == 20):
                        current = int( self.temp[2:4]+self.temp[0:2] ,16)
                        total = int( self.temp[18:] + self.temp[16:18], 16) - (current + int(self.temp[6:8] + self.temp[4:6], 16) + int(self.temp[14:16] + self.temp[12:14], 16) + (int(self.temp[10:12], 16) * 256 + int(self.temp[8:10], 16)))
                        #print(self.temp)
                        print(total)
                        if (total  == 1):
                            self.redata_arr[0][0] =current
                        elif (total  == 2):
                            self.redata_arr[0][1] = current
                        elif (total  == 3):
                            self.redata_arr[0][2] = current
                        elif (total  == 4):
                            self.redata_arr[0][3] = current
                        elif (total  == 5):
                            self.redata_arr[0][4] = current
                        self.temp = ""
                        print(self.redata_arr[0])

                    elif( len(self.temp) > 20):
                        self.temp = ""

        except Exception as e:
            print(e)

    def open_port(self):

        ret = False
        global BOOL
        BOOL = True
        self.ser_arr = []
        try:
            for index ,obj in enumerate(self.port_list):
                ser = serial.Serial(obj.get("port"), obj.get("bps"), timeout=45)
                self.ser_arr.append(ser)
                print(index)
                if(ser.is_open):
                    ret = True
                    if(index ==0) :
                        threading.Thread(target=SettingSerialCommunication.read_utf_data, args=(self, ser,),daemon=True).start()
                    elif(index ==1):
                        threading.Thread(target=SettingSerialCommunication.read_byte_data, args=(self, ser,),daemon=True).start()


        except Exception as e:
            ret = False
            print(obj)
            print("---异常---：", e)

        return ret

    def write_to_port(self, ser, text):
        result = ser.write(text)  # 写数据
        return result


    def close_port(self):
        global BOOL
        BOOL = False
        for ser in self.ser_arr:
            ser.close()


