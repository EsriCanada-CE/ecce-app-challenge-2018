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
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Multimedia 1.0

import "../" as SharedControls

Page {
    id: customizedAudioPlayer

    visible: false

    property url sourceUrl
    property int audioLength: 0

    // color settings
    property color primaryColor: "#424242"
    property color backgroundColor: "white"

    // audio player properties
    property bool isRepeatOne: false
    property bool isPlaying: audio.playbackState == Audio.PlayingState
    property bool isPlayingPaused: audio.playbackState == Audio.PausedState
    property bool isPreviewMode: true

    // signal
    signal discard()
    signal dirty(var audioPath)

    //----------------------------------------------------------------------------

    Audio {
        id: audio

        loops: isRepeatOne? Audio.Infinite:1

        onStatusChanged: {
            console.log("audio status:", status);
        }

        onError: {
            console.log("audio error:", error, "errorString:", errorString, "source:", source);
        }
    }

    //----------------------------------------------------------------------------

    Rectangle {
        anchors.fill: parent
        color: primaryColor
    }

    //----------------------------------------------------------------------------

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // header
        ToolBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 50 * AppFramework.displayScaleFactor
            anchors.top: parent.top
            Material.elevation: 0
            Material.background: customizedAudioPlayer.primaryColor
            padding: 0

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4*AppFramework.displayScaleFactor
                anchors.rightMargin: 4*AppFramework.displayScaleFactor

                CustomizedToolButton {
                    id: backBtn

                    Layout.preferredHeight: parent.height
                    padding: 0
                    imageScale: 0.5
                    imageSource: "./images/ic_close_white_48dp.png"

                    onClicked: {
                        audio.stop();
                        customizedAudioPlayer.visible = false;
                    }
                }

                // title used to rename file
                Item {
                    id: titleControl

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    RowLayout {
                        height: parent.height
                        anchors.centerIn: parent
                        visible: titleLabel.text > "" && isPreviewMode

                        Label {
                            id: titleLabel
                            text: ""
                            Layout.preferredWidth: implicitWidth > titleControl.width*0.7 ? titleControl.width*0.7 : implicitWidth
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Label.ElideMiddle
                        }

                        Image {
                            Layout.preferredHeight: titleLabel.height
                            Layout.preferredWidth: titleLabel.height
                            mipmap: true
                            source: "./images/ic_edit_white_48dp.png"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            audio.stop();
                            renameDialog.openDialog(titleLabel.text);
                            renameDialog.visible = true;
                        }
                    }
                }

                CustomizedToolButton {
                    Layout.preferredHeight: parent.height
                    padding: 0
                    imageScale: 0.5
                    imageSource: isPreviewMode? "./images/delete.png" : ""
                    enabled: isPreviewMode
                    onClicked: {
                        audio.stop();
                        discard();
                    }
                }
            }
        }

        //----------------------------------------------------------------------------
        // vinylIcon with rotate animation
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                id: vinylIcon
                width: Math.min(parent.width*0.8, 230*AppFramework.displayScaleFactor)
                height: Math.min(parent.width*0.8, 230*AppFramework.displayScaleFactor)
                anchors.centerIn: parent
                mipmap: true

                source: "./images/cd.png"
            }


            NumberAnimation {
                target: vinylIcon
                property: "rotation"
                duration: 3600
                from: 0
                to: 360
                easing.type: Easing.Linear
                loops: Animation.Infinite
                running: isPlaying
            }
        }

        //----------------------------------------------------------------------------
        // slider
        RowLayout {
            Layout.preferredWidth: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text : getCurrentTime(audio.position)
                color: "white"
                leftPadding: 8*AppFramework.displayScaleFactor
                anchors.horizontalCenter: parent.verticalCenter
            }

            Slider {
                id: control

                Layout.fillWidth : true
                anchors.horizontalCenter: parent.verticalCenter

                value: audio.position
                from: 0
                to: audio.duration
                enabled: audio.seekable

                Material.accent: Material.Red

                onMoved: {
                    if(audio.seekable) audio.seek(control.value);
                }

                background: Rectangle {
                    x: control.leftPadding
                    y: control.topPadding + control.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: control.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: control.visualPosition * parent.width
                        height: parent.height
                        color: Material.color(Material.Red)
                        radius: 2
                    }
                }
            }

            Label {
                text : getRemainingTime(audio.position)
                color: "white"
                rightPadding: 8*AppFramework.displayScaleFactor
                anchors.horizontalCenter: parent.verticalCenter
            }
        }

        //----------------------------------------------------------------------------
        // footer
        ToolBar {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(parent.height/7, 70*AppFramework.displayScaleFactor)
            Material.background: primaryColor

            RowLayout{
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Math.max(30*AppFramework.displayScaleFactor, parent.width*0.15)

                CustomizedToolButton {
                    Layout.preferredHeight: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    padding: 0
                    imageScale: 0.8
                    imageSource: audio.seekable ? "./images/ic_replay_5_white_48dp.png":""
                    enabled: audio.seekable && (audio.position != 0)

                    onClicked: {
                        audio.seek(Math.max(audio.position-5000, 0))
                    }
                }

                ToolButton {
                    Layout.preferredHeight: parent.height
                    scale: 1.2
                    padding: 0

                    indicator: Item {
                        anchors.fill: parent

                        Rectangle {
                            width: parent.width
                            height: width
                            radius: width/2
                            color: "white"
                            anchors.centerIn: parent
                        }

                        Image{
                            id: doneIcon
                            width: parent.width*0.6
                            height: parent.height*0.6
                            anchors.centerIn: parent
                            source: isPlaying ? "./images/pause.png" : "./images/ic_play_arrow_black_48dp.png"
                            fillMode: Image.PreserveAspectFit
                            opacity: 0.8
                            mipmap: true
                        }

                        ColorOverlay {
                            anchors.fill: doneIcon
                            source: doneIcon
                            smooth: true
                            antialiasing: true
                            color: "red"
                        }
                    }

                    onClicked: {
                        if(isPlaying) audio.pause();
                        else audio.play();
                    }
                }

                CustomizedToolButton {
                    Layout.preferredHeight: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    padding: 0
                    imageScale: 0.8
                    imageSource: "./images/ic_repeat_one_white_48dp.png"
                    opacity: isRepeatOne? 1 : 0.2

                    onClicked: {
                        isRepeatOne = !isRepeatOne;
                    }
                }
            }
        }
    }

    //----------------------------------------------------------------------------
    // rename dialog

    SharedControls.CustomizedRenameDialog {
        id: renameDialog

        width: Math.min(400*AppFramework.displayScaleFactor, parent.width*0.8)
        x: (parent.width-width) / 2
        y: (parent.height-height) / 2

        onAccepted: {
            renameAudio(renameDialog.newName);
        }

        onRejected: {
            isNameConflict = false;
        }
    }

    //----------------------------------------------------------------------------
    // audio folder

    FileFolder{
        id: audioFolder

        path: "~/ArcGIS/QuickReport/Audio"

        Component.onCompleted: {
            makeFolder();
        }
    }

    //----------------------------------------------------------------------------

    onSourceUrlChanged: {
        try {
            var audioFileInfo = AppFramework.fileInfo(AppFramework.urlInfo(sourceUrl).localFile);
            var fileName = audioFileInfo.fileName;
            titleLabel.text = fileName;
        } catch(e) {
            titleLabel.text = "";
        }
    }

    //----------------------------------------------------------------------------

    function loadSource(actualLocation) {
        sourceUrl = actualLocation;
        audio.source = "";
        audio.source = actualLocation;
    }

    function getCurrentTime(position) {
        try {
            var s = (position / 1000) | 0
            return timeText(s);
        } catch(e) {
            return timeText(0);
        }
    }

    function getRemainingTime(position) {
        try {
            var s = ((audio.duration - position) / 1000) | 0
            return "- " + timeText(s);
        } catch(e) {
            return "- " + timeText(0);
        }
    }

    function timeText(s) {
        if (s < 0) {
            return "--:--";
        }

        var minutes = Math.floor(s / 60);
        var seconds = Math.floor(s - minutes * 60);

        function zNum(n) {
            return n < 10 ? "0" + n.toString() : n.toString();
        }

        return "%1:%2".arg(zNum(minutes)).arg(zNum(seconds));
    }

    function renameAudio(newName){
        if(sourceUrl>"") {
            try {
                var audioFileInfo = AppFramework.fileInfo(AppFramework.urlInfo(sourceUrl).localFile);
                var oldName = audioFileInfo.fileName;
                var arr = newName.split(".");

                var newFileName = "";
                if(arr.length === 2) newFileName = arr[0];

                if(!audioFolder.fileExists(newName) && newFileName > ""){
                    if(audioFolder.fileExists(oldName)) audioFolder.renameFile(oldName, newName);
                    sourceUrl = audioFolder.fileInfo(newName).url;
                    loadSource(sourceUrl);
                    renameDialog.isNameConflict = false;
                    var filePath = AppFramework.urlInfo(sourceUrl).localFile;
                    dirty(filePath);
                } else {
                    renameDialog.isNameConflict = true;
                    renameDialog.open();
                }
            } catch (e) {
                console.log("Error: failed to rename audio file.");
            }
        }
    }

    function discardAudio() {
        if(sourceUrl>"") {
            try {
                var audioFileInfo = AppFramework.fileInfo(AppFramework.urlInfo(sourceUrl).localFile);
                var fileName = audioFileInfo.fileName;
                if(audioFolder.fileExists(fileName)) audioFolder.removeFile(fileName);
                sourceUrl = "";
            } catch (e) {
                console.log("Error: failed to remove audio file.");
            }
        }
    }
}
