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
import QtMultimedia 5.2
import Qt.labs.folderlistmodel 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2

import "../controls"
import "../controls/SketchControl"
import "../controls/VideoRecorderControl"
import "../controls/AudioRecorderControl"
import "../"

Rectangle {
    id: rectContainer
    width: parent.width
    height: parent.height
    color: app.pageBackgroundColor

    signal next(string message)
    signal previous(string message)

    property string fileLocation: "../images/placeholder.png"
    property bool photoReady: false
    property int captureResolution: 1024

    property real lat:0
    property real lon:0

    readonly property int halfScreenWidth: (width * 0.5)*app.scaleFactor
    property string type: "appview"

    property int maxbuttonlistItems: app.maximumAttachments
    property var webPage
    property var imageEditor

    property bool hasVideoAttachment: false
    property bool hasAudioAttachment: false


    ExifInfo {
        id: page2_exifInfo
    }

    ImageObject {
        id: imageObject
    }

    function resizeImage(path) {
        console.log("Inside Resize Image: ", path)

        if (!captureResolution) {
            console.log("No image resize:", captureResolution);
            return;
        }

        var fileInfo = AppFramework.fileInfo(path);
        if (!fileInfo.exists) {
            console.error("Image not found:", path);
            return;
        }

        if (!(fileInfo.permissions & FileInfo.WriteUser)) {
            console.log("File is read-only. Setting write permission:", path);
            fileInfo.permissions = fileInfo.permissions | FileInfo.WriteUser;
        }

        if (!imageObject.load(path)) {
            console.error("Unable to load image:", path);
            return;
        }

        if (imageObject.width <= captureResolution) {
            console.log("No resize required:", imageObject.width, "<=", captureResolution);
            return;
        }

        console.log("Rescaling image:", imageObject.width, "x", imageObject.height, "size:", fileInfo.size);

        imageObject.scaleToWidth(captureResolution);

        if (!imageObject.save(path)) {
            console.error("Unable to save image:", path);
            return;
        }

        fileInfo.refresh();
        console.log("Scaled image:", imageObject.width, "x", imageObject.height, "size:", fileInfo.size);
    }

    CameraComponent{
        id: cameraWindow
        visible: false
        z: 88

        onSelect: {

            //------ RESIZE IMAGE -----
            var path = AppFramework.resolvedPath(fileName)
            resizeImage(path)
            //------ RESIZE IMAGE -----

            fileLocation = "file:///" + fileName
            app.selectedImageFilePath_ORIG = fileName
            app.selectedImageFilePath = "file:///" + fileName

            appModel.append(
                        {path: app.selectedImageFilePath.toString(), type: "attachment"}
                        )

            photoReady = true
            visualListModel.initVisualListModel();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16 * app.scaleFactor

        Rectangle {
            id: createPage_headerBar
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
                    app.steps--;
                    previous("");
                }
            }

            CarouselSteps{
                height: parent.height
                anchors.centerIn: parent
                items: app.numOfSteps
                currentIndex: app.steps
            }

            ImageButton {
                source: "../images/ic_send_white_48dp.png"
                height: 30 * app.scaleFactor
                width: 30 * app.scaleFactor
                visible: app.isFromSaved
                enabled: app.isFromSaved && app.isReadyForSubmitReport && app.isOnline
                opacity: enabled? 1:0.3
                checkedColor : "transparent"
                pressedColor : "transparent"
                hoverColor : "transparent"
                glowColor : "transparent"
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    confirmToSubmit.visible = true
                }
            }
        }

        ListModel{
            id: visualListModel

            Component.onCompleted: {
                visualListModel.initVisualListModel();
            }

            function initVisualListModel(){
                var temp;
                visualListModel.clear()
                var hasTag;
                var countVideos = 0;
                var countAudio = 0;
                for(var i=0;i<app.maximumAttachments;i++){
                    if(i<app.appModel.count){
                        temp = app.appModel.get(i);
                        var tempPath = temp.path;
                        var tempType = temp.type;
                        page2_exifInfo.load(tempPath.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""));

                        if(page2_exifInfo.gpsLongitude && page2_exifInfo.gpsLatitude) {
                            hasTag = true;
                        } else {
                            hasTag = false;
                        }
                        if(tempType === "attachment2") countVideos++;
                        if(tempType === "attachment3") countAudio++;
                        visualListModel.append({path: tempPath, type: tempType, hasTag: hasTag});
                    }else{
                        visualListModel.append({path: "", type:"placehold", hasTag: false})
                    }
                }
                hasVideoAttachment = countVideos > 0;
                hasAudioAttachment = countAudio > 0;
            }
        }

        RowLayout{
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: createPage_titleText.height
            Layout.alignment: Qt.AlignHCenter
            spacing: 5*app.scaleFactor
            Text {
                id: createPage_titleText
                text: (app.supportMedia || app.supportAudioRecorder) ? qsTr("Add Media") : qsTr("Add Photo")
                textFormat: Text.StyledText
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: app.titleFontSize
                font.family: app.customTitleFont.name
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: app.textColor
                maximumLineCount: 1
                elide: Text.ElideRight
                fontSizeMode: Text.Fit
            }

            ImageOverlay{
                Layout.preferredHeight: Math.min(36*app.scaleFactor, parent.height)*0.9
                Layout.preferredWidth: Math.min(36*app.scaleFactor, parent.height)*0.9
                anchors.left: createPage_titleText.right
                anchors.leftMargin: 5*app.scaleFactor
                anchors.bottom: createPage_titleText.bottom
                source: "../images/ic_info_outline_black_48dp.png"
                visible: app.isHelpUrlAvailable
                overlayColor: app.textColor
                showOverlay: true
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var component = webPageComponent;
                        webPage = component.createObject(rectContainer);
                        webPage.openSectionID(""+3)
                    }
                }
            }
        }

        Text {
            text: {
                var description = "";
                if(app.supportMedia && app.supportAudioRecorder) {
                    description = qsTr("Add up to %1 attachments.").arg(app.maximumAttachments) + " " + qsTr("Audio and video are limited to one each. Larger images will be resized to %1 pixels.").arg(captureResolution);
                } else if(!app.supportMedia && !app.supportAudioRecorder) {
                    description = qsTr("Add up to %1 photos.").arg(app.maximumAttachments) + " " + qsTr("Larger images will be resized to %1 pixels.").arg(captureResolution);
                } else if(app.supportMedia) {
                    description = qsTr("Add up to %1 attachments.").arg(app.maximumAttachments) + " " + qsTr("Video is limited to one. Larger images will be resized to %1 pixels.").arg(captureResolution);
                } else {
                    description = qsTr("Add up to %1 attachments.").arg(app.maximumAttachments) + " " + qsTr("Audio is limited to one. Larger images will be resized to %1 pixels.").arg(captureResolution);
                }
                return description
            }

            font.pixelSize: app.subtitleFontSize
            font.family: app.customTextFont.name
            visible: app.maximumAttachments > 1
            color: app.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            Layout.preferredWidth: Math.min(parent.width*0.80, 600*app.scaleFactor)
            horizontalAlignment: Text.AlignHCenter
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (app.supportAudioRecorder && app.supportVideoRecorder) ? 36*AppFramework.displayScaleFactor : ((!app.supportAudioRecorder && !app.supportVideoRecorder)? 56*AppFramework.displayScaleFactor : 40*AppFramework.displayScaleFactor)

            ColumnLayout{
                width: 48*app.scaleFactor

                Icon{
                    containerSize: app.units(48)
                    imageSource: "../images/camera_black.png"
                    color: app.allowPhotoToSkip?"#6e6e6e":(app.appModel.count > 0 ? "#6e6e6e": app.buttonColor)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onIconClicked: {
                        cameraWindow.visible = true;

                        // fixed the camera compete issue
                        if(Qt.platform.os === "android") {
                            cameraWindow.visible = false;
                            cameraWindow.visible = true;
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.subtitleFontSize
                    font.family: app.customTextFont.name
                    color: app.textColor
                    text: qsTr("Camera")
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.Fit
                }
            }

            ColumnLayout{
                width: 48*app.scaleFactor

                Icon{
                    containerSize: app.units(48)
                    imageSource: "../images/folder-multiple-image.png"
                    color: app.allowPhotoToSkip?"#6e6e6e":(app.appModel.count > 0 ? "#6e6e6e": app.buttonColor)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onIconClicked: {
                        if(Qt.platform.os!="android"){
                            pictureChooser.open()
                        }else{
                            androidPictureChooser.open()
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.subtitleFontSize
                    font.family: app.customTextFont.name
                    color: app.textColor
                    text: qsTr("Album")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fontSizeMode: Text.Fit
                }
            }

            ColumnLayout{
                width: 48*app.scaleFactor
                visible: Qt.platform.os != "windows" && app.supportVideoRecorder
                opacity: !rectContainer.hasVideoAttachment ? 1.0 :0.8

                Icon{
                    containerSize: app.units(48)
                    imageSource: "../images/video.png"
                    color: app.allowPhotoToSkip?"#6e6e6e":(app.appModel.count > 0 ? "#6e6e6e": app.buttonColor)
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: !rectContainer.hasVideoAttachment
                    onIconClicked: {
                        videoRecorder.visible = true;
                        if(Qt.platform.os === "android") {
                            videoRecorder.visible = false;
                            videoRecorder.visible = true;
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.subtitleFontSize
                    font.family: app.customTextFont.name
                    color: app.textColor
                    text: qsTr("Video")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fontSizeMode: Text.Fit
                }
            }

            ColumnLayout{
                width: 48*app.scaleFactor
                visible: app.supportAudioRecorder
                opacity: !rectContainer.hasAudioAttachment ? 1.0 :0.8

                Icon{
                    containerSize: app.units(48)
                    imageSource: "../images/ic_audiotrack_black_48dp.png"
                    color: app.allowPhotoToSkip?"#6e6e6e":(app.appModel.count > 0 ? "#6e6e6e": app.buttonColor)
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: !rectContainer.hasAudioAttachment
                    onIconClicked: {
                        audioRecorder.visible = true;
                    }
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.subtitleFontSize
                    font.family: app.customTextFont.name
                    color: app.textColor
                    text: qsTr("Audio")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fontSizeMode: Text.Fit
                }
            }
        }

        Rectangle{
            id:contentRect
            color: "transparent"
            Layout.preferredWidth: parent.width-16*app.scaleFactor
            Layout.maximumWidth: 600 * app.scaleFactor
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter

            clip:true

            GridView {
                id:grid
                width: parent.width
                height: parent.height
                focus: true
                visible: app.appModel.count>0
                model: visualListModel
                cellWidth: parent.width/3
                cellHeight: cellWidth*0.8

                delegate: Item {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width-16*app.scaleFactor
                        height: parent.height-16*app.scaleFactor
                        color: (type == "attachment2" || type == "attachment3") ? "#6e6e6e" : "transparent"
                        radius: 3*app.scaleFactor
                        border.color: "#80cccccc"
                        border.width: 1*app.scaleFactor

                        Image {
                            id: myIcon
                            source: type == "attachment"? path: (type == "attachment2" ? "../images/file-video.png": (type == "attachment3" ? "../images/audiobook.png" : ""))
                            width: (type == "attachment2" || type == "attachment3") ? parent.width*0.5:parent.width
                            height: (type == "attachment2" || type == "attachment3") ? parent.height*0.5:parent.height
                            fillMode: Image.PreserveAspectCrop
                            anchors.centerIn: parent
                            autoTransform: true
                            visible: source>""
                            cache: false
                            sourceSize.width: width
                            sourceSize.height: height
                        }

                        Rectangle{
                            width: 16*app.scaleFactor
                            height: 16*app.scaleFactor
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 4*app.scaleFactor
                            anchors.leftMargin: 4*app.scaleFactor
                            clip: true
                            radius: 2*app.scaleFactor
                            color: "#80ffffff"
                            visible: hasTag
                            Image{
                                id: indicatorImg
                                width: 12*app.scaleFactor
                                height: 12*app.scaleFactor
                                source: "../images/location.png"
                                anchors.centerIn: parent
                            }
                            ColorOverlay{
                                anchors.fill: indicatorImg
                                source: indicatorImg
                                color: "#6E6E6E"
                            }
                        }

                        MouseArea {
                            enabled: type == "attachment" || type == "attachment2" || type == "attachment3"
                            anchors.fill: parent
                            onClicked: {
                                if(type == "attachment"){
                                    grid.currentIndex = index;
                                    previewImageRect.source = path;
                                    previewImageRect.visible = true
                                    previewImageRect.init();
                                } else if(type == "attachment2") {
                                    grid.currentIndex = index;
                                    var videoUrl = AppFramework.fileInfo(path).url
                                    videoPreview.load(videoUrl);
                                    videoPreview.visible = true;
                                } else if(type == "attachment3") {
                                    grid.currentIndex = index;
                                    var audioUrl = AppFramework.fileInfo(path).url
                                    audioPlayer.loadSource(audioUrl);
                                    audioPlayer.visible = true;
                                }
                            }
                        }
                    }
                }
            }
        }

        CustomButton {
            id: nextButton
            buttonText: qsTr("Next")
            buttonColor: app.buttonColor
            buttonFill: app.allowPhotoToSkip? true: (app.appModel.count>0)
            buttonWidth: Math.min(parent.width*0.95, 600 * scaleFactor)
            buttonHeight: 50 * app.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.margins: 8*app.scaleFactor
            visible: app.allowPhotoToSkip? true: (app.appModel.count>0)

            MouseArea {
                anchors.fill: parent
                enabled: app.allowPhotoToSkip? true: (app.appModel.count>0)
                onClicked: {
                    next("refinelocation")
                }
                onPressedChanged: {
                    nextButton.buttonColor = pressed ?
                                Qt.darker(app.buttonColor, 1.1): app.buttonColor
                }
            }
        }
    }

    DropShadow {
        source: createPage_headerBar
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

    PreviewImage{
        id: previewImageRect
        onDiscarded: {
            console.log("grid.currentIndex", grid.currentIndex);
            app.appModel.remove(grid.currentIndex);
            visualListModel.initVisualListModel();
        }
        onEdited: {
            previewImageRect.infoPanelVisible = false;
            var component = imageEditorComponent;
            imageEditor = component.createObject(rectContainer);
            imageEditor.visible = true;
            imageEditor.workFolder = outputFolder;
            imageEditor.exif_latitude = previewImageRect.copy_latitude;
            imageEditor.exif_longtitude = previewImageRect.copy_longtitude;
            imageEditor.exif_altitude = previewImageRect.copy_altitude;

            //copy
            var pictureUrl = source;
            var pictureUrlInfo = AppFramework.urlInfo(pictureUrl);
            var picturePath = pictureUrlInfo.localFile;
            var assetInfo = AppFramework.urlInfo(picturePath);

            var outputFileName;

            var suffix = AppFramework.fileInfo(picturePath).suffix;
            var fileName = AppFramework.fileInfo(picturePath).baseName+AppFramework.createUuidString(2);
            var a = suffix.match(/&ext=(.+)/);
            if (Array.isArray(a) && a.length > 1) {
                suffix = a[1];
            }

            if (assetInfo.scheme === "assets-library") {
                pictureUrl = assetInfo.url;
            }

            outputFileName = "draft" + "-" + fileName + "." + suffix;

            var outputFileInfo = outputFolder.fileInfo(outputFileName);

            outputFolder.removeFile(outputFileName);
            outputFolder.copyFile(picturePath, outputFileInfo.filePath);

            pictureUrl = outputFolder.fileUrl(outputFileName);

            fixRotate(pictureUrl)

            imageEditor.pasteImage(pictureUrl);
        }
        onDirty: {
            app.appModel.set(grid.currentIndex, {path: source, type: "attachment"});
            visualListModel.initVisualListModel();
        }
        onRefresh: {
            visualListModel.initVisualListModel();
        }
    }

    VideoPreview {
        id: videoPreview
        anchors.fill: parent
        visible: false
        isPreviewMode: true

        onDiscard: {
            app.appModel.remove(grid.currentIndex);
            visualListModel.initVisualListModel();
            videoPreview.visible = false;
        }

        onDirty: {
            app.appModel.set(grid.currentIndex, {path: videoPath, type: "attachment2"});
            visualListModel.initVisualListModel();
        }
    }

    VideoRecorder {
        id: videoRecorder
        anchors.fill: parent
        visible: false

        onSaved: {
            appModel.append({path: AppFramework.resolvedPath(videoSavePath), type: "attachment2"})
            visualListModel.initVisualListModel();
            videoRecorder.visible = false;
        }
    }

    CustomizedAudioRecorder {
        id: audioRecorder
        visible: false

        onSaved:  {
            appModel.append({path: AppFramework.resolvedPath(audioPath), type: "attachment3"})
            visualListModel.initVisualListModel();
            audioRecorder.visible = false;
        }
    }

    CustomizedAudioPlayer {
        id: audioPlayer
        visible: false
        anchors.fill: parent

        onDiscard: {
            app.appModel.remove(grid.currentIndex);
            visualListModel.initVisualListModel();
            audioPlayer.visible = false;
        }

        onDirty: {
            app.appModel.set(grid.currentIndex, {path: audioPath, type: "attachment3"});
            visualListModel.initVisualListModel();
        }
    }

    Component {
        id: imageEditorComponent
        ImageEditor {
            anchors.fill: parent
            visible: false

            onSaved: {
                app.appModel.set(grid.currentIndex, {path: saveUrl.toString(), type: "attachment"});
                visualListModel.initVisualListModel();
                previewImageRect.visible = false;
            }
        }
    }

    Component{
        id: imageViewerComponent
        ImageViewer{
            anchors.fill: parent
            visible: false

            onSaved: {
                previewImage.source = "../images/placeholder.png";
                previewImage.source = newFileUrl;

                var path = AppFramework.resolvedPath(newFileUrl);
                var filePath = "file:///" + path
                filePath = filePath.replace("////","///");

                app.appModel.set(grid.currentIndex, {path: filePath, type: "attachment"});
                visualListModel.initVisualListModel();

            }
        }
    }

    PictureChooser {
        id: pictureChooser

        copyToOutputFolder: true

        outputFolder {
            path: "~/ArcGIS/AppStudio/Data"
        }

        Component.onCompleted: {
            outputFolder.makeFolder();
        }

        onAccepted: {
            photoReady = true;

            //------ RESIZE IMAGE -----
            var path = AppFramework.resolvedPath(app.selectedImageFilePath)
            resizeImage(path)
            //------ RESIZE IMAGE -----

            var filePath = "file:///" + path
            filePath = filePath.replace("////","///");

            appModel.append(
                        {path: filePath, type: "attachment"}
                        )

            app.selectedImageFilePath = filePath;

            visualListModel.initVisualListModel();
        }
    }

    AndroidPictureChooser {
        id: androidPictureChooser
        title: qsTr("Select Photo")

        outputFolder {
            path: "~/ArcGIS/AppStudio/Data"
        }

        Component.onCompleted: {
            outputFolder.makeFolder();
        }

        onAccepted: {
            console.log(app.selectedImageFilePath)
            photoReady = true;

            //------ RESIZE IMAGE -----
            var path = AppFramework.resolvedPath(app.selectedImageFilePath)
            resizeImage(path)
            //------ RESIZE IMAGE -----

            var filePath = "file:///" + path
            console.log("Android Path::", filePath)

            appModel.append(
                        {path: filePath.toString(), type: "attachment"}
                        )

            app.selectedImageFilePath = filePath;

            visualListModel.initVisualListModel();
        }
    }

    ConfirmBox{
        id: confirmToSubmit
        anchors.fill: parent
        standardButtons: StandardButton.Yes | StandardButton.No
        text: titleForSubmitInDraft
        informativeText: messageForSubmitInDraft
        onAccepted: {
            submitReport();
        }
    }

    FileFolder {
        id: outputFolder
        path: "~/ArcGIS/AppStudio/Data"
        Component.onCompleted: {
            try {
                makeFolder();
            } catch (e){
                console.log(e)
            }
        }
    }

    function fixRotate(url){
        page2_exifInfo.load(url);
        var o = page2_exifInfo.imageValue(ExifInfo.ImageOrientation);
        var exifOrientation = o ? o : 1;

        var exifOrientationAngle = 0;
        switch (exifOrientation) {
        case 3:
            exifOrientationAngle = 180;
            break;

        case 6:
            exifOrientationAngle = 270;
            break;

        case 8:
            exifOrientationAngle = 90;
            break;
        }

        var rotateFix = -exifOrientationAngle;

        if (rotateFix !== 0) {
            imageObject.load(url);
            imageObject.rotate(rotateFix);
            imageObject.save(url);
            exifInfo.setImageValue(ExifInfo.ImageOrientation, 1);
            exifInfo.save(url);
        }
    }

    function back(){
        if(webPage != null && webPage.visible === true){
            webPage.close();
            app.focus = true;
        } else if(imageViewer != null && imageViewer.visible === true){
            imageViewer.discardConfirmBox.visible = true;
        } else if(androidPictureChooser.visible === true){
            androidPictureChooser.close();
        } else if(cameraWindow.visible === true){
            cameraWindow.visible = false;
        } else if(previewImageRect.visible === true) {
            if(previewImageRect.renameTextField.focus){
                previewImageRect.renameTextField.focus = false;
                app.focus = true;
            }else if(previewImageRect.discardBox.visible){
                previewImageRect.discardBox.visible = false;
            }else{
                previewImageRect.visible = false;
                previewImageRect.infoPanelVisible = false;
            }
        } else {
            app.steps--;
            previous("");
        }
    }
}
