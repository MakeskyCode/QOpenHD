import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import Qt.labs.settings 1.0
import QtQuick.Shapes 1.0

import OpenHD 1.0


BaseWidget {
    id: windWidget
    width: 50
    height: 50

    visible: settings.show_wind

    widgetIdentifier: "wind_widget"

    defaultAlignment: 3
    defaultXOffset: 100
    defaultYOffset: 100

    hasWidgetDetail: true
    widgetDetailComponent: Column {
        Item {
            width: parent.width
            height: 32
            Text {
                text: "Opacity"
                color: "white"
                height: parent.height
                font.bold: true
                font.pixelSize: detailPanelFontPixels
                anchors.left: parent.left
                verticalAlignment: Text.AlignVCenter
            }
            Slider {
                id: wind_opacity_Slider
                orientation: Qt.Horizontal
                from: .1
                value: settings.wind_opacity
                to: 1
                stepSize: .1
                height: parent.height
                anchors.rightMargin: 0
                anchors.right: parent.right
                width: parent.width - 96

                onValueChanged: {// @disable-check M223
                    settings.wind_opacity = wind_opacity_Slider.value
                }
            }
        }
        Item {
            width: parent.width
            height: 32

            Text {
                text: "45 Degree Speed"
                color: "white"
                height: parent.height
                font.bold: true
                font.pixelSize: detailPanelFontPixels
                anchors.left: parent.left
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle {
                id: decimalRect
                height: 40
                width: 30
                anchors.rightMargin: 0
                anchors.right: parent.right
                antialiasing: true;

                Tumbler {
                    id: decimalTumbler
                    model: 10

                    visibleItemCount : 1
                    anchors.fill: parent
                    Component.onCompleted: {
                        currentIndex= settings.wind_tumbler_decimal ;
                    }

                    delegate: Text {
                        text: modelData
                        color: "white"
                        font.family: "Arial"
                        font.weight: Font.Thin
                        font.pixelSize: 14

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        //opacity: 1.0 - Math.abs(Tumbler.displacement) / root.visibleItemCount
                        scale: opacity
                    }

                    onCurrentIndexChanged: {
                        settings.wind_tumbler_decimal = currentIndex;
                        //  console.log("decimal Changed-",settings.wind_tumbler_decimal)
                    }
                }
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Material.color(Material.Grey ,Material.Shade500) }
                    GradientStop { position: 0.5; color: "transparent" }
                    GradientStop { position: 1.0; color: Material.color(Material.Grey ,Material.Shade500) }
                }
            }
            Text {
                id:decimalText
                text: "."
                color: "white"
                height: parent.height
                font.bold: true
                font.pixelSize: detailPanelFontPixels
                anchors.right: decimalRect.left
                rightPadding: 5
                leftPadding: 5
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle {
                id: tensRect
                height: 40
                width: 30
                anchors.right: decimalText.left
                antialiasing: true;

                Tumbler {
                    id: tensTumbler
                    model: 60
                    visibleItemCount : 1
                    anchors.fill: parent

                    Component.onCompleted: {
                        // rounds it due to int
                        currentIndex= settings.wind_tumbler_tens;
                    }
                    delegate: Text {
                        text: modelData
                        color: "white"

                        font.family: "Arial"
                        font.weight: Font.Thin
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        //opacity: 1.0 - Math.abs(Tumbler.displacement) / root.visibleItemCount
                        scale: opacity
                    }
                    onCurrentIndexChanged: {
                        settings.wind_tumbler_tens = currentIndex;
                        //   console.log("tens Changed-",settings.wind_tumbler_tens);
                    }
                }
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Material.color(Material.Grey ,Material.Shade500) }
                    GradientStop { position: 0.5; color: "transparent" }
                    GradientStop { position: 1.0; color: Material.color(Material.Grey ,Material.Shade500) }
                }
            }
        }
    }

    Glow {
        anchors.fill: widgetInner
        radius: 2
        samples: 17
        color: settings.color_glow
        opacity: settings.wind_opacity
        source: widgetInner
    }

    Item {
        id: widgetInner
        anchors.fill: parent
        antialiasing: true

        opacity: settings.wind_opacity

        Shape {
            id: arrow
            anchors.fill: parent
            antialiasing: true
            opacity: settings.arrow_opacity

            visible: false

            ShapePath {
                capStyle: ShapePath.RoundCap
                strokeColor: settings.color_glow
                fillColor: settings.color_shape
                strokeWidth: 1
                strokeStyle: ShapePath.SolidLine

                startX: 3
                startY: 0
                PathLine { x: 6;                 y: 12  }//right edge of arrow
                PathLine { x: 4;                 y: 12  }//inner right edge
                PathLine { x: 4;                 y: 40 }//bottom right edge
                PathLine { x: 3;                  y: 40 }//bottom left edge
                PathLine { x: 3;                  y: 12  }//inner left edge
                PathLine { x: 0;                  y: 12  }//outer left
                PathLine { x: 3;                  y: 0  }//back to start
            }

            transform: Rotation {
                origin.x: 3;
                origin.y: 20;
                angle: {// @disable-check M223

                 //   var wind=getWindDirection();
                 //   var wind_direction=wind.direction - OpenHD.hdg + 180;
                 //   return wind_direction;
                    OpenHD.wind_direction - OpenHD.hdg + 180;
                }
            }
        }

        Shape {
            id: lowerPointer
            anchors.fill: parent
            antialiasing: true
            opacity: settings.arrow_opacity

            visible: true

            ShapePath {
                capStyle: ShapePath.RoundCap
                strokeColor: settings.color_glow
                fillColor: settings.color_shape
                strokeWidth: 2
                strokeStyle: ShapePath.SolidLine

                startX: 25
                startY: 38
                PathLine { x: 25; y: 50  }
            }

            transform: Rotation {
                origin.x: 25;
                origin.y: 25;
                angle: {// @disable-check M223

                //    var wind=getWindDirection();
                //    var wind_direction=wind.direction - OpenHD.hdg + 175;
                 //   return wind_direction;
                    OpenHD.wind_direction - OpenHD.hdg + 175;
                }
            }
        }
        Shape {
            id: upperPointer
            anchors.fill: parent
            antialiasing: true
            opacity: settings.arrow_opacity

            visible: true

            ShapePath {
                capStyle: ShapePath.RoundCap
                strokeColor: settings.color_glow
                fillColor: settings.color_shape
                strokeWidth: 2
                strokeStyle: ShapePath.SolidLine

                startX: 25
                startY: 38
                PathLine { x: 25; y: 50  }
            }

            transform: Rotation {
                origin.x: 25;
                origin.y: 25;
                angle: {// @disable-check M223

                 //   var wind=getWindDirection();
                  //  var wind_direction=wind.direction - OpenHD.hdg + 185;
                 //   return wind_direction;
                    OpenHD.wind_direction - OpenHD.hdg + 185;
                }
            }
        }

        Rectangle {
            id: outerCircle

            anchors.centerIn: parent

            width: (parent.width<parent.height?parent.width:parent.height)
            height: width
            color: "transparent"
            radius: width*0.5

            border.color: settings.color_shape
            border.width: .5
        }
        Rectangle {
            id: innerCircle

            anchors.centerIn: parent

            width: (parent.width<parent.height?parent.width:parent.height)/2
            height: width
            color: "transparent"
            radius: width*0.5

            border.color: settings.color_shape
            border.width: .5
        }

        Text {
            id: wind_text
            color: settings.color_text

            anchors.centerIn: parent

            font.pixelSize: 12
            text: {// @disable-check M223

              //  var wind=getWindDirection();
              //  var wind_speed=wind.speed;
                Number(OpenHD.wind_speed).toLocaleString(// @disable-check M222
                      Qt.locale(), 'f', 0)} // @disable-check M222
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }






    }
}



