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
import QtQuick.Controls.Styles 1.4

TextFieldStyle {
    property int buttonBorderRadius: 0
    property real rectHeight: app.baseFontSize
    property int borderWidth: 0
    property int rectRadius: 0

    renderType: Text.QtRendering
    textColor: app.isDarkMode? "white": app.textColor
    placeholderTextColor: app.isDarkMode? "white": app.textColor
    background: Rectangle{
        color: app.isDarkMode? Qt.lighter(app.pageBackgroundColor, 1.2): "transparent"
        radius: rectRadius
        border.width: app.isDarkMode? 0: borderWidth
        border.color: Qt.darker(app.pageBackgroundColor, 1.2)
    }
    font {
        bold: false
        pixelSize: app.subtitleFontSize
        family: app.customTextFont.name
    }
}

