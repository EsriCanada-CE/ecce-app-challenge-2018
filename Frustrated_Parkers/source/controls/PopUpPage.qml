import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.1

import ArcGIS.AppFramework 1.0

Rectangle {
    id:popUp
    anchors.fill: parent
    color: "#80000000"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mouse.accepted = false
        }
    }

    Rectangle {
        id:popUpWindow
        height: 300 * scaleFactor
        width: 300 * scaleFactor
        anchors.centerIn: parent
        radius: 3 * scaleFactor
        Material.background:  "#FAFAFA"
        Material.elevation:24


        Label{
            id:titleText
            Layout.preferredWidth: parent.width*0.8
            anchors.top:parent.top
            anchors.bottom:popUpListView.top
            padding:10*scaleFactor
            font{
                pixelSize:18 * scaleFactor
                bold:true
            }
            bottomPadding: 5*scaleFactor
            text: qsTr("What vehicle are you parking?")
           // color: app.secondaryColor
            wrapMode: Text.Wrap
           // horizontalAlignment: Text.AlignHCenter
            //anchors.horizontalCenter: parent.horizontalCenter
        }

        ListView{
            id:popUpListView
            anchors.topMargin: 64 * scaleFactor
            anchors.fill: parent
            model:ListModel {
                id:sampleItems

                ListElement { name:"Car";  }

                ListElement { name:"Bicycle"; }

            }

            onCurrentIndexChanged: {

                sampleName = sampleItems.get(currentIndex).name

            }
            delegate: Rectangle{
                width:300 * scaleFactor
                height: 40 * scaleFactor
                color: index===popUpListView.currentIndex? "#808c499c":"transparent"

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    padding: 24 * scaleFactor
                    font {
                        pixelSize: app.baseFontSize * 0.8
                    }
                    text:name
                }

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        popUp.visible = 0
                        popUpListView.currentIndex = index
                       // qmlfile = sampleItems.get(index).url
                        sampleName = sampleItems.get(index).name
                       // descriptionText =sampleItems.get(index).description
                    }
                }
            }


        }
    }

    DropShadow {
        id: headerbarShadow
        source: popUpWindow
        anchors.fill: popUpWindow
        width: source.width
        height: source.height
        cached: true
        radius: 8.0
        samples: 17
        color: "#80000000"
        smooth: true
    }
}




