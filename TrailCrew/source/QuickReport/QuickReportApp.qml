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

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1

import QtPositioning 5.3
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2

import QtQuick.Controls.Material 2.1 as MaterialStyle

import "controls"
import "pages"

App {
    id: app
    width: 421
    height: 750

    function units(value) {
        return AppFramework.displayScaleFactor * value
    }

    property int scaleFactor: AppFramework.displayScaleFactor

    property bool isSmallScreen: (width || height) < units(550)
    property bool isPortrait: app.height > app.width

    property bool featureServiceInfoComplete : false
    property bool featureServiceInfoErrored : false
    property bool initializationCompleted: true

    property int steps: -1
    property int savedReportsCount: 0
    property string token: ""
    property var expiration
    property string webMapRootUrl: "http://www.arcgis.com/home/item.html?id="

    //check ready for submitting for saved draftSaveDialog:
    property bool isReadyForAttachments: false
    property bool isReadyForGeo: false
    property bool isReadyForDetails: false
    property bool isReadyForSubType: true
    property bool isReadyForSubmitReport: isReadyForAttachments && isReadyForGeo && isReadyForDetails && isReadyForSubType

    function updateSavedReportsCount() {
        var count = 0;
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT COUNT(*) AS TOTAL FROM DRAFTS;');
            count = rs.rows.item(0).TOTAL
        })
        savedReportsCount = count;
    }

    property bool isOnline: AppFramework.network.isOnline
    property bool isRealOnline: false
    property int configurationState

    // special flag for mmpk
    property bool mmpkSecureFlag: true

    Connections {
        target: AppFramework.network
        onConfigurationChanged:{
//            app.isReallyOnline = configuration.state===14
            app.configurationState = configuration.state
        }
    }

    onIsOnlineChanged: {
        if (isOnline && featureServiceInfoErrored){
            serviceInfoTask.fetchFeatureServiceInfo()
            featureServiceInfoErrored = false
        }
    }

    property string deviceOS: Qt.platform.os


    /* *********** CONFIG ********************* */
    property string arcGISLicenseString: app.info.propertyValue("ArcGISLicenseString","");

    //assets
    property string appLogoImageUrl: app.folder.fileUrl(app.info.propertyValue("logoImage", "template/images/esrilogo.png"))
    property string landingPageBackgroundImageURL: app.folder.fileUrl(app.info.propertyValue("startBackground", ""))
    property bool showDescriptionOnStartup : app.info.propertyValue("showDescriptionOnStartup",false);
    property bool startShowLogo : app.info.propertyValue("startShowLogo",true);
    property string loginImage : app.info.propertyValue("startButton","../images/signin.png");
    property string pickListCaption: app.info.propertyValue("pickListCaption", "Pick a type");
    property bool supportVideoRecorder: app.info.propertyValue("supportVideoRecorder", false);
    property bool supportAudioRecorder: app.info.propertyValue("supportAudioRecorder", false);
    property bool supportMedia: Qt.platform.os != "windows" && app.supportVideoRecorder

    // fonts
    property int baseFontSize: app.info.propertyValue("baseFontSize", 20)
    property string customTitleFontTTF: app.info.propertyValue("customTitleFontTTF","");
    property string customTextFontTTF: app.info.propertyValue("customTextFontTTF","")

    property int headingFontSize: 1.8 * titleFontSize
    property int titleFontSize: baseFontSize * scaleFactor * fontScale
    property int subtitleFontSize: 0.7 * titleFontSize
    property int textFontSize: 0.8 * titleFontSize
    property real fontScale: app.settings.value("fontScale", 1.0);
    property int isDarkMode: app.settings.value("isDarkMode", 0);

    //custom font if any
    property alias customTitleFont: customTitleFont
    FontLoader {
        id: customTitleFont
        source: app.folder.fileUrl(customTitleFontTTF)
    }

    property alias customTextFont: customTextFont
    FontLoader {
        id: customTextFont
        source: app.folder.fileUrl(customTextFontTTF)
    }

    //colors
    property color headerBackgroundColor: /*app.isDarkMode? "#6e6e6e":*/app.info.propertyValue("headerBackgroundColor","#00897b");
    property color headerTextColor: app.isDarkMode? "white": app.info.propertyValue("headerTextColor","white");
    property color pageBackgroundColor: app.isDarkMode? "#404040":app.info.propertyValue("pageBackgroundColor","#EBEBEB");
    property color buttonColor: /*isDarkMode? "#969696":*/ app.info.propertyValue("buttonColor","orange");
    property color textColor: app.isDarkMode? "white": app.info.propertyValue("textColor","white");
    property color titleColor: app.isDarkMode? "white": app.info.propertyValue("titleColor","white");
    property color subtitleColor: app.isDarkMode? "white": app.info.propertyValue("subtitleColor","#4C4C4C");

    //layers
    property string featureServiceURL: app.info.propertyValue("featureServiceURL","")
    property string featureLayerId: app.info.propertyValue("featureLayerId","")
    property string featureLayerName: app.info.propertyValue("featureLayerName","")
    property string featureLayerURL: featureServiceURL + "/" + featureLayerId
    property string baseMapURL: app.info.propertyValue("baseMapServiceURL","")
    property bool allowPhotoToSkip: app.info.propertyValue("allowPhotoToSkip",true)
    property string webMapID: app.info.propertyValue("webMapID","")
    property string offlineMMPKID: app.info.propertyValue("offlineMMPKID","")
    property string logoUrl: app.info.propertyValue("logoUrl","")

    //feedback
    property string websiteUrl: app.info.propertyValue("websiteUrl","")
    property string websiteLabel: app.info.propertyValue("websiteLabel", "")
    property string phoneNumber : app.info.propertyValue("phoneNumber","")
    property string phoneLabel: app.info.propertyValue("phoneLabel", "")
    property string emailAddress : app.info.propertyValue("emailAddress","")
    property string emailLabel: app.info.propertyValue("emailLabel", "")
    property string socialMediaUrl : app.info.propertyValue("socialMediaUrl","")
    property string socialMediaLabel : app.info.propertyValue("socialMediaLabel","")
    property string disclaimerMessage: app.info.licenseInfo
    property string helpPageUrl: app.info.propertyValue("reportHelpUrl", "")
    property string thankyouMessage: app.info.propertyValue("thankyouMessage", "")


    // property checks
    property bool isPhoneAvailable: {
        if (phoneNumber > "") {
            footerModel.append({"name":phoneLabel, "type": "phone", "value":phoneNumber, "icon": "../images/ic_phone_white_48dp.png"})
            return true
        } else {
            return false
        }
    }

    property bool isEmailAvailable: {
        if (emailAddress > "") {
            footerModel.append({"name":emailLabel, "type": "email", "value":emailAddress, "icon": "../images/ic_drafts_white_48dp.png"})
            return true
        } else {
            return false
        }
    }

    property bool isWebUrlAvailable: {
        if (websiteUrl > "") {
            footerModel.append({"name":websiteLabel, "type": "link", "value":websiteUrl, "icon": "../images/ic_public_white_48dp.png"})
            return true
        } else {
            return false
        }
    }

    property bool isSocialMediaUrlAvailable: {
        if (socialMediaUrl > "") {
            footerModel.append({"name":socialMediaLabel, "type": "link", "value":socialMediaUrl, "icon": "../images/ic_public_white_48dp.png"})
            return true
        } else {
            return false
        }
    }

    property bool isHelpUrlAvailable: helpPageUrl > ""
    property bool isLandingPageBackgroundImageAvailable: landingPageBackgroundImageURL > ""
    property bool isDisclamerMessageAvailable: checkEmptyText(disclaimerMessage)
    function checkEmptyText(text) {
        var cleanText = text.replace(/<\/?[^>]+(>|$)/g, "");
        cleanText = cleanText.trim();
        return cleanText>""
    }
    //Attributes
    property var attributesArray
    property var attributesArrayCopy
    property var savedReportLocationJson

    //Security
    property string username: rot13(app.settings.value("username",""))
    property string password: rot13(app.settings.value("password",""))
    property string signInType: app.info.propertyValue("signInType", "none")

    /* *********** DOMAINS AND SUBTYPES ********************* */

    property variant domainValueArray: []
    property variant domainCodeArray: []

    property variant subTypeCodeArray: []
    property variant subTypeValueArray: []

    property variant domainRangeArray: []
    property variant delegateTypeArray:[]

    property var protoTypesArray: []
    property var protoTypesCodeArray: []

    property variant networkDomainsInfo

    property bool hasSubtypes: false
    property bool hasSubTypeDomain: false

    property var featureTypes
    property var featureType

    property var selectedFeatureType
    property var fields: []
    property var fieldsMassaged:[]
    property var typeIdField

    property int pickListIndex: -1
    property bool isFromSaved: false
    property bool isFromSend: false
    property var currentEditedSavedIndex
    property bool isShowCustomText: true

    property int counts: 0
    property var datas: []

    //-------------------- Setup for the App ----------------------

    property string selectedImageFilePath: ""
    property string selectedImageFilePath_ORIG: ""
    property bool selectedImageHasGeolocation: false
    property var currentAddedFeatures : []

    property string featureServiceStatusString: "Working on it ..."
    property bool hasAttachment: false
    property bool hasType: false

    property var theFeatureToBeInsertedID: null
    property var theFeatureSucessfullyInsertedID: null
    property bool theFeatureEditingAllDone: false
    property bool theFeatureEditingSuccess: false
    property int theFeatureServiceWKID: -1
    property SpatialReference theFeatureServiceSpatialReference

    property string reportSubmitMsg: qsTr("Submitting the report")
    property string reportSuccessMsg: qsTr("Submitted successfully.")
    property string errorMsg: qsTr("Sorry there was an error!")
    property string photoSizeMsg: qsTr("Photo size is ")
    property string photoAddMsg: qsTr("Adding photo to draft: ")
    property string photoSuccessMsg: qsTr("Photo added successfully: ")
    property string photoFailureMsg: qsTr("Sorry could not add photo: ")
    property string videoFailureMsg: qsTr("Sorry could not add video")
    property string audioFailureMsg: qsTr("Sorry could not add audio")
    property string doneMsg: qsTr("Click Done to continue.")
    property string askToSaveMsg: qsTr("Please save as draft and submit later.")
    property string savedSuccessMessage: qsTr("Saved as draft.")
    property string resetTitle: qsTr("Do you wish to continue?")
    property string resetMessage: qsTr("This will erase all saved drafts, offline map and custom app settings from this device.")
    property string logoutTitle: qsTr("Are you sure you want to sign out?")
    property string logoutMessage: qsTr("")
    property string titleForSubmitInDraft: qsTr("Do you want to continue?")
    property string messageForSubmitInDraft: qsTr("You are about to submit this draft.") + "\n"

    property string mmpkDownloadingString: qsTr("Downloading")
    property string mmpkDownloadCompletedString: qsTr("Download completed")
    property string mmpkDownloadDialogString: qsTr("Offline map available. Download now?")
    property string mmpkUpdateDialogString: qsTr("Do you want to update offline map?")
    property string mmpkMenuDownloadString: qsTr("Download Offline Map")
    property string mmpkMenuUpdateString: qsTr("Update Offline Map")
    property string mmpkDownloadFailString: qsTr("Failed to download. Try again later.")
    property string mmpkMapDownloadSizeString: qsTr("Map download size")
    property string mmpkMapLastUpdatedString: qsTr("Last updated")
    property string mmpkSwitchToOfflineString: qsTr("Switching to offline map.")
    property string mmpkSwitchToOnlineString: qsTr("Switching to online map.")
    property string mmpkUseOfflineMapString: qsTr("Use offline Map")

    property bool skipPressed: false
    property string captureType: "point"
    property Polyline polylineObj
    property Polygon polygonObj
    property Envelope centerExtent
    property var measureValue
    property bool isReadyForSubmit: false

    property Point theNewPoint

    property var theFeatureServiceTable
    property var theFeatureLayer
    property var theFeatureAttachment

    property bool bugTestFlag: true
    property url temp

    property alias appModel:fileListModel
    property alias appModelCopy: fileListModelCopy
    property int maximumAttachments: 6
    property alias savedReportsModel: savedReportsListModel

    property var db

    property string galleryTitle: qsTr("Gallery")
    property int numOfSteps: 2 + (hasAttachment? 1 : 0) + (hasType? 1: 0)

    property alias alertBox: alertBox
    property alias serverDialog: serverDialog
    property alias draftSaveDialog: draftSaveDialog

    property alias mmpkManager: mmpkManager
    property alias calendarDialogComponent: calendarDialogComponent
    property var calendarPicker

    property var currentObjectId: -1

    focus: true

    Keys.onReleased: {
        event.accepted = true
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape){
            if(confirmBox.visible === true){
                confirmBox.visible = false
            } else if(alertBox.visible === true){
                alertBox.visible = false;
            } else if(serverDialog.visible === true){
                serverDialog.visible = false;
            } else{
                stackView.currentItem.back();
            }
        }
    }
    property bool isNeedGenerateToken: false

    ListModel{
        id: fileListModel
    }

    ListModel{
        id: fileListModelCopy
    }

