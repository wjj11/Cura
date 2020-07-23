# Copyright (c) 2018 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
from typing import Optional, Dict, TYPE_CHECKING

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty

from UM.i18n import i18nCatalog
from UM.Message import Message
from UM.Application import Application

import time
import threading
from UM.Logger import Logger
from PyQt5.QtCore import QUrl


if TYPE_CHECKING:
    from cura.CuraApplication import CuraApplication


i18n_catalog = i18nCatalog("cura")



class PrintSetting(QObject):
    # Signal emitted when user logged in or out

    def __init__(self, application: "CuraApplication", parent = None) :
        super().__init__(parent)
        self._application = application
        self._error_message = None  # type: Optional[Message]
        self.readCount = 0
        self.speed_first = 0
        self.stopLayer = 0

    readFinished = pyqtSignal(str, arguments=["fileContent"])
    printProgress = pyqtSignal(float,int, arguments=["value","layer"])
    printFinished = pyqtSignal()
    printError = pyqtSignal()
    printLayerFinished = pyqtSignal()
    printSpeed = pyqtSignal(str, arguments=["speed"])

    printNotPrepare = pyqtSignal(str, arguments=["showmessage"])

    #获取最新保存的gcode文件
    @pyqtSlot(result=float)
    def getCurrentFile(self) -> None:

        save_file = Application.getInstance().getPreferences().getValue("local_file/last_save_file")
        print(save_file)
        if save_file != "":
            threading.Thread(target=PrintSetting.readFile, args=(self,)).start()

        return self._application.print_percent

    @pyqtSlot()  # 文件内容加载
    def readFile(self):
        self.speed_first =0
        save_file = Application.getInstance().getPreferences().getValue("local_file/last_save_file")
        begin_time = time.time()
        with open(save_file, "r", encoding="utf-8") as file:
            for index ,line in enumerate(file):
                # 获取初始打印速度
                if self.speed_first == 0 and line[0:3] == "G1 ":
                    if "X" in line or "Y" in line or "Z" in line:
                        line_list = line.split()
                        self.speed_first = (int)(line_list[1][1:]) / 60
                        print("sudu:" + (str)(self.speed_first))
                        self.printSpeed.emit((str)(self.speed_first))
                        break

        with open(save_file, "r", encoding="utf-8") as file:
            # while True:
            #     file_data = file.read(20)
            #     if file_data == "":
            #         break
            #     print("------------" + file_data)
            #     self.readFinished.emit(file_data)

            file_data = file.read(2048 + 2048 * self.readCount)
            self.readCount = self.readCount + 1
            self.readFinished.emit(file_data)

            # file_data = file.read()
        end_time = time.time()
        Logger.log("d", "Reading file took %s seconds", end_time - begin_time)
        # self.readFinished.emit(file_data)

    #添加文件功能
    @pyqtSlot(QUrl)
    def openFile(self, filePath):
        print(filePath)
        f = filePath.toLocalFile()
        Application.getInstance().getPreferences().setValue("local_file/last_save_file", f)
        self.readCount =0  #每次打开新文件时，readCount自动清零
        PrintSetting.pramClear(self)
        PrintSetting.readFile(self)

    # 断点续打
    @pyqtSlot()
    def gotoPosition(self):
        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, "BACK\r\n".encode('utf-8'))

    #模型打印功能
    @pyqtSlot(int)
    def printModel(self,index):
        save_file = Application.getInstance().getPreferences().getValue("local_file/last_save_file")
        if save_file != "" :   #  and self._application.print_condition == True:
            self._application.print_state[index] = True
            self._application.print_thread = threading.Thread(target=PrintSetting.printFileContent,
                                                              args=(self, save_file,index,)).start()
        else:
            self.printNotPrepare.emit("不满足打印条件")
            self.printError.emit()

    def printFileContent(self, save_file,index_p):

        self._application.serial_communication.redata_arr[3] = False
        self._application.serial_communication.redata_arr[2] = False
        ser = self._application.serial_communication.ser_arr[0]
        begin_time = time.time()
        with open(save_file, "r", encoding="utf-8") as file:
            for index ,line in enumerate(file):
                print(self._application.print_index)

                while self._application.serial_communication.redata_arr[3] == True:
                    return

                if "End of Gcode" in line:
                    self._application.print_percent = 100
                    self.printFinished.emit()

                if index <self._application.print_index :
                    continue
                else:
                    if "LAYER_COUNT" in line:
                        self._application.count_number = (int)(line[13:])
                        self._application.print_index = index + 1
                    elif "LAYER" in line:
                        # if index_p == 1:
                        #     if (int)(line[7:]) > self._application.print_layer:
                        #         self.printLayerFinished.emit()
                        #         self._application.print_layer += 1
                        #         return

                        self._application.print_index = index + 1
                        self._application.print_layer = (int)(line[7:])
                        percent = self._application.print_layer * 100 / self._application.count_number  if(self._application.count_number !=0) else 0
                        self._application.print_percent = float('%.2f' % percent)
                        self._application.print_layer += 1
                        self.printProgress.emit(float('%.2f' % percent), self._application.print_layer)

                        if index_p == 1:
                            if self._application.print_layer == self.stopLayer:
                                self.printLayerFinished.emit()
                                return

                    if line[0:3] == "G1 " or line[0:3] == "G0 ":

                        if self._application.serial_communication.redata_arr[2] == False:

                            # list = line.split(" ")
                            # for index ,content in enumerate(list):
                            #     if content[0] == "F":
                            #         list[index] = "F" +str( float(content[1:]) /60)
                            #     elif content[0]== "X" or content[0]== "Y" or content[0]== "Z":
                            #         list[index] = content[0] + str(float(content[1:]) *2000)
                            # line = ' '.join(list)

                            self._application.serial_communication.write_to_port(ser, line.encode('utf-8'))
                            self._application.print_index = index + 1

                            while self._application.serial_communication.redata_arr[2] == False:
                                pass

                            self._application.serial_communication.redata_arr[2] = False
                            if self._application.serial_communication.redata_arr[1][0:1] != 'G':
                                self.printError.emit()
                                break

                    else:
                        self._application.print_index = index + 1

        end_time = time.time()
        Logger.log("d", "Reading file took %s seconds", end_time - begin_time)


    #模型打印停止功能
    @pyqtSlot(int)
    def stopPrintModel(self,index):
        print("stop")
        self._application.print_state[index] = False
        self._application.serial_communication.redata_arr[2] = True
        self._application.serial_communication.redata_arr[3] = True

        # enum = threading.enumerate()
        # enum_array = list(enum)
        # enum_len = len(enum_array)
        # print(enum_len)


    # 模型打印分层停止功能
    @pyqtSlot(int)
    def stopLayerPrint(self, index):
        print("layerstop")
        self._application.print_state[index] = False
        self._application.serial_communication.redata_arr[2] = True
        self._application.serial_communication.redata_arr[3] = True

        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, "BREAK".encode('utf-8'))


    @pyqtSlot()    #打印完成后参数清零
    def pramClear(self):
        print("clear")
        self._application.print_index = 0
        self._application.print_percent = 0.0
        self._application.print_layer = 0
        self._application.count_number =1
        self.speed_first =0
        self.stopLayer =0

    #获取当前打印层数
    @pyqtSlot(result=int)
    def getLayer(self):
        return self._application.print_layer

    # 设置断点打印的层数
    @pyqtSlot(str)
    def setStopLayer(self,layer):
        print(self.stopLayer)
        self.stopLayer = (int)(layer)
        print(self.stopLayer)

    @pyqtSlot(int,result=str)  # 修改部分：获取打印时的状态
    def getPrintState(self,index) -> None:
        state = self._application.print_state[index]
        if state == True:
            return "right"
        else:
            return "left"


    @pyqtSlot(result=str)  # 修改部分：获取气动的开关状态
    def getGongState(self) -> None:
        state = self._application.gongliao_state
        if state == True:
            return "right"
        else:
            return "left"

    @pyqtSlot(int, int)  # 修改部分：气动开关状态的转换
    def changeGongState(self, index, state) -> None:
        ser = self._application.serial_communication.ser_arr[0]
        if index == 0:
            if state == 0:
                self._application.serial_communication.write_to_port(ser, "R10\r\n".encode('utf-8'))
                self._application.gongliao_state = False
            elif state == 1:
                self._application.serial_communication.write_to_port(ser, "R11\r\n".encode('utf-8'))
                self._application.gongliao_state = True

    @pyqtSlot(str)
    def settingFeedValue(self,pre):
        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, ("P"+pre+"\r\n").encode('utf-8'))

    @pyqtSlot(str)
    def settingSpeedValue(self, speed):
        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, ("S" + speed +"\r\n").encode('utf-8'))

    @pyqtSlot()  # 修改部分：添加回到原点按钮响应
    def goHome(self) -> None:
        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, "HOME\r\n".encode('utf-8'))

    @pyqtSlot(int)  # 修改部分：添加寸动运动指令
    def gotoCMove(self, index) -> None:
        print(index)
        ser = self._application.serial_communication.ser_arr[0]
        if index == 0:
            self._application.serial_communication.write_to_port(ser, "JOG_Y0\r\n".encode('utf-8'))
        elif index == 1:
            self._application.serial_communication.write_to_port(ser, "JOG_X1\r\n".encode('utf-8'))
        elif index == 2:
            self._application.serial_communication.write_to_port(ser, "JOG_X0\r\n".encode('utf-8'))
        elif index == 3:
            self._application.serial_communication.write_to_port(ser, "JOG_Y1\r\n".encode('utf-8'))
        elif index == 4:
            self._application.serial_communication.write_to_port(ser, "JOG_Z0\r\n".encode('utf-8'))
        elif index == 5:
            self._application.serial_communication.write_to_port(ser, "JOG_Z1\r\n".encode('utf-8'))

    @pyqtSlot()  # 修改部分：添加寸动停止指令
    def gotoStop(self) -> None:
        ser = self._application.serial_communication.ser_arr[0]
        self._application.serial_communication.write_to_port(ser, "STOP\r\n".encode('utf-8'))





