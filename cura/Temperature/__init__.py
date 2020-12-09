# Copyright (c) 2018 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.
from typing import Optional, TYPE_CHECKING

from PyQt5.QtCore import QObject, pyqtProperty

from cura.Temperature.SettingTemp import SettingTemp

if TYPE_CHECKING:
    from cura.CuraApplication import CuraApplication


##  The official Cura API that plug-ins can use to interact with Cura.
#
#   Python does not technically prevent talking to other classes as well, but
#   this API provides a version-safe interface with proper deprecation warnings
#   etc. Usage of any other methods than the ones provided in this API can cause
#   plug-ins to be unstable.
class CuraTemperature(QObject):

    # For now we use the same API version to be consistent.
    __instance = None  # type: "CuraAPI"
    _application = None  # type: CuraApplication

    #   This is done to ensure that the first time an instance is created, it's forced that the application is set.
    #   The main reason for this is that we want to prevent consumers of API to have a dependency on CuraApplication.
    #   Since the API is intended to be used by plugins, the cura application should have already created this.
    def __new__(cls, application: Optional["CuraApplication"] = None):
        if cls.__instance is None:
            if application is None:
                raise Exception("Upon first time creation, the application must be set.")
            cls.__instance = super(CuraTemperature, cls).__new__(cls)
            cls._application = application
        return cls.__instance

    def __init__(self, application: Optional["CuraApplication"] = None) -> None:
        super().__init__(parent = CuraTemperature._application)

        # Backups API
        self._temp = SettingTemp(self._application)

    @pyqtProperty(QObject, constant=True)
    def temp(self) -> "SettingTemp":
        return self._temp