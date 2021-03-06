# Copyright (c) 2017 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
import os.path
from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from cura.Stages.CuraStage import CuraStage

##  Stage for monitoring a 3D printing while it's printing.
class TemperatureStage(CuraStage):

    def __init__(self, parent=None):
        super().__init__(parent)

        # Wait until QML engine is created, otherwise creating the new QML components will fail
        Application.getInstance().engineCreatedSignal.connect(self._onEngineCreated)


    def _onEngineCreated(self):
        menu_component_path = os.path.join(PluginRegistry.getInstance().getPluginPath("TemperatureStage"),
                                           "TemperatureMenu.qml")
        main_component_path = os.path.join(PluginRegistry.getInstance().getPluginPath("TemperatureStage"),
                                           "TemperatureMain.qml")
        self.addDisplayComponent("menu", menu_component_path)
        self.addDisplayComponent("main", main_component_path)





