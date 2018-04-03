import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

/*
  Class representing each of the items in the swipping view
  */

Item {
    property string title: ""
    property string subtitle: ""
    property string imageSource: ""
    clip: true

    ColumnLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.topMargin: 40 * scaleFactor
        spacing: 12*app.scaleFactor

        Image {
            Layout.preferredWidth: parent.width*0.7
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            source: imageSource
            fillMode: Image.PreserveAspectFit

        }

        Label{
            Layout.fillWidth: true
            font.family: app.fontFamily.name
            font.pixelSize: app.titleFontSize
            font.bold: true
            text: title
            color: app.secondaryColor
            wrapMode: Text.Wrap
            padding: 20 * scaleFactor
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label{
            Layout.preferredWidth: parent.width*0.8
            font.family: app.fontFamily.name
            font.pixelSize: app.subtitleFontSize
            bottomPadding: 5*scaleFactor
            text: subtitle
            color: app.secondaryColor
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
