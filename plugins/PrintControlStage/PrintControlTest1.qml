import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick 2.0
import QtQuick.Scene3D 2.0

Item {

    width: 800
    height: 600

    Scene3D{
        anchors.fill: parent

        Entity {
            id: sceneRoot

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 450
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 10.0,0.0, 0.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
            }

            FirstPersonCameraController { camera: camera }

            components: [
                RenderSettings{
                    activeFrameGraph: ForwardRenderer{
                        clearColor: Qt.rgba(0,0.5,1,1);
                        camera: camera
                    }
                },
                InputSettings{}
            ]



            Mesh {
                   id: mesh
                   source: "qrc:/images/t.stl"
               }

            Transform{
                id:torTransform
                scale3D:Qt.vector3d(1.5,1,0.5)
                rotation:fromAxisAndAngle(Qt.vector3d(0,1,0),1)
                property real hAngle:0.0

                NumberAnimation on hAngle{
                    from:0
                    to:360.0
                    duration: 10000
                    loops: Animation.Infinite
                }
                matrix:{
                    var m=Qt.matrix4x4();
                    m.rotate(hAngle,Qt.vector3d(0,1,0));
                    m.translate(Qt.vector3d(0,0,0));
                    return m;

                }

            }

               PhongAlphaMaterial {
                   id: material
                   ambient: "gray"
                   alpha: 1.0
               }

               Entity {
                   id: entity
                   components: [mesh, material,torTransform]
               }

        }

    }
}