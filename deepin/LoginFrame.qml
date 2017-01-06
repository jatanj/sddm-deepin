import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Item {
    id: frame
    property int sessionIndex: sessionModel.lastIndex
    property string userName: userModel.lastUser
    property bool isProcessing: glowAnimation.running
    property alias input: passwdInput
    property alias button: loginButton

    readonly property color inputTextColor: "#aa000000"
    readonly property color failTextColor: "#55000000"

    Connections {
        target: sddm
        onLoginSucceeded: {
            glowAnimation.running = false
            Qt.quit()
        }
        onLoginFailed: {
            passwdInput.echoMode = TextInput.Normal
            passwdInput.text = textConstants.loginFailed
            passwdInput.focus = false
            passwdInput.color = failTextColor
            glowAnimation.running = false
        }
    }

    Item {
        id: loginItem
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        UserAvatar {
            id: userIconRec
            anchors {
                top: parent.top
                topMargin: parent.height / 4
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.1
            height: width
            source: userFrame.currentIconPath
            onClicked: {
                root.state = "stateUser"
                userFrame.focus = true
            }
        }

        Glow {
            id: avatarGlow
            anchors.fill: userIconRec
            radius: 0
            samples: 17
            color: mainColor
            source: userIconRec

            SequentialAnimation on radius {
                id: glowAnimation
                running: false
                alwaysRunToEnd: true
                loops: Animation.Infinite
                PropertyAnimation { to: 20 ; duration: 1000}
                PropertyAnimation { to: 0 ; duration: 1000}
            }
        }

        Text {
            id: userNameText
            anchors {
                top: userIconRec.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            text: userName
            color: textColor
						styleColor: textStyleColor
						style: Text.Outline
					  font.pointSize: 25
					  font.family: fixedFont.name
					}

        Rectangle {
            id: passwdInputRec
            visible: ! isProcessing
            anchors {
                top: userNameText.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width * 0.2
            height: parent.height * 0.1
            radius: 0
            color: mainColor

            TextInput {
                id: passwdInput
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8 + 36
                clip: true
                focus: true
                color: inputTextColor
                font.pointSize: 15
                font.family: fixedFont.name
                selectByMouse: true
                selectionColor: "#a8d6ec"
                echoMode: TextInput.Password
                verticalAlignment: TextInput.AlignVCenter
                onFocusChanged: {
                    if (focus) {
                        color = inputTextColor
                        echoMode = TextInput.Password
                        text = ""
                    }
                }
                onAccepted: {
                    glowAnimation.running = true
                    sddm.login(userNameText.text, passwdInput.text, sessionIndex)
                }
                KeyNavigation.backtab: {
                    if (sessionButton.visible) {
                        return sessionButton
                    }
                    else if (userButton.visible) {
                        return userButton
                    }
                    else {
                        return shutdownButton
                    }
                }
                KeyNavigation.tab: loginButton
                Timer {
                    interval: 200
                    running: true
                    onTriggered: passwdInput.forceActiveFocus()
                }
            }
            ImgButton {
                id: loginButton
                width: height
                height: passwdInput.height
                imageWidth: width / 1.5
                imageHeight: height / 1.5
                color: "#55000000"
                border.width: 1
                border.color: "#ffffff"
                radius: 0
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                normalImg: "icons/login_normal.png"
                onClicked: {
                    glowAnimation.running = true
                    sddm.login(userNameText.text, passwdInput.text, sessionIndex)
                }
                KeyNavigation.tab: shutdownButton
                KeyNavigation.backtab: passwdInput
            }
        }
    }
}
