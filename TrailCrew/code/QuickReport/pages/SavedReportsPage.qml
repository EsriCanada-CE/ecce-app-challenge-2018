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
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1
import QtGraphicalEffects 1.0

import "../controls"

Rectangle {
    //    anchors.fill: parent
    width: parent.width
    height: parent.height
    color: app.pageBackgroundColor

    signal next(string message)
    signal previous(string message)

    property int hitFeatureId
    property variant attrValue
    property var tempId
    property int tempIndex

    property real factor: 1.2
    property bool isMostRecentFirst: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        clip: true

        Rectangle {
            id: header
            Layout.alignment: Qt.AlignTop
            color: app.headerBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            ImageButton {
                source: "../images/ic_keyboard_arrow_left_white_48dp.png"
                height: 30 * app.scaleFactor
                width: 30 * app.scaleFactor
                checkedColor : "transparent"
                pressedColor : "transparent"
                hoverColor : "transparent"
                glowColor : "transparent"
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    console.log("Back button from saved reports page clicked")
                    app.updateSavedReportsCount();
                    previous("")
                }
            }

            Text {
                id: title
                text: qsTr("Drafts")
                textFormat: Text.StyledText
                anchors.centerIn: parent
                font.pixelSize: app.titleFontSize
                font.family: app.customTitleFont.name
                color: app.headerTextColor
                horizontalAlignment: Text.AlignHCenter
                maximumLineCount: 1
                elide: Text.ElideRight
            }

            ImageButton {
                id: sortButton
                source: "../images/ic_low_priority_white_48dp.png"
                height: 30 * app.scaleFactor
                width: 30 * app.scaleFactor
                checkedColor : "transparent"
                pressedColor : "transparent"
                hoverColor : "transparent"
                glowColor : "transparent"
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                rotation: isMostRecentFirst? 0:180
                visible: app.savedReportsModel.count>1
                onClicked: {
                    app.reverseSavedReportData();
                    isMostRecentFirst = !isMostRecentFirst;
                }

                Behavior on rotation{
                    NumberAnimation{
                        duration: 200
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
            Layout.maximumWidth: 600*app.scaleFactor
            color: app.pageBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true

            Image {
                id: placeHolderImage
                visible: app.savedReportsModel.count < 1
                source: "../images/inbox_empty.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: (parent.height-placeHolderImage.height-placeHolderText.height)/2
                fillMode: Image.PreserveAspectFit
                width: parent.width * 0.6
                height: parent.width * 0.6
            }

            Text{
                id: placeHolderText
                width: parent.width*0.6
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: placeHolderImage.bottom
                font.pixelSize: app.subtitleFontSize
                font.family: app.customTextFont.name
                color: app.textColor
                opacity: 0.75
                visible: app.savedReportsModel.count < 1
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("You do not have any saved drafts right now.")
            }

            ListView {
                id: listView
                spacing: 8 * app.scaleFactor
                anchors {
                    fill: parent;
                    margins: 10 * app.scaleFactor
                }
                model: app.savedReportsModel
                currentIndex: -1
                delegate: Rectangle{
                    width: listView.width
                    height: allcontent.height//listView.currentIndex == index? 120*app.scaleFactor: 70*app.scaleFactor
                    color: Qt.lighter(app.pageBackgroundColor, factor)
                    border.color: Qt.darker(app.pageBackgroundColor, factor)
                    border.width: 1
                    property bool isOpenButtons: false

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(listView.currentIndex === index) isOpenButtons = !isOpenButtons
                            else isOpenButtons = true;
                            listView.currentIndex = index;
                        }
                    }

                    ColumnLayout{
                        id: allcontent
                        width: parent.width
                        spacing: 0
                        Rectangle{
                            id: content
                            Layout.fillWidth: true
                            Layout.preferredHeight: app.units(70)
                            color: "transparent"
                            border.width: app.scaleFactor
                            border.color: Qt.darker(app.pageBackgroundColor, factor)
                            RowLayout{
                                anchors.fill: parent
                                spacing: 0
                                //left
                                ColumnLayout{
                                    Layout.preferredWidth: app.units(24)
                                    Layout.fillHeight: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    Layout.margins: 16*app.scaleFactor
                                    Layout.alignment: Qt.AlignLeft
                                    ImageOverlay{
                                        Layout.preferredWidth: app.units(24)
                                        Layout.preferredHeight: app.units(24)
                                        anchors.verticalCenter: parent.verticalCenter
                                        fillMode: Image.PreserveAspectFit
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: isReady? "../images/checkbox_mark_black.png":"../images/alert_outline_black.png" //"../images/attachment_black.png"
                                        opacity: 0.6
                                        showOverlay: app.isDarkMode
                                    }
                                }

                                //center
                                ColumnLayout{
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    Layout.alignment: Qt.AlignLeft

                                    Text{
                                        text: type
                                        color: app.textColor
                                        font.pixelSize: app.subtitleFontSize
                                        font.family: app.customTextFont.name
                                        verticalAlignment: Text.AlignVCenter
                                        maximumLineCount: 2
                                        wrapMode: Text.Wrap
                                        Layout.fillWidth: true
                                    }

                                    Label{
                                        text:detailText(hasAttachments, numberOfAttachment, size, date)
                                        color: Qt.lighter(app.textColor, factor)
                                        font.pixelSize: app.subtitleFontSize * 0.8
                                        font.family: app.customTextFont.name
                                        verticalAlignment: Text.AlignVCenter
                                        textFormat: Text.StyledText
                                        fontSizeMode: Text.Fit
                                        Layout.fillWidth: true
                                    }
                                }

                                //right menu button
                                Rectangle{
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: app.units(24)
                                    Layout.rightMargin: 16*app.scaleFactor
                                    Layout.topMargin: 16*app.scaleFactor
                                    Layout.bottomMargin: 16*app.scaleFactor
                                    anchors.verticalCenter: parent.verticalCenter
                                    Layout.alignment: Qt.AlignRight
                                    color: "transparent"
                                    ImageOverlay {
                                        source: "../images/vert_more_black.png"
                                        fillMode: Image.PreserveAspectCrop
                                        width: app.units(10)
                                        height: app.units(24)
                                        opacity: 0.5
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        showOverlay: app.isDarkMode
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: buttons
                            Layout.fillWidth: true
                            Layout.preferredHeight: height
                            color: Qt.lighter(app.pageBackgroundColor, factor)
                            border.color: Qt.darker(app.pageBackgroundColor, factor)
                            border.width: 0
                            height: (listView.currentIndex == index&&isOpenButtons)? 50*app.scaleFactor:0
                            opacity: height/(50*app.scaleFactor)

                            Behavior on height{
                                NumberAnimation { duration: 200 }
                            }

                            RowLayout{
                                anchors.fill: parent
                                spacing: 4 * app.scaleFactor
                                Rectangle{
                                    Layout.preferredWidth: (parent.width-2*parent.spacing)/3
                                    Layout.fillHeight: true
                                    Layout.topMargin: 4 * app.scaleFactor
                                    color: "transparent"
                                    border.width: app.scaleFactor
                                    border.color: Qt.darker(app.pageBackgroundColor, factor)
                                    ImageOverlay{
                                        id: deleteIcon
                                        width: parent.height*0.6
                                        height: parent.height*0.6
                                        anchors.centerIn: parent
                                        source: "../images/ic_delete_forever_black_48dp.png"
                                        opacity: 0.6
                                        showOverlay: app.isDarkMode
                                    }

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: {
                                            confirmBox.visible = true
                                            tempIndex = index
                                            tempId = id
                                        }
                                    }
                                }
                                Rectangle{
                                    Layout.preferredWidth: (parent.width-2*parent.spacing)/3
                                    Layout.fillHeight: true
                                    Layout.topMargin: 4 * app.scaleFactor
                                    color: "transparent"
                                    border.width: app.scaleFactor
                                    border.color: Qt.darker(app.pageBackgroundColor, factor)

                                    ImageOverlay{
                                        width: parent.height*0.6
                                        height: parent.height*0.6
                                        anchors.centerIn: parent
                                        source: "../images/ic_mode_edit_black_48dp.png"
                                        opacity: app.savedReportsModel.get(index).featureLayerURL == app.featureLayerURL? 0.6:0.3
                                        showOverlay: app.isDarkMode
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if(app.savedReportsModel.get(index).featureLayerURL == app.featureLayerURL)edit(index)
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: (parent.width-2*parent.spacing)/3
                                    Layout.fillHeight: true
                                    Layout.topMargin: 4 * app.scaleFactor
                                    color: "transparent"
                                    border.width: app.scaleFactor
                                    border.color: Qt.darker(app.pageBackgroundColor, factor)

                                    ImageOverlay {
                                        id: sendIcon
                                        width: parent.height*0.6
                                        height: parent.height*0.6
                                        anchors.centerIn: parent
                                        source: "../images/ic_send_black_48dp.png"
                                        opacity: sendMouseArea.enabled? 0.6: 0.3
                                        showOverlay: app.isDarkMode
                                    }

                                    MouseArea {
                                        id: sendMouseArea
                                        anchors.fill: parent
                                        enabled: AppFramework.network.isOnline && isReady
                                        onClicked: {
                                            tempIndex = index;
                                            tempId = id;
                                            send(index);
                                        }
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
        source: header
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

    function send(index){
        app.isFromSaved = true
        app.isFromSend = true
        app.isShowCustomText = true;
        app.currentEditedSavedIndex = app.savedReportsModel.get(index).id;
        app.currentObjectId = -1;

        var finalJSONEdits = JSON.parse(app.savedReportsModel.get(index).editsJson);
        var attachements = JSON.parse(app.savedReportsModel.get(index).attachements);
        featureServiceManager.url = app.savedReportsModel.get(index).featureLayerURL;
        featureServiceManager.applyEdits(finalJSONEdits, function(objectId, message){
            if(objectId===-1){
                stackView.showResultsPage();
                app.featureServiceStatusString = errorMsg
                app.theFeatureEditingAllDone = true
                app.theFeatureEditingSuccess = false
            } else if(objectId === -498){
                if(app.isNeedGenerateToken){
                    serverDialog.isReportSubmit = true;
                    serverDialog.submitFunction = submitReport;
                    serverDialog.handleGenerateToken();
                    app.isNeedGenerateToken = false;
                } else {
                    featureServiceManager.token = app.token;
                    app.isNeedGenerateToken = true;
                    send(index)
                }
            } else{
                stackView.showResultsPage();
                app.featureServiceStatusString = reportSuccessMsg;
                app.currentObjectId = objectId;

                if(attachements.length>0){
                    var sentAttachmentCount = 0;

                    for(var i=0;i<attachements.length;i++){
                        temp = attachements[i] + "";
                        var tempstring = attachements[i]+"";
                        featureServiceManager.addAttachment(tempstring, objectId, function(errorcode, message, fileIndex){
                            if(errorcode===0){
                                //app.featureServiceStatusString += "<br>" + photoSuccessMsg + (fileIndex+1)
                                sentAttachmentCount++;
                                if(sentAttachmentCount==attachements.length)
                                {
                                    app.featureServiceStatusString += "<br>";
                                    app.theFeatureEditingAllDone = true
                                    app.theFeatureEditingSuccess = app.theFeatureEditingSuccess||true
                                    if(app.theFeatureEditingSuccess === true){
                                        app.removeItemFromSavedReportPage(tempId, tempIndex, attachements);
                                    }
                                }
                            }else{
                                app.featureServiceStatusString = "<br>" + photoFailureMsg + (fileIndex+1)
                                sentAttachmentCount++;
                                if(sentAttachmentCount==attachements.length){
                                    app.featureServiceStatusString += "<br>";
                                    app.theFeatureEditingAllDone = true
                                    app.theFeatureEditingSuccess = app.theFeatureEditingSuccess||false
                                }
                            }
                        }, i);
                    }
                } else{
                    app.featureServiceStatusString += "<br>";
                    app.theFeatureEditingAllDone = true;
                    app.theFeatureEditingSuccess = true;
                    if(app.theFeatureEditingSuccess === true){
                        app.removeItemFromSavedReportPage(tempId, tempIndex, attachements);
                    }
                }
            }

        });

    }

    function edit(index){
        app.isFromSaved = true
        app.currentEditedSavedIndex = app.savedReportsModel.get(index).id;
        clearData()
        var attachements = JSON.parse(app.savedReportsModel.get(index).attachements);
        var attributes = JSON.parse(app.savedReportsModel.get(index).attributes);
        var pickListIndex = JSON.parse(app.savedReportsModel.get(index).pickListIndex);

        app.pickListIndex = pickListIndex;

        for(var i=0;i<attachements.length;i++){
            var tempAttachment = attachements[i];
            var array = tempAttachment.split(".");
            var suffix = array[array.length-1].toLowerCase();

            if(suffix == "jpg" || suffix == "jpeg" || suffix == "png" || suffix == "bmp") app.appModel.append({path: "file:///" + attachements[i], type: "attachment"});
            else {
                var fileInfo = AppFramework.fileInfo(attachements[i]);
                var fileFolderName = fileInfo.folder.folderName;
                if(fileFolderName === "Video") app.appModel.append({path: attachements[i], type: "attachment2"});
                else app.appModel.append({path: attachements[i], type: "attachment3"});
            }
        }

        app.attributesArray = attributes;
        var editsJson = JSON.parse(app.savedReportsModel.get(index).editsJson)

        if(app.savedReportsModel.get(index).xmax){
            console.log(JSON.stringify(app.savedReportsModel.get(index)));

            var spartialJsonForEnvelope = editsJson[0].geometry.spatialReference;
            var wkid = spartialJsonForEnvelope.wkid;
            var spatialReference = ArcGISRuntimeEnvironment.createObject("SpatialReference", {wkid:wkid});

            var xMax = app.savedReportsModel.get(index).xmax;
            var xMin = app.savedReportsModel.get(index).xmin;
            var yMax = app.savedReportsModel.get(index).ymax;
            var yMin = app.savedReportsModel.get(index).ymin;

            var ext = ArcGISRuntimeEnvironment.createObject("Envelope", {xMax:xMax, xMin:xMin, yMax:yMax, yMin:yMin, spatialReference: spatialReference});

            console.log("Extent", JSON.stringify(ext.json))
            app.centerExtent = ext;
        } else {
            app.centerExtent = null;
        }

        if(app.savedReportsModel.get(index).realValue){
            app.measureValue = app.savedReportsModel.get(index).realValue;
        } else {
            app.measureValue = 0;
        }

        app.savedReportLocationJson = editsJson[0].geometry;
        app.init()

    }

    function isValidGeometry(index){
        var editsJson = JSON.parse(app.savedReportsModel.get(index).editsJson);
        if(editsJson[0].geometry.paths){
            if(editsJson[0].geometry.paths[0])return editsJson[0].geometry.paths[0].length>1;
            else return false;
        } else if(editsJson[0].geometry.rings){
            if(editsJson[0].geometry.rings[0]) return editsJson[0].geometry.rings[0].length>3;
            else return false;
        } else {
            return true;
        }
    }

    function detailText(hasAttachments, numberOfAttachment, size, date){
        var resText = "";
        if(hasAttachments){
            resText += numberOfAttachment + (numberOfAttachment===1?qsTr(" file "):qsTr(" files "));
            resText += numberOfAttachment>0? (" - "+(size < 0.0001 ? "0.01" : size) + " MB"):"";
            resText += " - "
        }
        resText += date;
        return resText;
    }

    ConfirmBox{
        id: confirmBox
        anchors.fill: parent
        onAccepted: {
            var attachments = JSON.parse(app.savedReportsModel.get(tempIndex).attachements);
            app.removeItemFromSavedReportPage(tempId, tempIndex, attachments);
        }
    }

    function back(){
        if(confirmBox.visible === true){
            confirmBox.visible = false
        } else {
            app.updateSavedReportsCount();
            previous("")
        }
    }
}
