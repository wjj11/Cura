# Copyright (c) 2018 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
from typing import Optional, Dict, TYPE_CHECKING

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty

from UM.i18n import i18nCatalog
from UM.Message import Message
from plugins.TemperatureStage import TemperatureStage
import threading
import time
if TYPE_CHECKING:
    from cura.CuraApplication import CuraApplication
from UM.Logger import Logger
import json
i18n_catalog = i18nCatalog("cura")


class SettingTemp(QObject):
    # Signal emitted when user logged in or out.
    reciveSignal = pyqtSignal(str, arguments=["showmessage"])
    reciveTipSignal = pyqtSignal(str, arguments=["showmessage"])

    def __init__(self, application: "CuraApplication", parent = None) -> None:
        super().__init__(parent)
        self._application = application

        self._error_message = None  # type: Optional[Message]

    @pyqtSlot(int)  # 修改部分：打印方式的选择
    def setPrintMethond(self, index) -> None:
        self._application.print_methond = index
        self._application.print_condition = False

    @pyqtSlot(result=int)   #修改部分：选择框中获取打印方式的值
    def getPrintMethond(self) -> None:
         return  self._application.print_methond

    @pyqtSlot()  # 修改部分：抓取喷头操作
    def gotoGrabNozzle(self) -> None:
        if self._application.print_methond == -1:
            self.reciveSignal.emit("请先选择打印方式")

        else:
            ser = self._application.serial_communication.ser_arr[0]
            self._application.serial_communication.write_to_port(ser, (
                        "nozzle" + str(self._application.print_methond) + "\r\n").encode('utf-8'))
            self._application.print_condition = False

    @pyqtSlot()  # 修改部分：针头定位操作
    def gotoNozzleLocation(self) -> None:
        if self._application.print_nozzle_grabed == False:
            self.reciveSignal.emit("请先抓取喷头")
        else:
            ser = self._application.serial_communication.ser_arr[0]
            self._application.serial_communication.write_to_port(ser, "n_location\r\n".encode('utf-8'))
            self._application.print_condition = False

    @pyqtSlot()  # 修改部分：拨片定位操作
    def gotoPlaneLocation(self) -> None:
        if self._application.serial_communication.redata_arr[1] != "n_location":
            self.reciveSignal.emit("请先抓取喷头")
        else:
            ser = self._application.serial_communication.ser_arr[0]
            self._application.serial_communication.write_to_port(ser, "p_location\r\n".encode('utf-8'))


    @pyqtSlot(result=int)  # 修改部分：获取打印方式的值
    def getPrintNozzleGrad(self) -> None:
        if self._application.print_nozzle_grabed == False:
            return -1
        else:
            return self._application.print_methond

    @pyqtSlot(result=list)  # 修改部分：展示环境和恒温台的温度
    def getCurrentTemp(self) -> None:

        r1 = hex(int(82 + 1))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        outTemp1 = str(80 + 1) + str(80 + 1) + "52000000" + r1[2:] + r1[0:2] + "0D0A"
        r2 = hex(int(82 + 2))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        outTemp2 = str(80 + 2) + str(80 + 2) + "52000000" + r2[2:] + r2[0:2] + "0D0A"

        ser = self._application.serial_communication.ser_arr[1]
        self._application.serial_communication.write_to_port(ser, bytes.fromhex(outTemp1))  #
        time.sleep(0.5)
        self._application.serial_communication.write_to_port(ser, bytes.fromhex(outTemp2))  #
        time.sleep(0.5)

        if self._application.print_nozzle_grabed == True:
            # 修改部分：条件准备完成，展示实时温度
            if self._application.print_methond == 0:
                r3 = hex(int(82 + 3))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
                outTemp3 = str(80 + 3) + str(80 + 3) + "52000000" + r3[2:] + r3[0:2] + "0D0A"
                r4 = hex(int(82 + 4))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
                outTemp4 = str(80 + 4) + str(80 + 4) + "52000000" + r4[2:] + r4[0:2] + "0D0A"

                self._application.serial_communication.write_to_port(ser, bytes.fromhex(outTemp3))  #
                time.sleep(0.5)
                self._application.serial_communication.write_to_port(ser, bytes.fromhex(outTemp4))  #
                time.sleep(0.5)
            elif self._application.print_methond == 1:
                r5 = hex(int(82 + 3))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
                outTemp5 = str(80 + 3) + str(80 + 3) + "52000000" + r5[2:] + r5[0:2] + "0D0A"
                self._application.serial_communication.write_to_port(ser, bytes.fromhex(outTemp5))  #
                time.sleep(0.5)

        listtemp = self._application.serial_communication.redata_arr[0]
        return listtemp

    @pyqtSlot(str, int)   #修改部分：添加环境温度设置 index为重复的3
    def setTemp(self,content, index) -> None:
        print(2222222222222)
        temp = int(float(content)*10)  #传入的温度的10倍
        s = hex(temp & 0xffff)[2:].zfill(4) #将写入值转化为十六进制并将其位数补齐
        c = hex(int(67+ temp +index))[2:].zfill(4) #计算校验码值转化为十六进制并将其位数补齐
        inputTemp = str(80+index) + str(80+index)  +"4300" + s[2:] + s[0:2] +  c[2:]  + c[0:2] +"0D0A"

        ser = self._application.serial_communication.ser_arr[1]
        self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  #写入字节
        time.sleep(1)


    @pyqtSlot(int, result=str)  # 修改部分：获取运行的状态 index不为重复的3，最大值为5
    def getState(self, index) -> None:
        temp_list = self._application.temp_state_list
        if temp_list[index - 1] == False:
            return "运行"
        else:
            return "停止"


    @pyqtSlot(int, result=str)  # 修改部分：运行和停止温控的操作 index不为重复的3，最大值为5
    def setRunOrStop(self, index) -> None:
        temp_list = self._application.temp_state_list
        temp_list[index - 1] = bool(1 - temp_list[index - 1])
        ser = self._application.serial_communication.ser_arr[1]
        if temp_list[index - 1] == False:
            if index ==5:
                index = 3
            c = hex(int(13 *256 + 67 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            c1 = hex(int(12 * 256 + 67 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp = str(80 + index) + str(80 + index) + "43130000" + c[2:] + c[0:2] + "0D0A"
            inputTemp1 = str(80 + index) + str(80 + index) + "43120000" + c1[2:] + c1[0:2] + "0D0A"

            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #OPH和OPL都赋值0
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp1))  # 写入字节  #OPH和OPL都赋值0

            return "运行"
        else:
            threading.Thread(target=SettingTemp.readFile, args=(self, index,)).start()
            return "停止"

    #读取温控的默认配置文件信息
    def readFile(self, index):
        begin_time = time.time()
        with open("D:/data.json", "r", encoding="utf-8") as file:
            strJson = json.load(file)
        end_time = time.time()
        Logger.log("d", "Reading file took %s seconds", end_time - begin_time)
        print(strJson)

        ser = self._application.serial_communication.ser_arr[1]

        hold = strJson[index-1]["hold"]
        speed =strJson[index-1]["speed"]
        time_h = strJson[index-1]["time"]

        if index ==5:
            index = 3

        temp = int(hold)
        s = hex(temp)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
        c = hex(int(7 *256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        inputTemp = str(80 + index) + str(80 + index) + "4307" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"

        temp1 = int(speed)
        s1 = hex(temp1)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
        c1 = hex(int(8 * 256 + 67 + temp1 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        inputTemp1 = str(80 + index) + str(80 + index) + "4308" + s1[2:] + s1[0:2] + c1[2:] + c1[0:2] + "0D0A"

        temp2 = int(time_h)
        s2 = hex(temp2)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
        c2 = hex(int(9 * 256 + 67 + temp2 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        inputTemp2 = str(80 + index) + str(80 + index) + "4309" + s2[2:] + s2[0:2] + c2[2:] + c2[0:2] + "0D0A"

        self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #M5
        self._application.serial_communication.write_to_port(ser,bytes.fromhex(inputTemp1))  # 写入字节  #P
        self._application.serial_communication.write_to_port(ser,bytes.fromhex(inputTemp2))  # 写入字节  #t

        temp = int(100)
        s = hex(temp)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
        c = hex(int(13 *256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        inputTemp = str(80 + index) + str(80 + index) + "4313" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"
        temp1 = int(-100)
        s1 = hex(temp1&0xffff)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
        c1 = hex(int(12 * 256 + 67 +temp1 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
        inputTemp1 = str(80 + index) + str(80 + index) + "4312" + s1[2:] + s1[0:2] + c1[2:] + c1[0:2] + "0D0A"

        self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #OPH赋值100和OPL都赋值-100
        self._application.serial_communication.write_to_port(ser,bytes.fromhex(inputTemp1))  # 写入字节  #OPH赋值100和OPL都赋值-100


    @pyqtSlot(int,str,str,str,str,str,str)  # 修改部分：保存系统参数，只要文本框内容不为空，就会向温控系统发送数据，为空就不做任何操作，将修改后的值保存到文件中
    def setSystemTemp(self, index,limitup,limitdown,fixtemp,hold,speed,timeh) -> None:
        ser = self._application.serial_communication.ser_arr[1]
        with open("D:/data.json", "r", encoding="utf-8") as file:
            strJson = json.load(file)

        if limitup != "":
            strJson[index-1]["limit_up"] =limitup

            if index ==5:
                index = 3
            temp = int(float(limitup) * 10)  # 传入的温度的10倍
            s = hex(temp & 0xffff)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c = hex(int(1 * 256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp = str(80 + index) + str(80 + index) + "4301" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #HIAL
        if limitdown != "":
            strJson[index - 1]["limit_down"] = limitdown

            if index ==5:
                index = 3
            temp = int(float(limitdown) * 10)  # 传入的温度的10倍
            s = hex(temp & 0xffff)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c = hex(int(2 * 256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp = str(80 + index) + str(80 + index) + "4302" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #LOAL
        if fixtemp != "":
            strJson[index - 1]["fix_temp"] = fixtemp

            if index ==5:
                index = 3
            temp = int(float(fixtemp) * 10)  # 传入的温度的10倍
            s = hex(temp & 0xffff)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c = hex(int(10 * 256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp = str(80 + index) + str(80 + index) + "4310" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #SC
        if hold != "":
            strJson[index - 1]["hold"] = hold

            if index ==5:
                index = 3
            temp = int(hold)
            s = hex(temp)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c = hex(int(7 *256 + 67 + temp + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp = str(80 + index) + str(80 + index) + "4307" + s[2:] + s[0:2] + c[2:] + c[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp))  # 写入字节  #SC
        if speed != "":
            strJson[index - 1]["speed"] = speed

            if index ==5:
                index = 3
            temp1 = int(speed)
            s1 = hex(temp1)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c1 = hex(int(8 * 256 + 67 + temp1 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp1 = str(80 + index) + str(80 + index) + "4308" + s1[2:] + s1[0:2] + c1[2:] + c1[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp1))  # 写入字节  #SC
        if timeh != "":
            strJson[index - 1]["time"] = timeh

            if index ==5:
                index = 3
            temp2 = int(timeh)
            s2 = hex(temp2)[2:].zfill(4)  # 将写入值转化为十六进制并将其位数补齐
            c2 = hex(int(9 * 256 + 67 + temp2 + index))[2:].zfill(4)  # 计算校验码值转化为十六进制并将其位数补齐
            inputTemp2 = str(80 + index) + str(80 + index) + "4309" + s2[2:] + s2[0:2] + c2[2:] + c2[0:2] + "0D0A"
            self._application.serial_communication.write_to_port(ser, bytes.fromhex(inputTemp2))  # 写入字节  #SC

        with open("D:/data.json", "w", encoding="utf-8") as file:
            file.write(json.dumps(strJson))

        self.reciveTipSignal.emit("设置成功")
        #print(limitup+","+limitdown+","+fixtemp+","+hold+","+speed+","+timeh)



    @pyqtSlot(str ,result=str)  # 修改部分：添加系统设置按钮响应
    def systemInter(self, password ) -> None:
        #TemperatureStage.TemperatureStage().update()
        if password != "123456":
            return "输入密码不正确"
        else:
            return "ok"

    @pyqtSlot()  # 修改部分：温度范围超出后，给出相应的弹框提示
    def inValidator(self) -> None:
        self.reciveSignal.emit("温度设置值超出范围")







