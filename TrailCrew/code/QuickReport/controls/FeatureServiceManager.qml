import QtQuick 2.7
import QtQuick.Controls 1.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Item {
    id: featureServiceManager

    property url url
    property string token
    property var jsonSchema

    NetworkCacheManager{
        id: networkCacheManager
        returnType: "text"
    }

    function initialize(){
        getSchema(featureServiceManager.url, featureServiceManager.token)
    }

    function getSchema(url, token, callback){
        if(typeof url !== "undefined"&& url !== null)featureServiceManager.url = url;
        if(typeof token !== "undefined"&& token !== null)featureServiceManager.token = token;

        var targetUrl = featureServiceManager.url
        var alias = targetUrl;
        var obj = {"f": "json"}
        if(typeof token !== "undefined"&& token !== null)obj.token = token;

        console.log("targetUrl", targetUrl);

        networkCacheManager.cacheJson(targetUrl, obj, alias, function(errorCode, errorMsg){
            if(errorCode === 0){
                var cacheName = Qt.md5(alias);
                console.log("cacheName", cacheName);
                var temp = networkCacheManager.readLocalJson(cacheName);
                jsonSchema = JSON.parse(temp)
                callback(0,errorMsg,jsonSchema, cacheName);
            }else{
                console.log("FSM::NM::Error:", errorCode);
                callback(errorCode, errorMsg, null ,cacheName)
            }
        })
    }

    function clearCache(cacheName){
        networkCacheManager.deleteCacheName(cacheName);
    }

    function applyEdits(attributes, callback){
        console.log("token when edits", token)
        var obj = {"adds": JSON.stringify(attributes),
            "f": "json"};


        var targetUrl = url+"/applyEdits";
        if(typeof token !== "undefined"&& token !== null && token!=="") obj.token = token;
        var component = applyEditsNetworkRequestComponent;
        var applyEditsNetworkRequest = component.createObject(parent);
        applyEditsNetworkRequest.url = targetUrl;
        applyEditsNetworkRequest.callback = function(errorcode, objectId){
            if(errorcode===0){
                console.log("objectId", objectId);
                callback(objectId, "Ready")
            } else if(errorcode===498 || errorcode===499){
                callback(-498, objectId);
            } else{
                callback(-1, objectId);
            }
        }
        applyEditsNetworkRequest.send(obj);
    }

    function addAttachment(filePath, objectId, callback, cacheI){
        console.log("objectId", objectId)
        var targetUrl = url+"/"+objectId+"/addAttachment";
        var component = addAttachmentNetworkRequestComponent;
        var addAttachmentNetworkRequest = component.createObject(parent);
        addAttachmentNetworkRequest.url = targetUrl;
        addAttachmentNetworkRequest.callback = callback;
        addAttachmentNetworkRequest.cacheI = cacheI

        var obj = {"attachment": "@"+filePath,
            "f": "json"};
        if(typeof token !== "undefined"&& token !== null && token!=="") obj.token = token;
        addAttachmentNetworkRequest.send(obj);
    }

    function deleteFeature(objectId, callback) {
        try {
            var targetUrl = url+"/deleteFeatures";

            var obj = {"objectIds": objectId,
                "f": "json"};
            if(typeof token !== "undefined"&& token !== null && token!=="") obj.token = token;

            var component = deleteFeaturesNetworkRequestComponent;
            var deleteFeaturesNetworkRequest = component.createObject(parent);
            deleteFeaturesNetworkRequest.url = targetUrl;
            deleteFeaturesNetworkRequest.callback = callback;
            deleteFeaturesNetworkRequest.send(obj);
        } catch (e) {
            console.log("Failed to delete feature: " + objectId);
        }
    }

    function generateToken(username, password, callback){
        featureServiceManager.getServiceInfo(function(errorcode, message, details, tokenUrl){
            if(errorcode===0){
                var component = generateTokenNetworkRequestComponent;
                var generateTokenNetworkRequest = component.createObject(parent);
                var targetUrl = tokenUrl
                console.log("targetUrl:::", targetUrl)
                generateTokenNetworkRequest.url = targetUrl;
                generateTokenNetworkRequest.callback = callback;
                var obj = {"username":username, "password":password, "f":"json", referer: "http://www.arcgis.com"/*, expiration:"1"*/};
                generateTokenNetworkRequest.send(obj);
            }
        })
    }

    function getServiceInfo(callback){
        var arr = url.toString().split("/arcgis/rest/");

        if(arr.length>0){
            var targetUrl = arr[0]+"/arcgis/rest/info";
            console.log("info url", targetUrl)
            var component = getServiceInfoNetworkRequestComponent;
            var getServiceInfoNetworkRequest = component.createObject(parent);
            getServiceInfoNetworkRequest.url = targetUrl;
            var obj = {"f":"json"};
            getServiceInfoNetworkRequest.callback = callback;
            getServiceInfoNetworkRequest.send(obj);
        }
    }

    Component{
        id: applyEditsNetworkRequestComponent
        NetworkRequest{
            id: applyEditsNetworkRequest

            property var callback;

            responseType: "text"
            method: "POST"

            onReadyStateChanged: {
                if (readyState === NetworkRequest.DONE ){
                    if(errorCode!=0){
                        callback(errorCode, "NetworkError");
                    }else{
                        console.log("READY", responseText)
                        var json = JSON.parse(responseText);

                        if(json.error!=null){
                            var code = json.error.code;
                            var message = json.error.message;
                            callback(code, message);
                        } else{
                            var objectId = json.addResults[0].objectId;
                            callback(0, objectId)
                        }
                    }
                }
            }
        }
    }

    Component{
        id: addAttachmentNetworkRequestComponent
        NetworkRequest {
            id: addAttachmentNetworkRequest
            method: "POST"
            responseType: "text"
            ignoreSslErrors: true

            property var callback;
            property var cacheI;

            onReadyStateChanged: {
                if (readyState === NetworkRequest.DONE) {
                    if(errorCode!=0){
                        callback(errorCode,"NetworkError")
                    }else{
                        console.log("READY2", responseText)
                        var json = JSON.parse(responseText);

                        if(json.error!=null){
                            var code = json.error.code;
                            var message = json.error.message;
                            callback(code, message, cacheI);
                        } else{
                            callback(0, "Success", cacheI)
                        }
                    }
                }
            }
        }
    }

    Component{
        id: generateTokenNetworkRequestComponent
        NetworkRequest {
            id: generateTokenNetworkRequest
            method: "POST"
            responseType: "text"
            ignoreSslErrors: true

            property var callback;

            onReadyStateChanged: {
                if (readyState === NetworkRequest.DONE) {
                    if(errorCode!=0){
                        callback(errorCode,"NetworkError","","","")
                    }else{
                        console.log("TOKEN RESPOND:", responseText)
                        var root = JSON.parse(responseText);
                        var error = root.error;
                        if(error){
                            callback(error.code,error.message,error.details, "", "");
                        } else{
                            featureServiceManager.token = root.token;
                            callback(0, "", "", root.token, root.expires)
                        }
                    }
                }
            }
        }
    }

    Component{
        id: getServiceInfoNetworkRequestComponent
        NetworkRequest {
            id: getServiceInfoNetworkRequest
            method: "POST"
            responseType: "text"
            ignoreSslErrors: true

            property var callback;

            onReadyStateChanged: {
                if (readyState === NetworkRequest.DONE) {
                    if(errorCode!=0){
                        callback(errorCode,"NetworkError","","")
                    }else{
                        console.log("Service Info:", responseText)
                        var root = JSON.parse(responseText);
                        var error = root.error;
                        if(error){
                            callback(error.code,error.message,error.details,"");
                        } else{
                            if(root.authInfo.isTokenBasedSecurity){
                                callback(0, "", "", root.authInfo.tokenServicesUrl)
                            }
                        }
                    }
                }
            }
        }
    }

    Component{
        id: deleteFeaturesNetworkRequestComponent
        NetworkRequest{
            property var callback;

            responseType: "text"
            method: "POST"
            ignoreSslErrors: true

            onReadyStateChanged: {
                if (readyState === NetworkRequest.DONE ){
                    if(errorCode === 0) {
                        callback(responseText);
                    } else {
                        console.log("ERROR"+errorCode+": Request Failed");
                    }
                }
            }
        }
    }

}
