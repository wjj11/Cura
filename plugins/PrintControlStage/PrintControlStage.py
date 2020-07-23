# Copyright (c) 2017 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
import os.path
from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from cura.Stages.CuraStage import CuraStage

import vtk
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtOpenGL import QGLWidget

from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtOpenGL import QGLWidget


##  Stage for monitoring a 3D printing while it's printing.
class PrintControlStage(CuraStage):

    def __init__(self, parent=None):
        super().__init__(parent)

        # Wait until QML engine is created, otherwise creating the new QML components will fail
        Application.getInstance().engineCreatedSignal.connect(self._onEngineCreated)



    def _onEngineCreated(self):
        menu_component_path = os.path.join(PluginRegistry.getInstance().getPluginPath("PrintControlStage"),
                                           "PrintControlMenu.qml")
        main_component_path = os.path.join(PluginRegistry.getInstance().getPluginPath("PrintControlStage"),
                                           "PrintControlMain.qml")
        self.addDisplayComponent("menu", menu_component_path)
        self.addDisplayComponent("main", main_component_path)







