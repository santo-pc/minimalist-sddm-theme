import QtQuick 2.11
import QtQuick.Controls 2.4

Item {

    id: sessionButton
    height: 40  
    width: parent.width

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession: "Session"
    property int loginButtonWidth: 120
    property Control exposeSession: selectSession

    ComboBox {
        id: selectSession
        anchors.fill: parent
        hoverEnabled: true
        
        Keys.onPressed: {
            if (event.key == Qt.Key_Up && !popup.opened) {
                event.accepted = true
            }
            if (event.key == Qt.Key_Down && !popup.opened) {
                event.accepted = true
            }
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open()
            }
        }

        model: sessionModel
        currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
        textRole: "name"

        delegate: ItemDelegate {
            width: selectSession.width
            height: 35
            
            contentItem: Text {
                text: model.name
                font.pixelSize: 14
                color: "#e6e6e6"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            
            highlighted: selectSession.highlightedIndex === index
            
            background: Rectangle {
                color: highlighted ? "#0078d4" : "#333333"
                radius: 4
            }
        }

        indicator: Text {
            // Position indicator properly within the ComboBox bounds
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "▼"
            font.pixelSize: 12
            color: "#1a1a1a"
        }

        contentItem: Text {
            id: displayedItem
            // Use proper padding to keep text within bounds
            leftPadding: 8
            rightPadding: 30  // Leave space for indicator
            text: (textConstantSession + ":") + " " + selectSession.currentText
            color: "#888888"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14
            // IMPORTANT: Clip and elide to prevent overflow
            clip: true
            elide: Text.ElideRight
        }

        background: Rectangle {
            // Remove explicit width - let it fill the ComboBox
            color: "#1a1a1a"
            border.color: selectSession.activeFocus ? "#0078d4" : "#444444"
            border.width: 1
            radius: 4
            // Ensure background fills the entire ComboBox
            anchors.fill: parent
        }

        popup: Popup {
            id: popupHandler
            y: selectSession.height
            x: 0
            width: selectSession.width
            implicitHeight: Math.min(contentItem.implicitHeight + 20, 200)
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: 4
                color: "#333333"
                border.color: "#555555"
                border.width: 1
            }

            enter: Transition {
                NumberAnimation { 
                    property: "opacity"
                    from: 0
                    to: 1 
                }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: "#cccccc"
                }
                PropertyChanges {
                    target: selectSession.background
                    color: "#1a1a1a"
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: "#1a1a1a"
                }
                PropertyChanges {
                    target: selectSession.background
                    color: "#333333"
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: "#888888"
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: "#0078d4"
                    border.width: 2
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, border.width"
                    duration: 150
                }
            }
        ]
    }
}
