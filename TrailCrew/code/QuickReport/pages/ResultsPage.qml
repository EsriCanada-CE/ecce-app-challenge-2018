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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1

import "../controls"

Rectangle {
    width: parent.width
    height: parent.height
    color: app.pageBackgroundColor

    property bool isBusy: false

    property bool theFeatureEditingSuccess2: false
    property string type: "result"
    signal next(string message)
    signal previous(string message)

    ColumnLayout {
        width: parent.width
        height: parent.height
        spacing: 0

        Rectangle {
            id: resultsPage_headerBar
            Layout.alignment: Qt.AlignTop
            //Layout.fillHeight: true
            color: app.headerBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            Text {
                id: resultsPage_titleText
                text: qsTr("Thank You")
                textFormat: Text.StyledText
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                font.pixelSize: app.titleFontSize
                font.family: app.customTitleFont.name
                color: app.headerTextColor
                maximumLineCount: 1
                elide: Text.ElideRight
            }
        }

        Rectangle {
            Layout.fillHeight: true
            color:"transparent"
            Layout.preferredWidth: parent.width
            Layout.maximumWidth: 600*app.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter

            Flickable {
                //anchors.fill: parent
                width: parent.width
                height: parent.height
                contentHeight: container.height + 30*app.scaleFactor
                clip: true

                Item {
                    id: container
                    width: parent.width
                    height: 64*app.scaleFactor+resultsPage_statusImg.height+resultsPage_statusText.height+resultsPage_customizedText.height
                    Image {
                        id: resultsPage_statusImg
                        source: app.theFeatureEditingSuccess ? "../images/success.png" : "../images/error.png"
                        visible: app.theFeatureEditingAllDone
                        width: 256*app.scaleFactor
                        height: 256*app.scaleFactor
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.margins: 16*app.scaleFactor
                    }

                    Text {
                        id: resultsPage_statusText
                        text: app.featureServiceStatusString
                        textFormat: Text.StyledText
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        visible: app.theFeatureEditingAllDone
                        font.pixelSize: app.titleFontSize
                        font.family: app.customTitleFont.name
                        color: app.textColor
                        maximumLineCount: 8
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        anchors.top: resultsPage_statusImg.bottom
                        anchors.margins: 16*app.scaleFactor
                        Component.onCompleted: {
                            Qt.inputMethod.hide();
                        }
                    }

                    Text{
                        id: resultsPage_customizedText
                        text: app.isShowCustomText? app.thankyouMessage : ""
                        textFormat: Text.RichText
                        width: parent.width*0.9
                        visible: app.theFeatureEditingAllDone
                        horizontalAlignment: Text.AlignHCenter
                        font {
                            pixelSize: app.textFontSize
                            family: app.customTextFont.name
                        }
                        color: app.textColor
                        maximumLineCount: 8
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: resultsPage_statusText.bottom
                        anchors.margins: 32*app.scaleFactor
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    BusyIndicator {
                        z:11
                        visible: !app.theFeatureEditingAllDone
                        anchors.centerIn: parent
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50*app.scaleFactor
            Layout.maximumWidth: Math.min(parent.width*0.95, 600*scaleFactor);
            color: app.pageBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.margins: 8*app.scaleFactor
            radius: 4*app.scaleFactor
            clip: true
            visible: app.theFeatureEditingAllDone

            RowLayout {
                anchors.fill: parent
                spacing: 8*app.scaleFactor

                CustomButton {
                    buttonText: app.theFeatureEditingSuccess? qsTr("Done"): qsTr("Save")
                    buttonColor: app.buttonColor
                    buttonFill: true
                    buttonWidth: theFeatureEditingSuccess? parent.width: (parent.width/2 - 4*app.scaleFactor)
                    buttonHeight: 50*app.scaleFactor
                    visible: app.theFeatureEditingAllDone
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(app.theFeatureEditingSuccess) {
                                next("home")
                            }else{
                                if(!app.isFromSend){
                                    app.saveReport();
                                } else{
                                    app.isFromSend = false;
                                }

                                // delete feature from server if failed to submit
                                if(AppFramework.network.isOnline && app.currentObjectId > 0) {
                                    app.deleteFeature(app.currentObjectId);
                                }

                                next("home")
                            }
                        }
                    }
                }

                CustomButton {
                    buttonText: qsTr("Discard")
                    buttonColor: app.buttonColor
                    buttonFill: false
                    buttonWidth: parent.width/2
                    buttonHeight: 50*app.scaleFactor
                    visible: (!theFeatureEditingSuccess)&&(app.theFeatureEditingAllDone)
                    Layout.preferredWidth: parent.width/2 - app.scaleFactor

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            confirmBox.visible = true;
                        }
                    }
                }

            }
        }
    }

    DropShadow {
        source: resultsPage_headerBar
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

    ConfirmBox{
        id: confirmBox
        anchors.fill: parent
        onAccepted: {
            // delete feature from local database
            if(app.isFromSaved){
                deleteReportFromDatabase();
            }

            // delete all attachments
            var attachments = [];
            for(var i=0;i<app.appModel.count;i++){
                temp = app.appModel.get(i).path;
                app.selectedImageFilePath = AppFramework.resolvedPath(temp)
                attachments.push(app.selectedImageFilePath);
            }
            removeAttachments(attachments);

            // delete feature from server if failed to submit
            if(AppFramework.network.isOnline && app.currentObjectId > 0 && !theFeatureEditingSuccess) {
                app.deleteFeature(app.currentObjectId);
            }

            next("home");
        }
    }

    function back(){
        if(confirmBox.visible===true){
            confirmBox.visible = false;
        }
    }
}
