

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import XFoo

Item {
    id: rootItem
    property bool isComplete: false
    property bool attached: false
    readonly property Window detachWindow: wndItem
    property MainWindow attachWindow: null
    property string title: "Ali Askari"

    property DockArea detachDockArea: null

    property color tmpColor: "red"

    Layout.fillWidth: true
    Layout.fillHeight: true

    visible: false


    Component.onCompleted: function() {
        rootItem.isComplete = true;
        if (rootItem.isComplete === true && wndItem.isComplete === true) {
            detachHidden();
        }
    }

    function wrapItem(item) {
        contentItem.data = [];
        contentItem.data.push(item);
        item.anchors.fill = contentItem;
    }

    function attach(containerItem) {
        wndItem.hide();
        rootItem.anchors.centerIn = null;
        rootItem.anchors.fill = null;
        containerItem.data.push(rootItem);
        rootItem.attached = true;
    }

    function detach() {
        bodyItem.data.push(rootItem);
        rootItem.anchors.centerIn = null;
        rootItem.anchors.fill = bodyItem;
        wndItem.show();
        rootItem.attached = false;

        if (rootItem.detachDockArea) {
            rootItem.detachDockArea.itemDetached();
        }
    }

    function detachHidden() {
        bodyItem.data.push(rootItem);
        rootItem.anchors.centerIn = null;
        rootItem.anchors.fill = bodyItem;
        wndItem.hide();
        rootItem.attached = false;
        rootItem.visible = true;

        if (rootItem.detachDockArea) {
            rootItem.detachDockArea.itemDetached();
        }
    }


    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: 0
       // Rectangle {
       //     anchors.centerIn: parent
       //     width: parent.width
       //     height: parent.height
       //     color: rootItem.tmpColor
       // }
    }

    Window {
        id: wndItem
        property bool isComplete: false

        x: (Math.random() * 300) + 300
        y: (Math.random() * 300) + 300
        width: 640
        height: 480
        visible: false
        color: "#303030"
        //flags: Qt.FramelessWindowHint

        Component.onCompleted: function() {
            wndItem.isComplete = true;
            if (rootItem.isComplete === true && wndItem.isComplete === true) {
                detachHidden();
            }
        }

        Binding {
            target: text1
            property: "text"
            value: rootItem.title
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 1

            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.preferredHeight: headerRow.implicitHeight
                Layout.leftMargin: 2
                Layout.rightMargin: 2
                Layout.topMargin: 2

                MouseArea {
                    anchors.fill: parent
                    onPressed: function() {
                        wndItem.startSystemMove();
                    }
                }

                Row {
                    id: headerRow
                    anchors.left: parent.left
                    anchors.top: parent.top

                    Rectangle {
                        id: rect1
                        implicitWidth: text1.implicitWidth + (implicitHeight * 2)
                        implicitHeight: text1.implicitHeight * 2
                        radius: 5
                        color: "#404040"

                        Rectangle {
                            id: rect2
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: parent.height / 2
                            color: "#404040"
                        }

                        Text {
                            id: text1
                            anchors.centerIn: parent
                            color: "white"
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: rect1
                            cursorShape: mouseArea.containsPress ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                            drag.target: draggable
                        }
                        Item {
                            id: draggable
                            anchors.fill: mouseArea
                            Drag.hotSpot.x: 0
                            Drag.hotSpot.y: 0
                            Drag.mimeData: { "text/xxx-custom": "Ali XXX" }
                            Drag.dragType: Drag.Automatic
                            Drag.onDragStarted: function() {
                                rootItem.attachWindow.startTabDrag(rootItem);
                            }
                            Drag.onDragFinished: function(dropAction) {
                                rootItem.attachWindow.finishTabDrag();
                            }
                            Drag.imageSource: "qrc:///images/drag.png"

                            Binding on Drag.active {
                                value: mouseArea.drag.active
                                delayed: true
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#808080"
            }

            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
