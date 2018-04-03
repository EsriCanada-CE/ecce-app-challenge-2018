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
import Esri.ArcGISRuntime 100.1

import "styles"

Column {
    id: column

    width: parent.width

    anchors{
        left: parent.left
        right:parent.right
    }

    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 3 * app.scaleFactor

    Text {
        text: fieldAlias + (nullableValue?"":"*")

        anchors {
            left: parent.left
            right: parent.right
        }
        color: nullableValue ? app.textColor:"red"
        font {
            pixelSize: app.subtitleFontSize
            family: app.customTextFont.name
        }
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        maximumLineCount: 2
    }

    ComboBox {
        id: comboBox
        model: codedNameArray
        anchors{
            left: parent.left
            right:parent.right
        }

        style: EditComboBoxStyle{        }

        enabled: !isSubTypeField
        activeFocusOnPress: true

        onCurrentIndexChanged: {
            attributesArray[fieldName] = codedCodeArray[comboBox.currentIndex];
            if((codedCodeArray[comboBox.currentIndex]>""||codedCodeArray[comboBox.currentIndex]!=null) && nullableValue==false){
                requiredAttributes[fieldName] = codedCodeArray[comboBox.currentIndex];
            } else{
                delete requiredAttributes[fieldName];
            }
            hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
        }
    }

    Component.onCompleted: {
        if(app.isFromSaved){
            for(var i=0; i<codedCodeArray.length;i++){
                var name = codedCodeArray[i];
                if(attributesArray[fieldName] == name){
                    comboBox.currentIndex = i;
                    console.log("comboBox.currentIndex", comboBox.currentIndex, name, attributesArray[fieldName])
                    break;
                }
            }
        }
        else if ( isSubTypeField ){
            comboBox.currentIndex = pickListIndex;
        }
        else {
            if ( hasPrototype ) {
                console.log(codedCodeArray.indexOf( defaultValue.toString() ), typeof ( codedCodeArray.indexOf( defaultValue.toString() )), codedNameArray.indexOf( codedNameArray[codedCodeArray.indexOf( defaultValue.toString() )]) )
                comboBox.currentIndex = codedNameArray.indexOf( codedNameArray[codedCodeArray.indexOf( defaultValue.toString() )]);
            }
            else {
                try {
                    var tempIndex = codedCodeArray.indexOf(attributesArray[fieldName])
                    console.log(fieldName, JSON.stringify(codedCodeArray), attributesArray[fieldName]);
                    comboBox.currentIndex = tempIndex>-1? tempIndex : defaultIndex;
                } catch(e) {

                }
            }
        }

        if(!requiredAttributes)requiredAttributes={};
        attributesArray[fieldName] = codedCodeArray[comboBox.currentIndex];
        if((codedCodeArray[comboBox.currentIndex]!=null||codedCodeArray[comboBox.currentIndex]>"")&&codedCodeArray[comboBox.currentIndex]!=null && nullableValue==false){
            requiredAttributes[fieldName] = codedCodeArray[comboBox.currentIndex];
        } else{
            delete requiredAttributes[fieldName];
        }
        hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
    }
}
