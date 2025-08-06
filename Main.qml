import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    width: 900
    height: 550
    color: "#1a1a1a"
    
    property string username: ""
    property string password: ""
    property int sessionIndex: 0  // Start at 0 instead of sessionModel.lastIndex
    
    // Test data for when sessionModel is empty (test mode)
    property var testSessions: ["GNOME", "KDE Plasma", "XFCE", "i3", "Sway"]
    property bool isTestMode: sessionModel.rowCount() === 0
    
    // Initialize sessionIndex properly
    Component.onCompleted: {
        if (!isTestMode && sessionModel.lastIndex >= 0) {
            sessionIndex = sessionModel.lastIndex
        }
    }
    
    // Load custom font
    FontLoader {
        id: customFont
        source: "Fonts/RobotoMono-Regula.ttf"  // Replace with your actual font file
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16
        width: 500

        // Username input
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#1a1a1a"
            border.color: usernameInput.activeFocus ? "#0078d4" : "#444444"
            border.width: usernameInput.activeFocus ? 2 : 1
            radius: 4
            
            TextInput {
                id: usernameInput
                anchors.fill: parent
                anchors.margins: 8
                text: username
                onTextChanged: username = text
                focus: true
                color: "#ffffff"
                font.family: customFont.name
                font.pixelSize: 14
                verticalAlignment: TextInput.AlignVCenter
                
                KeyNavigation.tab: passwordInput
                
                Text {
                    anchors.fill: parent
                    text: "Username"
                    color: "#888888"
                    font.family: customFont.name
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    visible: parent.text.length === 0
                }
            }
        }

        // Password input
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#1a1a1a"
            border.color: passwordInput.activeFocus ? "#0078d4" : "#444444"
            border.width: passwordInput.activeFocus ? 2 : 1
            radius: 4
            
            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 8
                text: password
                onTextChanged: password = text
                color: "#ffffff"
                font.family: customFont.name
                font.pixelSize: 14
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                
                KeyNavigation.tab: loginButton
                KeyNavigation.backtab: usernameInput
                Keys.onReturnPressed: sddm.login(username, password, sessionIndex)
                Keys.onEnterPressed: sddm.login(username, password, sessionIndex)
                
                Text {
                    anchors.fill: parent
                    text: "Password"
                    color: "#888888"
                    font.family: customFont.name
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    visible: parent.text.length === 0
                }
            }
        }

        // Session selector and Login button in horizontal layout
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Session selector takes up remaining space
            SessionButton {
                id: sessionSelect
                Layout.fillWidth: true
                textConstantSession: "Session"
                KeyNavigation.tab: loginButton
            }

            // Login button with fixed width
            Rectangle {
                id: loginButton
                Layout.preferredWidth: 120
                height: 40
                color: loginMouseArea.pressed ? "#0d7377" : 
                       (loginMouseArea.containsMouse ? "#14a085" : 
                       (loginMouseArea.activeFocus ? "#2d8f6f" : "#40916c"))

                border.color: loginMouseArea.activeFocus ? "#ffffff" : "transparent"
                border.width: loginMouseArea.activeFocus ? 2 : 0
                radius: 6
                
                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "#ffffff"
                    font.family: customFont.name
                    font.pixelSize: 14
                }
                
                MouseArea {
                    id: loginMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onClicked: {
                        focus = true
                        sddm.login(username, password, sessionIndex)
                    }
                    
                    Keys.onReturnPressed: sddm.login(username, password, sessionIndex)
                    Keys.onEnterPressed: sddm.login(username, password, sessionIndex)
                    Keys.onSpacePressed: sddm.login(username, password, sessionIndex)
                    
                    KeyNavigation.tab: usernameInput
                    KeyNavigation.backtab: sessionSelect
                }
            }
        }
    }

}
