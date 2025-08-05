// SDDM Sugar Candy is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
// Config created by https://github.com/MarianArlt
// Config modified by keyitdev https://github.com/keyitdev

import QtQuick 2.11
import QtQuick.Controls 2.4
// import QtGraphicalEffects 1.0

Item {
    id: sessionButton
    height: root.font.pointSize
    width: 200 // parent.width
    // anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: parent.left

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    ComboBox {
        id: selectSession

        hoverEnabled: true
        anchors.left: parent.left
        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened)
                revealSecret.focus = true,
                revealSecret.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened)
                loginButton.focus = true,
                loginButton.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Down && !popup.opened)
                systemButtons.children[0].focus = true,
                systemButtons.children[0].state = "focused",
                currentIndex = currentIndex - 1;
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
                popup.open();
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
                color: selectSession.highlightedIndex === "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.highlight : "green"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            id: displayedItem
            text: (config.TranslateSession || (textConstantSession + ":")) + " " + selectSession.currentText
            color: "black" //root.palette.text
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: "grey"
            border.width: 1 
            border.color: "white"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 3
        }

        popup: Popup {
            id: popupHandler
            y: parent.height - 1
            x: config.ForceRightToLeft == "true" ? -loginButtonWidth + displayedItem.width : 0
            width: sessionButton.width
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: config.BackgroundColor
                layer.enabled: true
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    // color: Qt.darker(root.palette.highlight, 1.1)
                    color: "purple" //Qt.darker(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.darker(root.palette.highlight, 1.1)
                    color: "pink" //Qt.darker(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    // color: Qt.lighter(root.palette.highlight, 1.1)
                    color: "blue"//  Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    // color: root.palette.highlight
                    color: "yellow"//root.palette.highlight
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: root.palette.highlight
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]

    }

}
