import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import "./controls"


Page{
    id: sideMenuView
    anchors.fill: parent
    Material.background:app.appBackgroundColor
    property ListModel menuModel
    property alias currentIndex: listView.currentIndex

    signal menuSelected(var action)

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        onClicked: {

        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 16*app.scaleFactor
        Image{
            Layout.fillWidth: true
            Layout.preferredHeight: 75*app.scaleFactor
            source: "./images/BACKGROUND.png"
            fillMode: Image.PreserveAspectCrop
            mipmap: true            
        }

        ListView{
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5*app.scaleFactor
            clip: true

            model: drawerModel
            delegate:Rectangle{
                height: type === "delegate"? 60*app.scaleFactor: 8*app.scaleFactor
                width: parent.width
                color: listView.currentIndex === index? app.listViewDividerColor:"transparent"


                Item{
                    anchors.fill: parent
                    visible: type === "divider"
                    Rectangle{
                        width: parent.width
                        height: 1*app.scaleFactor
                        color: app.listViewDividerColor
                    }
                }

                RowLayout{
                    anchors.fill: parent
                    spacing: 0
                    visible: type === "delegate"
                    Item{
                        Layout.preferredWidth: 12*app.scaleFactor
                        Layout.fillHeight: true
                    }

                    Image{
                        Layout.preferredWidth: 60*app.scaleFactor
                        Layout.preferredHeight: 50*app.scaleFactor
                        source: listView.currentIndex === index? iconSource2 : iconSource
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }

                  /*  Rectangle{
                        Layout.preferredWidth: 24*app.scaleFactor
                        Layout.preferredHeight: 24*app.scaleFactor
                        radius: 12*app.scaleFactor
                        anchors.verticalCenter: parent.verticalCenter
                        color: listView.currentIndex === index? app.accentColor : "#9E9E9E"
                    }*/
                    Item{
                        Layout.preferredWidth: 15*app.scaleFactor
                        Layout.fillHeight: true
                    }
                    Label{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        text:name                        
                        font.pixelSize: app.baseFontSize*0.7
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: listView.currentIndex === index? app.accentColor : app.appPrimaryTextColor
                        opacity:listView.currentIndex === index? 0.87:1.0
                    }
                }

                Ink {
                    id: ink
                    visible: type === "delegate"
                    enabled: visible
                    propagateComposedEvents: false
                    preventStealing: false
                    anchors.centerIn: parent
                    centered: true
                    circular: true
                    hoverEnabled: true
                    color: app.listViewDividerColor
                    anchors.fill: parent
                    onClicked: {
                        console.log("Item clicked");
                        listView.currentIndex = index;
                        menuSelected(action);
                    }
                }
            }
        }

    }
    function setListViewCurrentIndex(index){
        listView.currentIndex = index
    }   
}


