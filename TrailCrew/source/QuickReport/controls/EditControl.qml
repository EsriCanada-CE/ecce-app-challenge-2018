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
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.1

import "styles"
import "../images"

Column {
    id: column
    spacing: 3 * app.scaleFactor

    width: parent.width

    property alias text: aliasText.text
    property date exampleDate: new Date(272469600000);
    property alias textFieldValue: textField.text

    RowLayout{
        anchors {
            left: parent.left
            right: parent.right
        }
        height: aliasText.height

        Text {
            id: aliasText
            text: fieldAlias + (nullableValue?"":"*")
            verticalAlignment: Text.AlignBottom
            color: nullableValue? app.textColor:"red"
            font{
                pixelSize: app.subtitleFontSize
                family: app.customTextFont.name
            }
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(textAreaContainer.visible) textArea.resetTextArea();
                    if(textField.focus) textField.focus = false;
                    if(Qt.inputMethod.visible===true) Qt.inputMethod.hide();
                }
            }
        }

        ImageOverlay {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height
            fillMode: Image.PreserveAspectFit
            visible: Qt.platform.os==="ios"&&(textAreaContainer.visible || textField.focus)
            source: "../images/ic_keyboard_hide_black_48dp.png"
            opacity: 0.6
            showOverlay: app.isDarkMode
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(textAreaContainer.visible) textArea.resetTextArea();
                    if(textField.focus) textField.focus = false;
                    if(Qt.inputMethod.visible===true) Qt.inputMethod.hide();
                }
            }
        }

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Text{
            id: limitText
            text: maxlength? textField.text.length+"/"+maxlength : ""
            visible: fieldType == Enums.FieldTypeText
            Layout.preferredWidth: parent.width*0.2
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            fontSizeMode: Text.HorizontalFit
            color: app.textColor
            font{
                pixelSize: app.subtitleFontSize*0.8
                family: app.customTextFont.name
            }
            opacity: 0.4
            wrapMode: Text.WordWrap
            maximumLineCount: 2
        }
    }

    Item {

        height: childrenRect.height
        anchors {
            left: parent.left
            right: parent.right
        }

        IntValidator {
            id: smallIntValidator
            bottom: -32768
            top: 32767
        }

        IntValidator {
            id: defaultIntValidator
            bottom: -2147483648
            top: 2147483647
        }

        DoubleValidator {
            id: doubleValidator
            bottom: -2.2E38
            top: 1.8E38
            decimals: 6
        }


        Rectangle{
            id: textFieldContainer
            width: parent.width
            height: textField.height
            border.width: app.isDarkMode? 0:1
            border.color: textField.focus? "#8DAAD0":"lightgray"
            color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2) : "white"

            TextField {
                id: textField

                property date todaysDate : new Date()

                width: parent.width-textField.height
                anchors.top: parent.top
                anchors.left: parent.left

                textColor: acceptableInput ? app.textColor : "red"

                validator: {
                    if(Enums.FieldTypeInt16 == fieldType) {
                        return smallIntValidator
                    }
                    if(Enums.FieldTypeInt32 == fieldType) {
                        return defaultIntValidator
                    }
                    if(Enums.FieldTypeFloat64 == fieldType) {
                        return doubleValidator
                    }
                    return null
                }

                style: EditControlStyle{
                    rectHeight: Text.paintedHeight + 10 * app.scaleFactor
                }

                maximumLength: maxlength? fileType == Enums.FieldTypeDate? Number.MAX_VALUE:maxlength: fieldType == Enums.FieldTypeInt32? 18: Number.MAX_VALUE

                placeholderText: fieldType == Enums.FieldTypeText ? qsTr("Enter some text") : fieldType == Enums.FieldTypeDate ? qsTr("Pick a Date") : qsTr("Enter a number")

                text:  fieldType == Enums.FieldTypeDate ? attributesArray[fieldName] > "" ? new Date (attributesArray[fieldName]).toLocaleString(Qt.locale(), Qt.DefaultLocaleShortDate) : "" : (attributesArray[fieldName] || "")

                inputMethodHints: fieldType > 0 && fieldType < 5 ? Qt.ImhDigitsOnly : Qt.ImhNone

                enabled: fieldType == Enums.FieldTypeDate ? false : true

                onTextChanged: {
                    if (fieldType != Enums.FieldTypeDate){
                        attributesArray[fieldName] = text;
                        if(text>""&&text!=null&&nullableValue==false){
                            requiredAttributes[fieldName] = text;
                        } else{
                            delete requiredAttributes[fieldName];
                        }
                        hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
                    }
                }

                onEditingFinished: {
                    textField.focus = false;
                }

                onFocusChanged: {
                    if(focus){
                        if(fieldType === Enums.FieldTypeText && maximumLength > 249){
                            textAreaContainer.visible = true;
                            textAreaContainer.height = textField.height*5;
                            textField.focus = false;
                            textArea.focus = true;
                        } else if(fieldType === Enums.FieldTypeText && maximumLength > 49){
                            textAreaContainer.visible = true;
                            textAreaContainer.height = textField.height*2;
                            textField.focus = false;
                            textArea.focus = true;
                        } else {
                            textArea.focus = false;
                        }
                    }
                }

                Component.onCompleted: {
                    //listView.onAttributeUpdate(objectName, text)
                    if(!requiredAttributes)requiredAttributes={};
                    console.log("JSON app.attributesArray::",JSON.stringify(app.attributesArray))
                    if(app.isFromSaved && JSON.stringify(app.attributesArray[fieldName])!=null&&JSON.stringify(app.attributesArray[fieldName])!=""){
                        text = (fieldType == Enums.FieldTypeDate ? attributesArray[fieldName] > "" ? new Date (attributesArray[fieldName]).toLocaleString(Qt.locale(), Qt.DefaultLocaleShortDate) : "" : (attributesArray[fieldName] || ""))
                    }
                    if (fieldType != Enums.FieldTypeDate)
                        attributesArray[fieldName] = text;

                    if(text>""&&text!=null&&nullableValue==false){
                        requiredAttributes[fieldName] = text;
                    } else if(requiredAttributes && requiredAttributes[fieldName]) {
                        delete requiredAttributes[fieldName];
                    }
                    hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
                }

                property int requiredNum: numOfRequired

                onRequiredNumChanged: {
                    hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length;
                }
            }
        }

        Rectangle{
            id: textAreaContainer
            border.width: 1
            border.color: "#8DAAD0"
            color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2): "white"
            width: textFieldContainer.width
            height: textField.height
            anchors.top: textField.top
            anchors.right: textField.right
            visible: false

            onVisibleChanged: {
                isShowTextArea = visible
            }

            TextArea {
                id: textArea
                width: parent.width
                height: parent.height
                anchors.left: parent.left
                anchors.top: parent.top

                property string previousText: text
                property int maximumLength: maxlength? maxlength: Number.MAX_VALUE

                wrapMode: TextEdit.Wrap
                text:  fieldType == Enums.FieldTypeDate ? attributesArray[fieldName] > "" ? new Date (attributesArray[fieldName]).toLocaleString(Qt.locale(), Qt.DefaultLocaleShortDate) : "" : (attributesArray[fieldName] || "")
                focus: false
                style: TextAreaStyle {
                    backgroundColor: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2):"transparent"
                    font {
                        bold: false
                        pixelSize: app.subtitleFontSize
                        family: app.customTextFont.name
                    }
                    padding.right: textField.height
                    textColor: app.isDarkMode? "white": app.textColor
                }

                font {
                    bold: false
                    pixelSize: app.subtitleFontSize
                    family: app.customTextFont.name
                }

                onEditingFinished: {
                    resetTextArea();
                }

                onTextChanged: {
                    if (text.length > maximumLength) {
                        var cursor = cursorPosition;
                        text = previousText;
                        if (cursor > text.length) {
                            cursorPosition = text.length;
                        } else {
                            cursorPosition = cursor-1;
                        }
                    }
                    previousText = text

                    if (fieldType != Enums.FieldTypeDate){
                        attributesArray[fieldName] = text;
                        if(text>""&&text!=null&&nullableValue==false){
                            requiredAttributes[fieldName] = text;
                        } else{
                            delete requiredAttributes[fieldName];
                        }
                        hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
                        textField.text = Qt.binding(function(){return fieldType == Enums.FieldTypeDate ? attributesArray[fieldName] > "" ? new Date (attributesArray[fieldName]).toLocaleString(Qt.locale(), Qt.DefaultLocaleShortDate) : "" : (attributesArray[fieldName] || "")})

                    }
                }

                Rectangle{
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    width: textField.height-1
                    height: parent.height-2
                    anchors.verticalCenter: parent.verticalCenter
                    color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2): "transparent"
                }

                function resetTextArea(){
                    textAreaContainer.height = textField.height
                    textAreaContainer.visible = false;
                }
            }
        }

        Rectangle{
            height: textField.height-2
            width: textField.height-1
            anchors.right: textFieldContainer.right
            anchors.rightMargin: 1
            anchors.top: textField.top
            anchors.topMargin: 2
            radius: width/2
            color: "transparent"
            visible: textField.text.length>0 && fieldType != Enums.FieldTypeDate && (textAreaContainer.visible || textField.focus)

            Rectangle{
                height: parent.height*0.6
                width: parent.height*0.6
                anchors.centerIn: parent
                radius: width/2
                color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2):Qt.darker(app.pageBackgroundColor, 1.2)
                opacity: 0.8

                Image{
                    anchors.fill: parent
                    source:"../images/ic_clear_white_48dp.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!textArea.visible)textField.text = ""
                    else textArea.text=""
                }
            }
        }

        Button {
            anchors {
                right: textFieldContainer.right
                top: textField.top
                bottom: textField.bottom
            }
            width: height
            height: textField.height

            visible: fieldType == Enums.FieldTypeDate ? true : false
            enabled: visible
            onClicked: {
                app.calendarPicker = app.calendarDialogComponent.createObject(app);
                calendarPicker.attributesId = fieldName
                calendarPicker.swipeViewIndex = 0;
                calendarPicker.selectedDateAndTime = new Date();
                calendarPicker.updateDateAndTime();
                calendarPicker.visible = true;
            }

            style: ButtonStyle{
                background: Rectangle{
                    radius: 2*AppFramework.displayScaleFactor
                    width: parent.width
                    height: parent.height
                    clip: true
                    color: Qt.lighter(app.pageBackgroundColor, 1.2)
                    border.width: app.isDarkMode? 0:1
                    border.color: "#888"
                }

                label: Text{
                    color: app.isDarkMode? "white": app.textColor
                    text: control.text
                    clip: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            ImageOverlay {
                anchors.fill: parent
                anchors.margins: app.scaleFactor
                fillMode: Image.PreserveAspectFit
                source: "../images/ic_event_black_48dp.png"
                opacity: 0.6
                showOverlay: app.isDarkMode
            }
        }
    }

    Connections {
        target: calendarPicker

        onAccepted: {
            if(calendarPicker.attributesId === fieldName){
                textField.text = calendarPicker.selectedDateAndTime.toLocaleString(Qt.locale(), Qt.DefaultLocaleShortDate);
                attributesArray[fieldName] = calendarPicker.dateMilliseconds;
                console.log("///", textField.text, attributesArray[fieldName]);
                if(calendarPicker.dateMilliseconds>0&&calendarPicker.dateMilliseconds!=null&&nullableValue==false){
                    requiredAttributes[fieldName] = calendarPicker.dateMilliseconds;
                } else{
                    delete requiredAttributes[fieldName];
                }
                hasAllRequired = numOfRequired==Object.keys(requiredAttributes).length
            }
        }
    }
}
