import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

RoundButton{
    id:switchBtn
    radius: 30 * scaleFactor
    width:60 * scaleFactor
    height:width
    Material.elevation: 6
    Material.background: "#8f499c"
    anchors {
        left: parent.left
        bottom: parent.bottom
        leftMargin: 10 * scaleFactor
        bottomMargin: 15 * scaleFactor
    }
    onClicked:{
        popUp.visible = 1
    }
    
    Image{
        source: "../assets/switcher.png"
        height:24 * scaleFactor
        width: 24 * scaleFactor
        anchors.centerIn: parent
    }
}









