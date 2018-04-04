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
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import Qt.labs.folderlistmodel 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1

import "../controls"
import "../controls/styles"

Item {
    id: attributesPage

    property var fieldTypesDic: {"esriFieldTypeNoType":-1, "esriFieldTypeInteger":1,  "esriFieldTypeSmallInteger":0, "esriFieldTypeDouble":5, "esriFieldTypeSingle":2, "esriFieldTypeDate":6,
     "esriFieldTypeString":7, "esriFieldTypeGeometry":11, "esriFieldTypeObjectId":8, "esriFieldTypeBlob":9, "esriFieldTypeGlobalId":10, "esriFieldTypeGuid":3, "esriFieldTypeRaster":12,
     "esriFieldTypeXML":13}

    function getfieldType(type){
        return fieldTypesDic[type];
    }

    property int numOfRequired: 0
    property var requiredAttributes
    property bool hasAllRequired: numOfRequired==Object.keys(requiredAttributes).length
    property bool isShowTextArea: false

    Component.onCompleted: {
        if(!requiredAttributes)requiredAttributes={};
        for(var i=0;i<fieldsMassaged.length;i++){
            var obj = fieldsMassaged[i]
            if(obj["nullable"]==false)numOfRequired++;
        }
    }

    ListView {
        id: listView
        clip: true
        spacing: 16* app.scaleFactor
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        model: fieldsMassaged

        property bool canSubmit: true

        delegate: Component {Loader {
                id: loader
                property string fieldName :  modelData["name"]
                property string fieldAlias : modelData["alias"]
                property bool nullableValue: modelData["nullable"]
                property var maxlength: modelData["length"]
                property int fieldType: getfieldType(modelData["type"])
                property bool hasSubTypeDomain: featureTypes?(featureTypes[pickListIndex].domains[modelData["name"]] ? true : false):false
                property bool isSubTypeField : modelData["name"] === featureServiceManager.jsonSchema.typeIdField ? true : false
                property bool hasPrototype: featureTypes?(featureTypes[pickListIndex].templates[0].prototype[modelData["name"]] > "" ? true : false):false
                property var defaultValue : hasPrototype ? featureTypes[pickListIndex].templates[0].prototype[modelData["name"]] : fieldType == Enums.FieldTypeText ? "" : null
                //property string defaultDate : hasPrototype && fieldType == Enums.FieldTypeDate ? getDateValue() : ""
                property string defaultDate : hasPrototype && fieldType == Enums.FieldTypeDate ? defaultValue : ""
                property int defaultIndex
                property var rangeArray: []
                property var codedNameArray : []
                property var codedCodeArray: []
                property int domainTypeIndex: 0
                property var domainTypeArray
                property var functionArray

                width: listView.width

                sourceComponent: (function(){
                    var temp = (app.isFromSaved || app.attributesArray[fieldName]>"")? app.attributesArray[fieldName]:defaultValue;
                    attributesArray[fieldName] = temp==null? "":temp;
                    domainTypeArray = {
                        0: editControl,
                        1: rangeControl,
                        3: cvdControl,
                        99: subTypeCvdControl
                    }

                    functionArray = {
                        0: getEditControlValues,
                        1: getRangeDomainValues,
                        3: getAtrributeDomainValues,
                        99: getSubTypeAtrributeDomainValues
                    }

                    //Get the SubType Attribute codes
                    if ( isSubTypeField ) {
                        if ( modelData["domain"]) {
                            domainTypeIndex = 3;
                            functionArray[domainTypeIndex](modelData["domain"]);
                        }
                        else {
                            domainTypeIndex = 99;
                            functionArray[domainTypeIndex](featureTypes);
                        }

                        var obj1 = domainTypeArray[domainTypeIndex]
                        return obj1;
                    }

                    if (hasSubTypeDomain){
                        if (featureTypes[pickListIndex].domains[modelData["name"]]["type"] == "inherited") {
                            getFieldDomainDetails( modelData["domain"] );
                            domainTypeIndex =  getTypeIndex(modelData["domain"]["type"]);
                        }
                        else {
                            domainTypeIndex = getTypeIndex(featureTypes[pickListIndex].domains[modelData["name"]]["type"]);
                            getFieldDomainDetails(featureTypes[pickListIndex].domains[modelData["name"]]);

                        }
                        return domainTypeArray[domainTypeIndex];
                    }

                    if ( modelData["domain"] ) {
                        getFieldDomainDetails( modelData["domain"] );
                        domainTypeIndex = getTypeIndex(modelData["domain"]["type"]);
                        return domainTypeArray[domainTypeIndex];
                    }

                    functionArray[domainTypeIndex]();
                    return domainTypeArray[domainTypeIndex];
                })()

                function getFieldDomainDetails(fieldDomain){
                    domainTypeIndex = getTypeIndex(fieldDomain["type"]);
                    functionArray[domainTypeIndex](fieldDomain);
                }

                function getTypeIndex(typeString){
                    switch(typeString){
                    case "codedValue":
                        return 3;
                    case "range":
                        return 1;
                    }
                }

                function getEditControlValues(){
                    console.log("This is a text box");
                }

                function getRangeDomainValues(domainObject){
                    console.log("DDDomainRange:::", domainObject["range"][0], domainObject["range"][1])
                    rangeArray.push(domainObject["range"][0], domainObject["range"][1]);
                }

                function getAtrributeDomainValues(domainObject){
                    var array = domainObject["codedValues"];

                    //This sort function is here to deal with how the QML API is returning the list of attribute domain values
                    array.sort(function(a, b) {
                        if(typeof(a.code) == "string"){
                            return a.code.localeCompare(b.code);
                        }
                        else if (typeof(a.code) === "number"){
                            return parseFloat(a.code) - parseFloat(b.code);
                        }
                    });

                    for ( var i = 0; i < array.length; i++ ) {
                        codedCodeArray.push(array[i]["code"]);
                        codedNameArray.push(array[i]["name"]);
                    }
                }

                function getSubTypeAtrributeDomainValues(typesObject){
                    for ( var type in typesObject){
                        codedCodeArray.push(typesObject[type]["code"]);
                        codedNameArray.push(typesObject[type]["name"]);
                    }
                }
            }
        }

        function onAttributeUpdate(f_name, f_value, nullableValue){
            for(var i=0; i<theFeatureAttributesModel.count; i++) {
                var item = theFeatureAttributesModel.get(i);
                if(item["fieldName"] == f_name) {
                    item["fieldValue"] = f_value;
                    if(f_value>""&&f_value!=null&&nullableValue==false){
                        requiredAttributes[fieldName] = f_value;
                    } else{
                        delete requiredAttributes[fieldName];
                    }
                    hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
                }
            }
        }
    }

    Component {
        id: editControl
        EditControl{}
    }

    Component {
        id: cvdControl
        Domain_CodedValue {}
    }

    Component {
        id: subTypeCvdControl
        SubType_CodedValue {}
    }

    Component {
        id: rangeControl
        Domain_Range {}
    }

    Component {
        id: dateControl
        DateControl {}
    }
}
