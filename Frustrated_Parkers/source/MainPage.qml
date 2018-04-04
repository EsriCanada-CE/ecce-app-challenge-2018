import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

/*
  Page that opens when the app loads. It contains a swipping view showing the functionality of the app
*/

Item {
    anchors.fill: parent
    signal next()

    Rectangle {
        anchors.fill: parent
        color: app.primaryColor

        ColumnLayout{
            id: controlsLayout
            anchors.fill: parent
            anchors.bottomMargin: 20 * scaleFactor
            spacing: 12*app.scaleFactor

            //Swipe view containing Main Delegates for each view (feautres of the app)
            SwipeView {
                id: swipeView
                currentIndex: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                MainDelegate{
                    title: qsTr("Frustrated Parkers")
                    subtitle: qsTr("A mobile parking app to release your parking frustration. Swipe right to learn about the most interesting features")
                    imageSource: "./images/image0.png"
                }
                MainDelegate{
                    title: qsTr("Worried about finding a place to park?")
                    subtitle: qsTr("Find street, municipal parking and the closest parking lot around you")
                    imageSource: "./images/image8.png"
                }
                MainDelegate{
                    title: qsTr("Is there an snow emergency?")
                    subtitle: qsTr("Find where the snow route goes and were not to park")
                    imageSource: "./images/image6.png"
                }
                MainDelegate{
                    title: qsTr("Are you the ones who prefer biking everywhere?")
                    subtitle: qsTr("Find the closest biking rack, or indoor/outdoor parking")
                    imageSource: "./images/image7.png"
                }

                MainDelegate{
                    title: qsTr("Did you know that carpooling or an electric car could give you a better parking spot?")
                    subtitle: qsTr("Find designated carpool and electric vehicle parking")
                    imageSource: "./images/image2.png"
                }
                MainDelegate{
                    title: qsTr("Are you safe parking in that area?")
                    subtitle: qsTr("Explore the distribution of the parking tickets in your city to make sure you did not park in the wrong spot")
                    imageSource: "./images/image1.png"
                }

                MainDelegate{
                    title: qsTr("Where is my vehicle?")
                    subtitle: qsTr("If you are the ones who forget where they parked their vehicle, this app is for you!")
                    imageSource: "./images/image9.png"
                }


            }

            //Button to enter the map application
            Button{
                id: control
                anchors.horizontalCenter: parent.horizontalCenter
                highlighted: true
                Material.foreground: app.primaryColor
                Material.background: "#8B00CD"
                font.family: app.fontFamily.name
                font.pixelSize: app.subtitleFontSize
                text: qsTr("Explore")
                contentItem: Text {
                        text: control.text
                        font: control.font
                        color: control.down ? "white" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                padding: 20*app.scaleFactor
                topPadding: 10*app.scaleFactor
                bottomPadding: topPadding
                onClicked: {
                    //When clicked it takes you to the next page
                    next();
                }
            }

            //Indicator for the delegated page
            PageIndicator {
                id: carousel
                count: swipeView.count
                currentIndex: swipeView.currentIndex
                scale: 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: Rectangle {
                    implicitWidth: 8*app.scaleFactor
                    implicitHeight: 8*app.scaleFactor
                    radius: width / 2
                    color: "#8B00CD"
                    opacity: index === carousel.currentIndex ? 0.95 : pressed ? 0.7 : 0.45
                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 100
                        }
                    }
                }
            }

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 0
            }
        }
    }
}
