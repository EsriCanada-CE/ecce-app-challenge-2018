import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import ArcGIS.AppFramework 1.0

/*
  About page to include the credits of the app and a link to the story map
  */

Page {
    id:page
    signal openMenu()
    property string titleText:""
    property var descText
    header: ToolBar{
        contentHeight: 56*app.scaleFactor
        Material.primary: app.secondaryColor
        RowLayout {
            anchors.fill: parent
            spacing: 0
            Item{
                Layout.preferredWidth: 4*app.scaleFactor
                Layout.fillHeight: true
            }
            ToolButton {
                indicator: Image{
                    width: parent.width*0.5
                    height: parent.height*0.5
                    anchors.centerIn: parent
                    source: "./assets/menu.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
                onClicked: {
                    openMenu();
                }
            }
            Item{
                Layout.preferredWidth: 20*app.scaleFactor
                Layout.fillHeight: true
            }
            Label {
                Layout.fillWidth: true
                text: titleText
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: app.subtitleFontSize
                color: app.primaryColor
            }

        }
    }


    ColumnLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.topMargin: 40 * scaleFactor
        anchors.bottomMargin: 40 * scaleFactor
        spacing: 12*app.scaleFactor

        Label{
            Layout.fillWidth: true
            font.family: app.fontFamily.name
            font.pixelSize: app.titleFontSize
            font.bold: true
            text: 'Geomatics students from UNB who have ever felt frustrated trying to find a parking spot. This Application aims to improve parking finding assistance in Toronto area.'
            color: app.secondaryColor
            wrapMode: Text.Wrap
            padding: 20 * scaleFactor
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Image {
            Layout.preferredWidth: parent.width*1
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/group1.jpg"
            fillMode: Image.PreserveAspectFit

        }

        Label{
            Layout.preferredWidth: parent.width*0.8
            font.family: app.fontFamily.name
            font.pixelSize: app.subtitleFontSize
            text:  'Marissa Hamilton \n Marta Padilla Ruiz \n  Wen Jiang \n Rajesh Tamilmani '
            color: "#8B00CD"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button{
            id: control
            anchors.horizontalCenter: parent.horizontalCenter
            highlighted: true
            Material.foreground: app.primaryColor
            Material.background: "#8B00CD"
            font.family: app.fontFamily.name
            font.pixelSize: app.subtitleFontSize
            text: qsTr("Read our Story")
            contentItem: Text {
                    text: control.text
                    font: control.font
                    color: control.down ? "white" : "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            padding: 20*app.scaleFactor
            topPadding: 10*app.scaleFactor
            bottomPadding: topPadding
            onClicked: {
                Qt.openUrlExternally("http://bit.ly/2FZ4MZ3");
            }
        }

    }

}
