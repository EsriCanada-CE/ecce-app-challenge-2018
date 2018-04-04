/* Copyright 2017 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1
import QtGraphicalEffects 1.0

import "../controls"


Rectangle {
    id: root
    width: parent.width
    height: parent.height
    signal signInClicked()
    signal next(string message)
    color: app.pageBackgroundColor
    property bool isDebug: false

    property string aboutString: qsTr("About")
    property string settingsString: qsTr("Settings")
    property string type: "root"
    property var webPage


    Item{
        id: landingPageContainer
        anchors.fill: parent
        ColumnLayout {

            anchors.fill: parent
            spacing: 0

            //top
            Rectangle {
                id: topContainer
                color: app.headerBackgroundColor
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.6

                AnimatedImage {
                    id: startBackgroundImage
                    anchors.fill: parent
                    source: app.landingPageBackgroundImageURL
                    fillMode: Image.PreserveAspectCrop
                    visible: source > ""
                }

                Rectangle {
                    anchors.fill: parent
                    visible: startBackgroundImage.status === Image.Ready
                    gradient: Gradient {
                        GradientStop { position: 1.0; color: "#99000000";}
                        GradientStop { position: 0.0; color: "#22000000";}
                    }
                }


                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16 * app.scaleFactor
                    height: 0.9 * parent.height
                    width: Math.min(parent.width, app.units(600))
                    anchors.centerIn: parent

                    Rectangle {
                        id: appLogoImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        Layout.preferredWidth: appLogoImage.height/6*8
                        Layout.preferredHeight: Math.min(96*app.scaleFactor, parent.height-title.height-subtitle.height-parent.spacing*3)

                        visible: app.startShowLogo
                        color: "transparent"

                        border.width: isDebug ? 1 : 0

                        Image {
                            anchors.centerIn: parent
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            source: app.appLogoImageUrl
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(app.logoUrl && app.logoUrl.length > 1) {
                                    Qt.openUrlExternally(unescape(app.logoUrl))
                                }
                            }
                        }
                    }

                    Text {
                        id: title
                        Layout.maximumWidth: app.units(600)
                        Layout.fillWidth: true
                        Layout.leftMargin: app.units(32)
                        Layout.rightMargin: app.units(32)
                        text: app.info.title
                        fontSizeMode: Text.HorizontalFit
                        minimumPixelSize: app.headingFontSize
                        wrapMode: Text.Wrap
                        font {
                            pixelSize: app.headingFontSize
                            family: app.customTitleFont.name
                            bold: true
                            weight: Font.Bold
                        }
                        color: app.headerTextColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        maximumLineCount: 2

                        Rectangle {
                            anchors.fill: parent
                            opacity: 0.5
                            visible: isDebug
                        }
                    }

                    Rectangle {
                        Layout.maximumWidth: app.units(600)
                        Layout.preferredWidth: parent.width * 0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                        Layout.preferredHeight: app.units(1)
                        color: app.headerTextColor
                        opacity: 0.5
                    }

                    Text {
                        id: subtitle
                        Layout.maximumWidth: app.units(600)
                        text: app.info.snippet
                        fontSizeMode: Text.HorizontalFit
                        minimumPixelSize: app.subtitleFontSize
                        font.pixelSize: app.subtitleFontSize
                        font.family: app.customTextFont.name
                        color: app.headerTextColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.Wrap
                        Layout.preferredWidth: parent.width * 0.8
                        maximumLineCount: 3

                        Rectangle {
                            anchors.fill: parent
                            opacity: 0.5
                            visible: isDebug
                        }
                    }

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }

                Icon {
                    id: menuIcon
                    imageSource: "../images/menu_white.png"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    visible: app.isSmallScreen
                    onIconClicked: {
                        menu.show();
                    }
                }

                Icon {
                    id: downloadIcon
                    imageSource: "../images/ic_file_download_black_48dp.png"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    property var t
                    rotation: 10*Math.cos(4*Math.PI*t) * Math.pow(Math.E, -t/2);
                    visible: app.isOnline && !app.mmpkManager.offlineMapExist && mmpkManager.loadStatus!=1 && app.offlineMMPKID>"" && !app.mmpkSecureFlag
                    onIconClicked: {
                        mmpkDialog.visible = true;
                    }
                }

                NumberAnimation{
                    id: downloadIconAnimation
                    target: downloadIcon
                    properties: "t"
                    loops: Animation.Infinite
                    running: downloadIcon.visible && !app.mmpkManager.offlineMapExist
                    from: 0
                    to: 5
                    duration: 1000
                }

                Item{
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: menuIcon.imageSize/2
                    anchors.topMargin: menuIcon.imageSize/2
                    width: menuIcon.imageSize
                    height: menuIcon.imageSize
                    clip: true

                    ImageOverlay{
                        id: downloadingIcon
                        width: menuIcon.imageSize
                        height: menuIcon.imageSize
                        source: "../images/download_no_bar.png"
                        fillMode: Image.PreserveAspectFit
                        showOverlay: true
                        visible: downloadingAnimation.running
                    }

                    NumberAnimation{
                        id: downloadingAnimation
                        running: app.mmpkManager.loadStatus === 1
                        target: downloadingIcon
                        properties: "y"
                        from: -menuIcon.imageSize
                        to: 0
                        alwaysRunToEnd: true
                        duration: 1000
                        loops: Animation.Infinite
                    }
                }

                Item{
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: menuIcon.imageSize/2
                    anchors.topMargin: menuIcon.imageSize/2
                    width: menuIcon.imageSize
                    height: menuIcon.imageSize
                    clip: true

                    ImageOverlay{
                        id: downloadedIcon
                        width: menuIcon.imageSize
                        height: menuIcon.imageSize
                        source: "../images/ic_offline_pin_black_48dp.png"
                        fillMode: Image.PreserveAspectFit
                        showOverlay: true
                        visible: (mmpkManager.offlineMapExist && !downloadingAnimation.running && !app.mmpkSecureFlag)
                    }
                }
            }

            // center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumWidth: app.units(600)
                color: "transparent"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 48 * app.scaleFactor
                    Layout.fillHeight: true
                    Layout.fillWidth: false

                    Icon {
                        containerSize: app.isSmallScreen ? app.units(96) : app.units(112)
                        imageSize: 0.7 * containerSize
                        backgroundColor: app.buttonColor
                        imageSource: "../images/ic_note_add_white_48dp.png"

                        onIconClicked: {
                            app.clearData();
                            isFromSaved = false
                            init();
                        }

                        iconText.text : qsTr("New")
                        iconText.font.pixelSize: app.textFontSize
                        iconText.font.family: app.customTextFont.name
                        iconText.color: app.textColor

                        isDebug: false
                    }

                    Icon {
                        containerSize: app.isSmallScreen ? app.units(96) : app.units(112)
                        imageSize: 0.7 * containerSize
                        backgroundColor: "gray"
                        imageSource: "../images/ic_drafts_white_48dp.png"

                        isDebug: false

                        onIconClicked: {
                            app.initSavedReportsPage();
                        }

                        iconText.text: qsTr("Drafts")
                        iconText.font.pixelSize: app.textFontSize
                        iconText.font.family: app.customTextFont.name
                        iconText.color: app.textColor
                        bubbleCount: app.savedReportsCount
                        bubbleColor: app.buttonColor
                    }
                }
            }

            //bottom

            Item {
                anchors.bottom: parent.bottom
                Layout.fillWidth: true
                Layout.preferredHeight: app.isSmallScreen ? app.units(36) : app.units(42)
                anchors.horizontalCenter: parent.horizontalCenter
                visible: app.isSmallScreen
            }

            Rectangle {
                id: footer
                color:Qt.lighter(app.pageBackgroundColor)
                anchors.bottom: parent.bottom
                Layout.fillWidth: true
                Layout.preferredHeight: app.units(42)
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !app.isSmallScreen

                RowLayout {
                    id: footerLayout
                    anchors.bottom: parent.bottom
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                    width: Math.min(parent.width, app.units(600))
                    spacing: app.units(4)

                    Repeater {
                        model: footerModel

                        Rectangle {
                            Layout.preferredWidth: parseInt((parent.width-footerLayout.spacing)/footerModel.count)
                            Layout.preferredHeight: footer.height
                            color: "transparent"
                            clip: true

                            Text {
                                id: itemName

                                property string itemType: type
                                property string itemValue: value
                                property string itemText: name

                                textFormat: Text.StyledText
                                wrapMode: Text.WordWrap
                                font.pixelSize: app.textFontSize
                                font.family: app.customTextFont.name
                                color: app.isDarkMode? "white":app.headerBackgroundColor
                                elide: Text.ElideMiddle
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: itemType==="about" ? aboutString : (itemType === "settings"? settingsString:itemText)
                                anchors.fill: parent
                                fontSizeMode: app.isSmallScreen ? Text.HorizontalFit : Text.FixedSize
                                maximumLineCount: 2

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#99ff0000"
                                    visible: false
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {
                                        var component = webPageComponent;
                                        webPage = component.createObject(root);
                                        if (type === "about") {
                                            aboutPage.open();
                                        } else if (type === "email") {
                                            Qt.openUrlExternally(webPage.generateFeedbackEmailLink())
                                        } else if (type === "phone") {
                                            Qt.openUrlExternally("tel:%1".arg(phoneNumber)) ;
                                        } else if (type === "link") {
                                            webPage.openWebURL(value, name)
                                        } else if (type === "settings"){
                                            settingsPage.open();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        DropShadow {
            source: topContainer
            //anchors.fill: source
            width: source.width
            height: source.height
            cached: false
            radius: 5.0
            samples: 16
            color: "#80000000"
            smooth: true
            visible: source.visible
        }

        DropShadow {
            source: menuIcon
            //anchors.fill: source
            width: source.width
            height: source.height
            cached: false
            radius: 5.0
            samples: 16
            color: "#80000000"
            smooth: true
            visible: source.visible
        }

        Rectangle{
            anchors.fill: parent
            color: app.headerBackgroundColor
            opacity: 0.8 * menu.opacity
            visible: menu.visible
        }
    }

    FastBlur{
        id: menu
        anchors.fill: landingPageContainer
        source: landingPageContainer
        radius: 64
        visible: !(opacity==0.0)
        opacity: 0.0

        function show(){
            fadeInAnimation.start();
        }

        function hide(){
            fadeOutAnimation.start();
        }

        NumberAnimation {
            id: fadeInAnimation
            targets: menu
            property: "opacity"
            duration: 200
            easing.type: Easing.InOutQuad
            from: 0.0
            to: 1.0
        }

        NumberAnimation {
            id: fadeOutAnimation
            target: menu
            property: "opacity"
            duration: 200
            easing.type: Easing.InOutQuad
            from: 1.0
            to: 0.0
        }

        MouseArea{
            anchors.fill: parent
        }

        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 16*app.scaleFactor

            Item{
                Layout.preferredHeight: 30*app.scaleFactor
                Layout.fillWidth: true
                Item{
                    width: parent.height
                    height: parent.height
                    anchors.right: parent.right
                    Image{
                        width: 30*app.scaleFactor
                        height: 30*app.scaleFactor
                        anchors.centerIn: parent
                        source: "../images/ic_clear_white_48dp.png"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            menu.hide();
                        }
                    }
                }
            }

            ListView{
                id: listView
                model: footerModel
                Layout.fillWidth: true
                Layout.fillHeight: true
                delegate: Item{
                    id: delegateItem
                    width: listView.width
                    height: 60*app.scaleFactor
                    opacity: 0.0
                    visible: menu.visible

                    onVisibleChanged: {
                        if(visible === true){
                            opacity = 0.0;
                        }
                    }

                    RowLayout{
                        anchors.fill: parent
                        Item{
                            Layout.preferredWidth: parent.height
                            Layout.preferredHeight: parent.height
                            Image{
                                width: 30*app.scaleFactor
                                height: 30*app.scaleFactor
                                anchors.centerIn: parent
                                source: icon
                            }
                        }
                        Text {
                            text: type==="about" ? aboutString : (type === "settings"? settingsString : name)
                            font.family: app.customTextFont.name
                            font.pixelSize: app.titleFontSize
                            Layout.fillWidth: true
                            color: app.headerTextColor
                            verticalAlignment: Text.AlignVCenter
                        }
                    }


                    NumberAnimation {
                        id: delegateFadeInAnimation
                        target: delegateItem
                        property: "opacity"
                        duration: 150
                        easing.type: Easing.InOutQuad
                        from: 0.0
                        to: 1.0
                    }

                    Timer{
                        interval: index*100
                        repeat: false
                        running: menu.visible
                        triggeredOnStart: false
                        onTriggered: {
                            delegateFadeInAnimation.start();
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            menu.hide();
                            var component = webPageComponent;
                            webPage = component.createObject(root);
                            if (type === "about") {
                                aboutPage.open();
                            } else if (type === "email") {
                                Qt.openUrlExternally(webPage.generateFeedbackEmailLink())
                            } else if (type === "phone") {
                                Qt.openUrlExternally("tel:%1".arg(phoneNumber)) ;
                            } else if (type === "link") {
                                webPage.openWebURL(value, name)
                            } else if (type === "settings"){
                                settingsPage.open();
                            }
                        }
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: !initializationCompleted
        visible: running
    }

    ConfirmBox{
        id: mmpkDialog
        anchors.fill: parent
        text: app.mmpkManager.offlineMapExist? app.mmpkUpdateDialogString : app.mmpkDownloadDialogString
        onAccepted: {
            app.mmpkManager.downloadOfflineMap(function(){})
        }
    }

    Connections{
        target: app.mmpkManager
        onLoadStatusChanged: {
            if(app.mmpkManager.loadStatus===2 && !settingsPage.visible){
                mmpkFailedDialog.visible = true;
            }
        }
    }

    ConfirmBox{
        id: mmpkFailedDialog
        anchors.fill: parent
        text: app.mmpkDownloadFailString
        standardButtons: StandardButton.Ok
    }

    function back(){
        if(webPage != null && webPage.visible === true){
            webPage.close();
            app.focus = true;
        } else if (menu.visible === true){
            menu.hide();
        } else if (aboutPage.visible === true){
            aboutPage.hide()
        } else if (settingsPage.visible === true){
            settingsPage.back();
        } else if(mmpkDialog.visible == true) {
            mmpkDialog.visible = false;
        } else if(mmpkFailedDialog.visible == true) {
            mmpkFailedDialog.visible = false;
        }
    }
}