//    Graphic {
//        id: selectedGraphic
//        geometry: Point {
//            x: 0
//            y: 0
//            spatialReference: SpatialReference {
//                wkid: 102100
//            }
//        }
//    }
//    property alias selectedGraphic: selectedGraphic

    Component.onCompleted: {
        initDBTables();
//        ArcGISRuntimeEnvironment.license.setLicense(arcGISLicenseString);
//        ArcGISRuntimeEnvironment.identityManager.ignoreSslErrors = true;

        attributesArray = {};
        updateSavedReportsCount();
        copyLocalFile();

        app.token = app.settings.value("token", "");
        app.expiration = app.settings.value("expiration", "");
    }

    function copyLocalFile(){
        var path = AppFramework.userHomeFolder.filePath("ArcGIS/AppStudio/Data");
        var arr = helpPageUrl.split("/");
        AppFramework.userHomeFolder.makePath(path);
        var resourceFolderName = arr[0];
        var resourceFileName = arr[1];
        var resourceFolder = AppFramework.fileFolder(app.folder.folder(resourceFolderName).path);
        var outputFolder = AppFramework.fileFolder(path);
        var outputLocation = path + "/" + resourceFileName;
        outputFolder.removeFile(resourceFileName);
        resourceFolder.copyFile(resourceFileName, outputLocation);
    }

    function rot13(s) {
        return s.replace(/[A-Za-z]/g, function (c) {
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".charAt(
                        "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm".indexOf(c)
                        );
        } );
    }

    Connections {
        target: AppFramework.network
        onIsOnlineChanged: {
            isOnline = AppFramework.network.isOnline
        }
    }

    Point {
        id: pointGeometry
        x: 200
        y: 200
    }

    function initDBTables(){
        var dbname = app.info.itemId;
        db = LocalStorage.openDatabaseSync(dbname, "1.0", "Unsent Reports", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS DRAFTS(id INTEGER, pickListIndex INTEGER, size INTEGER, nameofitem TEXT, editsjson TEXT, attributes TEXT, date TEXT, attachements TEXT, featureLayerURL TEXT)');
        });
    }

    function submitReport(){
        app.focus = true;
        isShowCustomText = true
        app.currentObjectId = -1;

        var geometryForFeatureToEdit;
        if(captureType === "point")geometryForFeatureToEdit = app.theNewPoint;
        else if(captureType === "line")geometryForFeatureToEdit = app.polylineObj;
        else geometryForFeatureToEdit = app.polygonObj;

        var attributesToEdit = {};

        for ( var field in attributesArray) {
            if ( attributesArray[field] == "") {
                attributesToEdit[field] = null;
            } else {
                attributesToEdit[field] = attributesArray[field];
            }
        }

        if(theFeatureTypesModel.count>0) attributesToEdit[app.typeIdField] =  theFeatureTypesModel.get(pickListIndex).value;

        var finalJSONEdits = [{"attributes": attributesToEdit, "geometry":geometryForFeatureToEdit.json}]
        console.log("JSON for save feature json", JSON.stringify(finalJSONEdits))

        featureServiceManager.applyEdits(finalJSONEdits, function(objectId, message){
            if(objectId === -1){
                stackView.showResultsPage()
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
                    submitReport();
                }
            } else{
                stackView.showResultsPage()
                app.featureServiceStatusString = reportSuccessMsg;
                app.currentObjectId = objectId;
                if(app.appModel.count>0){
                    var sentAttachmentCount = 0;
                    //app.featureServiceStatusString += "<br><br>" + photoAddMsg + objectId;
                    var attachments = [];
                    for(var i=0;i<app.appModel.count;i++){

                        var type = app.appModel.get(i).type;

                        if(type == "attachment") {
                            temp = app.appModel.get(i).path;
                            app.selectedImageFilePath = AppFramework.resolvedPath(temp);
                        } else if(type == "attachment2"){
                            app.selectedImageFilePath = app.appModel.get(i).path.replace("file://","");
                        } else if(type == "attachment3"){
                            app.selectedImageFilePath = app.appModel.get(i).path.replace("file://","");
                        }

                        attachments.push(app.selectedImageFilePath);
                        featureServiceManager.addAttachment(app.selectedImageFilePath, objectId, function(errorcode, message, fileIndex){
                            if(errorcode===0){
                                //app.featureServiceStatusString += "<br>" + photoSuccessMsg + (fileIndex+1)
                                sentAttachmentCount++;
                                if(sentAttachmentCount==app.appModel.count)
                                {
                                    app.featureServiceStatusString += "<br>";
                                    app.theFeatureEditingAllDone = true
                                    app.theFeatureEditingSuccess = app.theFeatureEditingSuccess||true
                                    removeAttachments(attachments)
                                    if(app.theFeatureEditingSuccess === true && app.isFromSaved){
                                        db.transaction(function(tx) {
                                            tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
                                        })
                                    }
                                }
                            }else{
                                var type = app.appModel.get(fileIndex).type;
                                if(type === "attachment") app.featureServiceStatusString = "<br>" + photoFailureMsg + (fileIndex+1);
                                else if(type === "attachment2") app.featureServiceStatusString = "<br>" + videoFailureMsg;
                                else app.featureServiceStatusString = "<br>" + audioFailureMsg;

                                sentAttachmentCount++;
                                if(sentAttachmentCount==app.appModel.count){
                                    app.featureServiceStatusString += "<br>";
                                    app.theFeatureEditingAllDone = true
                                    app.theFeatureEditingSuccess = app.theFeatureEditingSuccess||false
                                    if(app.theFeatureEditingSuccess === true && app.isFromSaved){
                                        db.transaction(function(tx) {
                                            tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
                                        })
                                    }
                                }
                            }
                        }, i);
                    }

                } else{
                    app.featureServiceStatusString += "<br>";
                    app.theFeatureEditingAllDone = true;
                    app.theFeatureEditingSuccess = true;
                    if(app.theFeatureEditingSuccess === true && app.isFromSaved){
                        db.transaction(function(tx) {
                            tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
                        })
                    }
                }
            }

        });
    }

    FileInfo{
        id: fileInfo
    }

    ExifInfo{
        id: exifInfo
    }

    function saveReport(){
        app.focus = true;
        var savedNameofitem;
        if(app.isFromSaved){
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
                var attributes = rs.rows.item(i).attributes;
                savedNameofitem = JSON.parse(attributes)["index"];
                tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
            })
        }

        var geometryForFeatureToEdit;
        if(captureType === "point")geometryForFeatureToEdit = app.theNewPoint;
        else if(captureType === "line")geometryForFeatureToEdit = app.polylineObj;
        else geometryForFeatureToEdit = app.polygonObj;

        var attributesToEdit = {};

        for ( var field in attributesArray) {
            if ( attributesArray[field] == "") {
                attributesToEdit[field] = null;
            } else {
                attributesToEdit[field] = attributesArray[field];
            }
        }

        if(theFeatureTypesModel.count>0) attributesToEdit[app.typeIdField] =  theFeatureTypesModel.get(pickListIndex).value;
        var finalJSONEdits = [{"attributes": attributesToEdit, "geometry": geometryForFeatureToEdit.json}]
        console.log("JSON for save feature json", JSON.stringify(finalJSONEdits))

        var currentDate = new Date();
        var id = currentDate.getTime();
        var dateString = currentDate.toLocaleString(Qt.locale(),"MMM d, hh:mm AP");

        var filePaths = [];
        var size = 0;

        for(var i=0;i<app.appModel.count;i++){
            temp = app.appModel.get(i).path;
            exifInfo.load(temp.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""))
            fileInfo.filePath = exifInfo.filePath;
            size+=fileInfo.size;
            app.selectedImageFilePath = AppFramework.resolvedPath(temp);
            filePaths.push(AppFramework.resolvedPath(temp))
        }

        var count = 0;

        db.transaction(function(tx){
            var rs = tx.executeSql('SELECT * FROM DRAFTS');
            var flags = new Array(rs.rows.length);
            for(var k = 0; k < rs.rows.length; k++) {
                flags[k] = -1;
            }
            for(var i = 0; i < rs.rows.length; i++) {
                var attributes = rs.rows.item(i).attributes;
                var index = JSON.parse(attributes)["index"];
                if(index>=0)flags[index] = 1;
            }

            for (var j = 0; j < rs.rows.length; j++){
                if(flags[j] === -1){
                    count = j;
                    break;
                } else if(j === (rs.rows.length-1)){
                    count = j+1;
                }
            }
            count += 1;
        })

        var nameofitem = theFeatureTypesModel.count>0 ? theFeatureTypesModel.get(pickListIndex).label : (app.isFromSaved? "Draft "+(savedNameofitem+1): "Draft "+count);

        var xmax = app.centerExtent? app.centerExtent.xMax : null;
        var xmin = app.centerExtent? app.centerExtent.xMin : null;
        var ymax = app.centerExtent? app.centerExtent.yMax: null;
        var ymin = app.centerExtent? app.centerExtent.yMin: null;

        console.log("app.centerExtent", xmax, xmin, ymax, ymin);

        attributesArray["_xMax"] = xmax;
        attributesArray["_xMin"] = xmin;
        attributesArray["_yMax"] = ymax;
        attributesArray["_yMin"] = ymin;
        attributesArray["_realValue"] = app.measureValue? app.measureValue:0;
        attributesArray["hasAttachment"] = app.hasAttachment;
        attributesArray["isReadyForSubmit"] = app.isReadyForSubmit;
        attributesArray["index"] = app.isFromSaved?savedNameofitem:(theFeatureTypesModel.count>0? -1:count-1);

        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO DRAFTS(id, pickListIndex, size, nameofitem, editsjson, attributes, date, attachements, featureLayerURL)  VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', [id, pickListIndex, size, nameofitem, JSON.stringify(finalJSONEdits), JSON.stringify(attributesArray), dateString, JSON.stringify(filePaths), featureLayerURL.toString()]);
        })

        isShowCustomText = false

        app.featureServiceStatusString = savedSuccessMessage;
        app.theFeatureEditingAllDone = true;
        app.theFeatureEditingSuccess = true;

    }

    SimpleMarkerSymbol {
        id: markerSymbol
    }
    SimpleLineSymbol {
        id: lineSymbol
    }
    SimpleFillSymbol{
        id: fillSymbol
    }

    MapView{
        id: mapView
    }

    function initializeFeatureService(errorcode, errormessage, root, cacheName){
        if(errorcode===0){
            var typeCheck = root.type;

            if(typeCheck == "Feature Layer"){
                var capabilities = root.capabilities+"";
                var geometryType = root.geometryType;
                if(geometryType === "esriGeometryPoint"){
                    captureType = "point";
                } else if(geometryType === "esriGeometryPolyline"){
                    captureType = "line";
                } else if(geometryType === "esriGeometryPolygon"){
                    captureType = "area";
                } else {
                    initializationCompleted = true;
                    featureServiceManager.clearCache(cacheName)

                    alertBox.text = qsTr("Unable to initialize - Invalid service.");
                    alertBox.informativeText = qsTr("Please make sure the ArcGIS feature service supports") + geometryType + ".";
                    alertBox.visible = true;
                }

                if(capabilities.indexOf("Create")>-1){
                    var fields = root.fields
                    for(var i=0;i<fields.length;i++){
                        //@@@f structure not right
                        if(fields[i].editable===true && fields[i].name!=root.typeIdField) {
                            var f = fields[i];
                            app.fields.push(f);
                            fieldsMassaged.push(f);
                        }
                    }

                    var params = root.extent.spatialReference;
//                    if(root.extent.spatialReference.wkid !== null)app.theFeatureServiceSpatialReference = ArcGISRuntime.createObject("SpatialReference", {wkid: root.extent.spatialReference.wkid});
//                    else app.theFeatureServiceSpatialReference = ArcGISRuntime.createObject("SpatialReference", {wkid: app.theFeatureServiceWKID});
                    if ( root.typeIdField > ""){
                        hasSubtypes = true;
                        featureTypes = root.types;
                        app.typeIdField = root.typeIdField;
                    }else{
                        console.log("This service DOES NOT have a sub Type::");
                        initializationCompleted = true;
                    }

                    for ( var j = 0; j < fields.length; j++ ){
                        if(fields[j].editable===true){
                            var hasDomain = false;
                            var isRangeDomain = false;
                            if ( fields[j].domain !== null){
                                hasDomain = true;
                                if (fields[j].domain.objectType === "RangeDomain" ) {
                                    isRangeDomain = true
                                }
                            }

                            var isSubTypeField = false;
                            if ( fields[j].name === root.typeIdField ){
                                isSubTypeField = true;
                            }

                            var defaultFieldValue = 0;
                            theFeatureAttributesModel.append({"fieldIndex": j, "fieldName": fields[j].name, "fieldAlias": fields[j].alias, "fieldType": fields[j].fieldTypeString, "fieldValue": "", "defaultNumber": defaultFieldValue, "isSubTypeField": isSubTypeField, "hasSubTypeDomain" : false, "hasDomain": hasDomain, "isRangeDomain": isRangeDomain })
                        }
                    }

                    app.hasAttachment = root.hasAttachments;
                    console.log("app.hasAttachment", app.hasAttachment)

                    var rendererJson = root.drawingInfo;
                    var values;
                    if(rendererJson.renderer.uniqueValueInfos) {
                        values = rendererJson.renderer.uniqueValueInfos;
                        hasType = values.length>0;
                    } else {
                        values = [];
                        hasType = false;
                    }
                    var syms = [];

                    for(var i=0; i< values.length; i++) {
                        console.log("values[i].symbol",values[i].symbol)
                        if(values[i].symbol.imageData) {
                            syms.push({"data": "data:image/png;base64," + values[i].symbol.imageData, "type" :"imageData", "label": values[i].label, "value" : values[i].value.toString(), "description": values[i].description})
                            counts++;
                        } else if(values[i].symbol.type === "esriSMS") {
                            var sym = ArcGISRuntimeEnvironment.createObject("SimpleMarkerSymbol" ,{}, mapView);
                            sym.json = values[i].symbol;
                            syms.push({"data": sym, "type" :values[i].symbol.type, "label": values[i].label, "value" : values[i].value.toString(), "description": values[i].description})
                            counts++;
                        } else if(values[i].symbol.type === "esriSLS"){
                            var sym = ArcGISRuntimeEnvironment.createObject("SimpleLineSymbol" ,{}, mapView);
                            sym.json = values[i].symbol;
                            sym.width = sym.width*0.2
                            syms.push({"data": sym, "type" :values[i].symbol.type, "label": values[i].label, "value" : values[i].value.toString(), "description": values[i].description})
                            counts++;
                        } else if(values[i].symbol.type === "esriSFS"){
                            var sym = ArcGISRuntimeEnvironment.createObject("SimpleFillSymbol" ,{}, mapView);
                            sym.json = values[i].symbol;
                            syms.push({"data": sym, "type" :values[i].symbol.type, "label": values[i].label, "value" : values[i].value.toString(), "description": values[i].description})
                            counts++;
                        }
                    }

                    app.countsChanged.connect(function(){
                        if(counts==0) {
                            theFeatureTypesModel.clear();
                            datas.forEach(function(e){
                                if(e.type === "swatch"){
                                    theFeatureTypesModel.append({"label": e.label, "value" : e.value.toString(), "description": e.description, "imageUrl": Qt.resolvedUrl(e.data)});
//                                    listModel.append({"sourceImg": Qt.resolvedUrl(e.data)});
                                } else {
                                    theFeatureTypesModel.append({"label": e.label, "value" : e.value.toString(), "description": e.description, "imageUrl": e.data});
//                                    listModel.append({"sourceImg": e.data});
                                }
                            })
                            initializationCompleted = true;
                        }
                    });

                    syms.forEach(function(e, index){
                        if(e.type === "imageData"){
                            datas[index] = {"data": e.data, "index": index, "type": "imageData", "label": e.label, "value" : e.value.toString(), "description": e.description};
                            counts--;
                        } else {
                            e.data.swatchImageChanged.connect(function(){
                                console.log("e.data.swatchImage.toString()",e.data.swatchImage.toString())
                                datas[index] = {"data": e.data.swatchImage.toString(), "index": index, "type": "swatch", "label": e.label, "value" : e.value.toString(), "description": e.description};
                                counts--;
                            });
                            e.data.createSwatch();
                        }
                    });

                    if(app.isFromSaved) {
                        checkReadyForSubmitReport();
                    }
                    if (app.isDisclamerMessageAvailable && (!app.isFromSaved)) {
                        stackView.push(disclamerPage)
                    } else {
                        if(hasSubtypes)stackView.showPickTypePage(false);
                        else stackView.showRefineLocationPage(false);
                    }

                } else {
                    initializationCompleted = true;
                    featureServiceManager.clearCache(cacheName)
                    alertBox.text = qsTr("Unable to initialize - Insufficient capability.");
                    alertBox.informativeText = qsTr("Please make sure the ArcGIS feature service is editable.");
                    alertBox.visible = true;
                }
            } else{
                initializationCompleted = true;
                featureServiceManager.clearCache(cacheName)
                alertBox.text = qsTr("Unable to initialize - Invalid service.");
                alertBox.informativeText = qsTr("Please make sure you have configured a valid ArcGIS feature service url.");
                alertBox.visible = true;
            }
        } else {
            initializationCompleted = true;
            if(errorcode===3){
                alertBox.text = qsTr("Unable to initialize - Network not available.")
                alertBox.informativeText = qsTr("Turn off airplane mode or use wifi to access data.");
                alertBox.visible = true;
            } else if(errorcode === 499){
                if(app.isNeedGenerateToken){
                    serverDialog.visible = true
                } else {
                    initializationCompleted = false;
                    featureServiceManager.token = app.token;
                    featureServiceManager.getSchema(null, null, app.initializeFeatureService)
                    app.isNeedGenerateToken = true;
                }
            }else{
                alertBox.text = qsTr("Sorry, something went wrong.")
                alertBox.informativeText = errorcode + " - " + errormessage;
                alertBox.visible = true;
            }
        }
    }

    FeatureServiceManager{
        id: featureServiceManager
    }

    MmpkManager{
        id: mmpkManager
        itemId: app.offlineMMPKID
    }

    ListModel {
        id: theFeatureTypesModel
    }

    ListModel {
        id: theFeatureAttributesModel
    }

    VisualItemModel  {
        id: theFeatureAttributesVisualModel
    }

    ListModel{
        id: savedReportsListModel
    }

    //--------------------------------

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: landingPage

        function showLandingPage() {
            stackView.clear()
            push(stackView.initialItem)
            clearData()
            steps = -1;
            updateSavedReportsCount()
        }

        function showMapPage() {
            steps++;
            push({item: mapPage});
        }
        function showAddPhotoPage(flag) {
            if (flag === undefined) {
                flag = false;
            }
            steps++;
            if(isFromSaved){
                appModelCopy.clear();
                for(var i =0; i < appModel.count; i++){
                    appModelCopy.append(appModel.get(i));
                }
            }
            push({item: addPhotoPage, replace: flag})
        }
        function showRefineLocationPage(flag){
            if (flag === undefined) {
                flag = false;
            }
            steps++;
            push({item: refineLocationPage, replace: flag})
        }
        function showAddDetailsPage(){
            steps++;
            attributesArrayCopy = JSON.parse(JSON.stringify(attributesArray));
            push({item: addDetailsPage})
        }
        function showResultsPage() {
            app.featureServiceStatusString = ""
            push({item: resultsPage})
        }

        function showPickTypePage(flag){
            if (flag === undefined) {
                flag = false;
            }
            steps++;
            push({item: pickTypePage, replace: flag})
        }
    }

    //--------------------------------

    function clearData(){
        captureType = "point";
        polylineObj = null;
        polygonObj = null;
        centerExtent = null;

        savedReportLocationJson = null;

        measureValue = 0;

        featureServiceStatusString = "Working on it ..."
        initializationCompleted = true
        fileListModel.clear();
        attributesArray = {}

        domainValueArray=[]
        domainCodeArray=[]

        subTypeCodeArray=[]
        subTypeValueArray=[]

        domainRangeArray=[]
        delegateTypeArray=[]

        protoTypesArray=[]
        protoTypesCodeArray=[]

        networkDomainsInfo = null

        hasSubtypes=false
        hasSubTypeDomain=false

        featureTypes=null
        featureType=null

        selectedFeatureType=null
        fields=[]
        fieldsMassaged=[]

        pickListIndex=-1

        hasAttachment = false
        isReadyForSubmit = false

        selectedImageFilePath = ""
        selectedImageFilePath_ORIG = ""
        selectedImageHasGeolocation = false
        currentAddedFeatures = []

        theFeatureToBeInsertedID = null
        theFeatureSucessfullyInsertedID = null
        theFeatureEditingAllDone = false
        theFeatureEditingSuccess = false
        theFeatureServiceWKID = -1

        skipPressed = false
    }

    //--------------------------------

    function initSavedReportsPage(){
        initSavedReportsData(1)
        stackView.push(savedReportsPage);
    }

    function initSavedReportsData(order){                   //order: -1 - last recent first; 1 - last recent last
        savedReportsListModel.clear();
        db.transaction(function(tx) {
            //tx.executeSql('CREATE TABLE IF NOT EXISTS DRAFTS(id INTEGER, pickListIndex INTEGER, size INTEGER, nameofitem TEXT, editsjson TEXT, attributes TEXT, date TEXT, attachements TEXT, featureLayerURL TEXT)');
            var rs = tx.executeSql('SELECT * FROM DRAFTS');
            for(var i = 0; i < rs.rows.length; i++) {
                var obj;
                var id = rs.rows.item(i).id;
                var editsJson = rs.rows.item(i).editsjson;
                var attributes = rs.rows.item(i).attributes;
                var date = rs.rows.item(i).date;
                var attachements = rs.rows.item(i).attachements;
                var featureLayerURL = rs.rows.item(i).featureLayerURL;
                var nameofitem = rs.rows.item(i).nameofitem;
                nameofitem = (nameofitem === null? "Default Type": nameofitem)
                var size = rs.rows.item(i).size;
                var pickListIndex = rs.rows.item(i).pickListIndex;
                var xmax = JSON.parse(attributes)["_xMax"];
                var xmin = JSON.parse(attributes)["_xMin"];
                var ymax = JSON.parse(attributes)["_yMax"];
                var ymin = JSON.parse(attributes)["_yMin"];
                var realValue = JSON.parse(attributes)["_realValue"];
                var hasAttachments = JSON.parse(attributes)["hasAttachment"]==null? true:JSON.parse(attributes)["hasAttachment"];
                var isReady = JSON.parse(attributes)["isReadyForSubmit"]==null? true:JSON.parse(attributes)["isReadyForSubmit"];

                if(order === 1){
                    savedReportsListModel.append({id: id, attributes:attributes, pickListIndex: pickListIndex, featureLayerURL: featureLayerURL, attachements: attachements, editsJson: editsJson, name: "Report "+i, type: nameofitem, date: date, size: (size/1024/1024).toFixed(2), numberOfAttachment: JSON.parse(attachements).length,
                                 xmax:xmax, xmin:xmin, ymax:ymax, ymin:ymin, realValue:realValue, hasAttachments:hasAttachments, isReady:isReady})
                } else {
                    savedReportsListModel.insert(0, {id: id, attributes:attributes, pickListIndex: pickListIndex, featureLayerURL: featureLayerURL, attachements: attachements, editsJson: editsJson, name: "Report "+i, type: nameofitem, date: date, size: (size/1024/1024).toFixed(2), numberOfAttachment: JSON.parse(attachements).length,
                                 xmax:xmax, xmin:xmin, ymax:ymax, ymin:ymin, realValue:realValue, hasAttachments:hasAttachments, isReady:isReady})
                }
            }
        })
    }

    Component {
        id: tempListModel
        ListModel {
        }
    }

    function reverseSavedReportData(){
        var t = tempListModel.createObject(parent);
        var count = savedReportsListModel.count;
        for (var i=0; i<count; i++){
            var obj = savedReportsListModel.get(count-i-1);
            t.append(obj);
        }
        savedReportsListModel.clear();
        for(var j=0;j<t.count;j++){
            savedReportsListModel.append(t.get(j));
        }
    }

    function deleteReportFromDatabase(){
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', app.currentEditedSavedIndex)
        })
    }

    function removeItemFromSavedReportPage(id, index, attachments){
        removeAttachments(attachments);
        var t = tempListModel.createObject(parent);
        var count = savedReportsListModel.count;
        for (var i=0; i<count; i++){
            var obj = savedReportsListModel.get(i);
            t.append(obj);
        }
        savedReportsListModel.clear();
        for(var j=0;j<t.count;j++){
            savedReportsListModel.append(t.get(j));
        }
        savedReportsListModel.remove(index)
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', id)
        })
        updateSavedReportsCount();
    }

    function removeAttachments(attachments){
        var fileFolder = AppFramework.fileFolder(AppFramework.userHomePath);
        for(var i in attachments){
            fileFolder.removeFile(attachments[i]);
        }
    }

    function deleteFeature(objectId) {
        featureServiceManager.deleteFeature(objectId, function(responseText){
            app.currentObjectId = -1;
        });
    }

    function removeAllSavedReport(){
        var allAttachments = [];
        db.transaction(function(tx) {
            //tx.executeSql('CREATE TABLE IF NOT EXISTS DRAFTS(id INTEGER, pickListIndex INTEGER, size INTEGER, nameofitem TEXT, editsjson TEXT, attributes TEXT, date TEXT, attachements TEXT, featureLayerURL TEXT)');
            var rs = tx.executeSql('SELECT * FROM DRAFTS');
            for(var i = 0; i < rs.rows.length; i++) {
                var attachements = JSON.parse(rs.rows.item(i).attachements);
                for(var j=0; j < attachements.length; j++){
                    allAttachments.push(attachements[j]);
                }
            }
            tx.executeSql('DELETE FROM DRAFTS');
        })
        removeAttachments(allAttachments);
        savedReportsListModel.clear();
        savedReportsCount = 0;
    }

    function checkReadyForGeo(){
        var isValidGeo = false;

        try {
            if(captureType === "point"){
                if(app.savedReportLocationJson.x && app.savedReportLocationJson.y) isValidGeo = true;
            } else if(captureType === "line"){
                var path = app.savedReportLocationJson.paths[0];
                if(path){
                    var pathLength = path.length;
                    if(pathLength>=2) {
                        if(path[0][0] === path[1][0] && path[0][1] === path[1][1] && pathLength===2) isValidGeo = false;
                        else isValidGeo = true;
                    }
                }
            } else if(captureType === "area"){
                var ring = app.savedReportLocationJson.rings[0];
                if(ring){
                    var ringLength = ring.length;
                    if(ringLength>=4) isValidGeo = true
                }
            }
        } catch(e) {
            isValidGeo = false;
        }

        isReadyForGeo = isValidGeo;
        console.log("isReadyForGeo:::", isReadyForGeo);
        console.log("isReadyForSubmitReport:::", isReadyForSubmitReport);
        initGeometryForSavedReport();
    }

    function checkReadyForDetails(){
        isReadyForDetails = true;
        for(var i=0;i<fieldsMassaged.length;i++){
            var obj = fieldsMassaged[i]
            if(obj["nullable"]==false){
                if ( attributesArray[obj["name"]] == "") {
                    isReadyForDetails = false;
                    break;
                }
            }
        }
    }

    function checkReadyForAttachments(){
        isReadyForAttachments = app.allowPhotoToSkip? true: (app.appModel.count>0);
    }

    function checkReadyForSubmitReport(){
        checkReadyForGeo();
        checkReadyForDetails();
        checkReadyForAttachments();
    }

    function initGeometryForSavedReport(){
        var t = app.savedReportLocationJson;
        if(app.isFromSaved && app.savedReportLocationJson) {
            //this report might have location saved and we should use that
            var x = 0.0;
            var y = 0.0;
            var spatialReferenceJson = app.savedReportLocationJson.spatialReference;
            console.log("spartialReferenceJson", JSON.stringify(spatialReferenceJson))
            var wkid = spatialReferenceJson.wkid;
            var spatialReference = ArcGISRuntimeEnvironment.createObject("SpatialReference", {wkid:wkid});
            console.log(wkid, spatialReference.wkid);
            if(captureType === "point"){
                x = app.savedReportLocationJson.x;
                y = app.savedReportLocationJson.y;

                if (x && y) {
                    app.theNewPoint = ArcGISRuntimeEnvironment.createObject("Point", {x: app.savedReportLocationJson.x, y: app.savedReportLocationJson.y, spatialReference:spatialReference});
                    console.log("inside point", JSON.stringify(theNewPoint.json));
                }

            } else if(captureType === "line"){
                var path = app.savedReportLocationJson.paths[0];
                var polylineBuilder = ArcGISRuntimeEnvironment.createObject("PolylineBuilder", {spatialReference:spatialReference})
                if(path){
                    var pathLength = path.length;
                    var firstPoint = true;

                    var part = ArcGISRuntimeEnvironment.createObject("Part");
                    part.spatialReference = spatialReference;

                    for(var i=0; i< pathLength; i++){
                        part.addPointXY(path[i][0], path[i][1]);
                    }

                    var pCollection = ArcGISRuntimeEnvironment.createObject("PartCollection");
                    pCollection.spatialReference = spatialReference;
                    pCollection.addPart(part);
                    polylineBuilder.parts = pCollection;

                    console.log(JSON.stringify(polylineBuilder.geometry.json));
                    polylineObj = polylineBuilder.geometry;
                }

            } else if(captureType === "area"){
                var ring = app.savedReportLocationJson.rings[0];
                var polygonBuilder = ArcGISRuntimeEnvironment.createObject("PolygonBuilder", {spatialReference:spatialReference})
                if(ring){
                    var ringLength = ring.length;

                    var part2 = ArcGISRuntimeEnvironment.createObject("Part");
                    part2.spatialReference = spatialReference;

                    for(var j=0; j< ringLength-1; j++){
                        part2.addPointXY(ring[j][0], ring[j][1]);
                    }
                    var pCollection2 = ArcGISRuntimeEnvironment.createObject("PartCollection");
                    pCollection2.spatialReference = spatialReference;
                    pCollection2.addPart(part2);
                    polygonBuilder.parts = pCollection2;
                    polygonObj = polygonBuilder.geometry;
                }
            }
        }
    }

    //--------------------------------

    Component {
        id: landingPage

        LandingPage {
            onNext: {
                switch(message) {
                case "viewmap": stackView.showMapPage(); break;
                case "createnew": if(app.hasAttachment) {
                        stackView.showAddPhotoPage();
                        break;
                    } else {
                        stackView.showRefineLocationPage();
                        break;
                    }
                case "details" : stackView.showAddDetailsPage();break;
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    Component {
        id: disclamerPage

        DisclamerPage {

        }
    }

    //--------------------------------------------------------------------------
    Component {
        id: addPhotoPage
        AddPhotoPage {
            onNext: {
                stackView.showAddDetailsPage();
            }
            onPrevious: {
                stackView.pop();
                var attachments = [];
                for(var i=0; i<appModel.count; i++){
                    temp = app.appModel.get(i).path;
                    app.selectedImageFilePath = AppFramework.resolvedPath(temp);
                    attachments.push(app.selectedImageFilePath);
                }
                if(!app.isFromSaved) {
                    removeAttachments(attachments);
                    appModel.clear();
                } else {
                    appModel.clear();
                    for(var i =0; i < appModelCopy.count; i++){
                        appModel.append(appModelCopy.get(i))
                    }
                }
                if(app.isFromSaved)checkReadyForAttachments();
            }
        }
    }
    //--------------------------------------------------------------------------
    Component {
        id: refineLocationPage
        RefineLocationPage {
            onNext: {
                reloadMapTimer.stop();
                if(app.hasAttachment) {
                    stackView.showAddPhotoPage(false);
                } else {
                    stackView.showAddDetailsPage();
                }
            }
            onPrevious: {
                app.isReadyForGeo = storedReadyForGeo;
                reloadMapTimer.stop();
                stackView.pop();
//                if(app.isFromSaved)checkReadyForGeo();
            }
        }
    }

    //--------------------------------------------------------------------------
    Component {
        id: pickTypePage
        PickTypePage {
            onNext: {
                console.log("isReadyForSubmitReport:::", isReadyForSubmitReport);
                stackView.showRefineLocationPage(false);
            }
            onPrevious: {
                stackView.pop();
            }
        }
    }

    //--------------------------------------------------------------------------
    property alias addDetailsPage: addDetailsPage
    Component {
        id: addDetailsPage
        AddDetailsPage {
            onNext: {
                if(message=="submit"){
                    submitReport()
                } else{
                    draftSaveDialog.visible = true;
                }
            }
            onPrevious: {
                stackView.pop();
                attributesArray = JSON.parse(JSON.stringify(attributesArrayCopy));
                if(app.isFromSaved)checkReadyForDetails();
            }
        }
    }
    //--------------------------------------------------------------------------
    Component {
        id: resultsPage
        ResultsPage {
            onNext: {
                stackView.showLandingPage()
            }
            onPrevious: {
                stackView.pop();
            }
        }
    }
    //--------------------------------------------------------------------------
    Component {
        id: savedReportsPage

        SavedReportsPage {
            onPrevious: {
                stackView.pop()
            }
        }
    }

    //--------------------------------------------------------------------------

    Component{
        id: webPageComponent
        WebPage {
            id: webPage
            headerColor: app.headerBackgroundColor

            function generateFeedbackEmailLink() {
                var urlInfo = AppFramework.urlInfo("mailto:%1".arg(emailAddress)),
                        deviceDetails = [
                            "%1: %2 (%3)".arg(qsTr("Device OS")).arg(Qt.platform.os).arg(AppFramework.osVersion),
                            "%1: %2".arg(qsTr("Device Locale")).arg(Qt.locale().name),
                            "%1: %2".arg(qsTr("App Version")).arg(app.info.version),
                            "%1: %2".arg(qsTr("AppStudio Version")).arg(AppFramework.version),
                        ];
                urlInfo.queryParameters = {
                    "subject": "%1 %2".arg(qsTr("Feedback for")).arg(app.info.title),
                    "body": "\n\n%1".arg(deviceDetails.join("\n"))
                };
                return urlInfo.url
            }

            function openWebURL(link, title) {
                webPage.titleText = title
                webPage.transitionIn(webPage.transition.bottomUp)
                webPage.loadPage(link)
            }

            function openSectionID(link) {
                var pageURL
                if (validURL(helpPageUrl)) {
                    pageURL = helpPageUrl+"#"+link
                    webPage.transitionIn(webPage.transition.bottomUp)
                    webPage.loadPage(pageURL)
                } else {
//                    pageURL = app.folder.fileUrl(helpPageUrl)+"#"+link

                    webPage.transitionIn(webPage.transition.bottomUp)
                    webPage.loadLocalHtml(link)
                }

            }

            function validURL(str) {
                var regex = /(http|https):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/;
                if(!regex .test(str)) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }

    ListModel {
        id: footerModel

        Component.onCompleted: {
            footerModel.append({"name": "About", "type": "about", "value": "", icon:"../images/ic_info_outline_white_48dp.png"})
            footerModel.append({"name": "Settings", "type": "settings", "value": "", icon:"../images/ic_settings_white_48dp.png"})
        }
    }

    function init() {
        initializationCompleted = false;
        fieldsMassaged = [];
        theFeatureAttributesModel.clear();
        theFeatureTypesModel.clear();
        protoTypesArray = [];
        featureServiceManager.token = ""
        app.isNeedGenerateToken = false;

        featureServiceManager.url = app.featureLayerURL;
        featureServiceManager.getSchema(null, null, app.initializeFeatureService)

        skipPressed = false;
    }

    ServerDialog {
        id: serverDialog

        property bool isReportSubmit: false
        property var submitFunction

        onAccepted: {
            handleGenerateToken();
        }

        function handleGenerateToken(){
            featureServiceManager.generateToken(username, password, function(errorcode, message, details, token, expires){
                if(errorcode===0){
                    app.token = token;
                    app.expiration = expires;
                    app.settings.setValue("token",token);
                    app.settings.setValue("expiration", expires);
                    if(isReportSubmit){
                        serverDialog.visible = false;
                        submitFunction();
                    } else{
                        initializationCompleted = false;
                        app.settings.setValue("username", rot13(username));
                        app.settings.setValue("password", rot13(password));
                        clearData();
                        featureServiceManager.getSchema(null, token, app.initializeFeatureService)
                    }

                    serverDialog.isReportSubmit = false;

                } else{
                    serverDialog.errorDetails = details
                    serverDialog.errorMessage = message
                    serverDialog.visible = true;
                }
                serverDialog.busy = false;
            })
        }

    }

    AboutPage {
        id: aboutPage
    }

    SettingsPage {
        id: settingsPage
    }

    ConfirmBox{
        id: confirmBox
        anchors.fill: parent
    }

    ConfirmBox{
        id: alertBox
        anchors.fill: parent
        standardButtons: StandardButton.Ok
    }

    SaveDialog{
        id: draftSaveDialog
        anchors.fill: parent
        onAccepted: {
            saveReport();
            stackView.showLandingPage();
        }
    }

    Component {
        id: calendarDialogComponent
        CalendarDialog{
            property var attributesId

            primaryColor: app.headerBackgroundColor
            theme: app.isDarkMode? MaterialStyle.Material.Dark : MaterialStyle.Material.Light

            width: app.width*0.8
            height: Math.min(app.height*0.8, 400)
            x: (app.width - width)/2
            y: (app.height - height)/2
            visible: false
            padding: 0
            topPadding: 0
            bottomPadding: 0
            closePolicy: Popup.CloseOnEscape
        }
    }
}
