import QtQuick 2.0

Rectangle {
    id: button
    radius: 5
    color: focus ? "#33000000" : "transparent"
    width: 30
    height: 30
    property int imageWidth: width
    property int imageHeight: height
    property url normalImg: ""
    property url hoverImg: normalImg
    property url pressImg: normalImg

    signal clicked()
    signal enterPressed()

    onNormalImgChanged: img.source = normalImg

    Image {
        id: img
        width: parent.imageWidth
        height: parent.imageHeight
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        onClicked: button.clicked()
    }
    Component.onCompleted: {
        img.source = normalImg
    }
    Keys.onPressed: {
        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
            button.clicked()
            button.enterPressed()
        }
    }
}
