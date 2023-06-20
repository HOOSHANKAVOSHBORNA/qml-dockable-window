
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import XFoo

Item {
    id: rootItem

    enum DropLocation {
        DropLocTop,
        DropLocBottom,
        DropLocLeft,
        DropLocRight,
        DropLocCenter,
        DropLocNone
    }

    property int dropLoc: DockArea.DropLocNone
    property int orientation: Qt.Horizontal


    property bool isDefaultDockArea: false


    property MainWindow parentMainWindow
    property DockArea parentDockArea: null
    property DockArea siblingDockArea: null
    property DockArea firstChildDockArea: null
    property DockArea secondChildDockArea: null

    readonly property var selfComp: Qt.createComponent("DockArea.qml");
    readonly property var splitViewComp: Qt.createComponent("DockSplitView.qml");
    readonly property var headerListElementComp: Qt.createComponent("DockHeaderListElement.qml");

    property bool isSplitted: false
    property bool hasHeader: false

    readonly property Item stackContainer: containerItemStack

    property real splitWidthScale: 0.5
    property real splitHeightScale: 0.5

    SplitView.preferredWidth: parent.width * rootItem.splitWidthScale;
    SplitView.preferredHeight: parent.height * rootItem.splitHeightScale;
    SplitView.minimumWidth: 20;
    SplitView.minimumHeight: 20;
    SplitView.fillWidth: false;
    SplitView.fillHeight: false;

    property SplitView parentSplitView
    function onResizeTriggerChanged() {
        if (rootItem.parentSplitView) {
            rootItem.splitWidthScale = rootItem.width / parentSplitView.width;
            rootItem.splitHeightScale = rootItem.height / parentSplitView.height;
        }
    }

    function attachDockItemIfIsDefault(horizontalAttach, attachAsFirst, attachItem, splitScale) {
        if (rootItem.isDefaultDockArea === true) {
            if (rootItem.selfComp.status === Component.Ready) {
                var sprite1 = rootItem.selfComp.createObject(rootItem, {parentMainWindow: rootItem.parentMainWindow});
                var sprite2 = rootItem.selfComp.createObject(rootItem, {parentMainWindow: rootItem.parentMainWindow});


                sprite1.parentDockArea = rootItem;
                sprite2.parentDockArea = rootItem;
                sprite1.siblingDockArea = sprite2;
                sprite2.siblingDockArea = sprite1;

                sprite1.stackContainer.hasHeader = containerItemStack.hasHeader;
                const len = containerItemStack.data.length;
                const ci1 = containerItemStack.currentIndex;
                for (var i = 0; i < len; i++) {
                    const itm = containerItemStack.data[0];
                    itm.detachDockArea = sprite1;
                    itm.attach(sprite1.stackContainer);
                }
                sprite1.stackContainer.currentIndex = ci1;
                sprite1.stackContainer.updateHeaderModel();
                if(sprite1.stackContainer.currentndex >= sprite1.stackContainer.data.length) {
                    sprite1.stackContainer.currentndex = 0;
                }

                if (rootItem.isDefaultDockArea === true) {
                    sprite1.isDefaultDockArea = true;
                    rootItem.isDefaultDockArea = false;
                    parentMainWindow.defaultDockArea = sprite1;
                }


                sprite2.stackContainer.hasHeader = true;
                attachItem.detachDockArea = sprite2;
                sprite2.stackContainer.data = [];
                attachItem.attach(sprite2.stackContainer);

                sprite2.stackContainer.currentIndex = 0;
                sprite2.stackContainer.updateHeaderModel();

                sprite1.splitWidthScale = 1 - splitScale;
                sprite1.splitHeightScale = 1 - splitScale;
                sprite2.splitWidthScale = splitScale;
                sprite2.splitHeightScale = splitScale;


                const splitView = rootItem.splitViewComp.createObject(rootItem, {});

                if (horizontalAttach === true) {
                    if (attachAsFirst === true) {
                        splitView.data.push(sprite2);
                        splitView.data.push(sprite1);
                        splitView.orientation = Qt.Horizontal;
                        rootItem.firstChildDockArea = sprite2;
                        rootItem.secondChildDockArea = sprite1;
                    } else {
                        splitView.data.push(sprite1);
                        splitView.data.push(sprite2);
                        splitView.orientation = Qt.Horizontal;
                        rootItem.firstChildDockArea = sprite1;
                        rootItem.secondChildDockArea = sprite2;
                    }
                } else {
                    if (attachAsFirst === true) {
                        splitView.data.push(sprite2);
                        splitView.data.push(sprite1);
                        splitView.orientation = Qt.Vertical;
                        rootItem.firstChildDockArea = sprite2;
                        rootItem.secondChildDockArea = sprite1;
                    } else {
                        splitView.data.push(sprite1);
                        splitView.data.push(sprite2);
                        splitView.orientation = Qt.Vertical;
                        rootItem.firstChildDockArea = sprite1;
                        rootItem.secondChildDockArea = sprite2;
                    }
                }
                rootItem.orientation = splitView.orientation;


                splittedView.data = [];
                splittedView.data.push(splitView);
                splitView.anchors.fill = splittedView;

                rootItem.isSplitted = true;

                splitView.resizeTriggerChanged.connect(sprite1.onResizeTriggerChanged);
                splitView.resizeTriggerChanged.connect(sprite2.onResizeTriggerChanged);

                sprite1.parentSplitView = splitView;
                sprite2.parentSplitView = splitView;

            }


        }
    }

    function setDefaultDockableItemIfIsDefault(item) {
        if (rootItem.isDefaultDockArea === true) {
            containerItemStack.data = [];
            item.attach(containerItemStack);
            containerItemStack.currentIndex = 0;
        }
    }

    signal itemDetached();
    onItemDetached: function() {

        if (containerItemStack.data.length < 1) {
            if (rootItem.parentDockArea) {
                const sibling = rootItem.siblingDockArea;
                rootItem.parentDockArea.collapse(sibling);
            }
            rootItem.siblingDockArea = null;
            rootItem.parentDockArea = null;
        } else {
            if (containerItemStack.currentIndex >= containerItemStack.data.length) {
                containerItemStack.currentIndex = 0;
            }
        }
    }

    function updateDropLocation(point) {

        var dL = DockArea.DropLocTop;
        var minDistance = Math.sqrt(Math.pow(point.x - (dropArea.width * 0.5), 2) + Math.pow(point.y - 0, 2));

        var distance = Math.sqrt(Math.pow(point.x - (dropArea.width * 0.5), 2) + Math.pow(point.y - dropArea.height, 2))
        if (distance < minDistance) {
            minDistance = distance;
            dL = DockArea.DropLocBottom;
        }

        distance = Math.sqrt(Math.pow(point.x - 0, 2) + Math.pow(point.y - (dropArea.height * 0.5), 2))
        if (distance < minDistance) {
            minDistance = distance;
            dL = DockArea.DropLocLeft;
        }

        distance = Math.sqrt(Math.pow(point.x - dropArea.width, 2) + Math.pow(point.y - (dropArea.height * 0.5), 2))
        if (distance < minDistance) {
            minDistance = distance;
            dL = DockArea.DropLocRight;
        }

        if (containerItemStack.hasHeader === true) {
            distance = Math.sqrt(Math.pow(point.x - (dropArea.width * 0.5), 2) + Math.pow(point.y - (dropArea.height * 0.5), 2))
            if (distance < minDistance) {
                minDistance = distance;
                dL = DockArea.DropLocCenter;
            }
        }

        rootItem.dropLoc = dL;

    }

    function collapse(sda) {


        if (rootItem.firstChildDockArea.isDefaultDockArea === true ||
                rootItem.secondChildDockArea.isDefaultDockArea === true) {

            rootItem.firstChildDockArea.isDefaultDockArea = false;
            rootItem.secondChildDockArea.isDefaultDockArea = false;

            rootItem.isDefaultDockArea = true;
            parentMainWindow.defaultDockArea = rootItem;

        }


        if (sda.isSplitted) {
            var sprite1 = sda.firstChildDockArea;
            var sprite2 = sda.secondChildDockArea;

            rootItem.firstChildDockArea = sprite1;
            rootItem.secondChildDockArea = sprite2;

//            sprite2.splitWidthScale *=  sda.splitWidthScale;
//            sprite2.splitHeightScale *= sda.splitHeightScale;
//            sprite1.splitWidthScale =  (1 - sprite2.splitWidthScale);
//            sprite1.splitHeightScale = (1 - sprite2.splitHeightScale);

            sprite1.parentDockArea = rootItem;
            sprite2.parentDockArea = rootItem;
            sprite1.siblingDockArea = sprite2;
            sprite2.siblingDockArea = sprite1;

            const splitView = rootItem.splitViewComp.createObject(rootItem, {});
            splitView.data.push(sprite1);
            splitView.data.push(sprite2);
            splitView.orientation = sda.orientation;
            rootItem.orientation = splitView.orientation;


            splittedView.data = [];
            splittedView.data.push(splitView);
            splitView.anchors.fill = splittedView;

            rootItem.isSplitted = true;


            splitView.resizeTriggerChanged.connect(sprite1.onResizeTriggerChanged);
            splitView.resizeTriggerChanged.connect(sprite2.onResizeTriggerChanged);

            sprite1.parentSplitView = splitView;
            sprite2.parentSplitView = splitView;


        } else {


            containerItemStack.hasHeader = sda.stackContainer.hasHeader;
            const len = sda.stackContainer.data.length;
            const ci = sda.stackContainer.currentIndex;
            for (var i = 0; i < len; i++) {
                const itm = sda.stackContainer.data[0];
                itm.detachDockArea = rootItem;
                itm.attach(containerItemStack);
            }
            containerItemStack.currentIndex = ci;
            containerItemStack.updateHeaderModel();

            if (containerItemStack.currentIndex >= containerItemStack.data.length) {
                containerItemStack.currentIndex = 0;
            }

            rootItem.firstChildDockArea = null;
            rootItem.secondChildDockArea = null;

            rootItem.isSplitted = false;
        }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: rootItem.isSplitted ? splittedView.StackLayout.index : uniqueView.StackLayout.index

        Item {
            id: uniqueView
            Layout.fillWidth: true
            Layout.fillHeight: true



            ColumnLayout {
                anchors.fill: parent
                spacing: 1

                Item {
                    id: header
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.minimumHeight: headerRow.implicitHeight
                    Layout.leftMargin: 2
                    Layout.rightMargin: 2
                    Layout.topMargin: 2

                    visible: containerItemStack.hasHeader

                    Flickable {
                        id: flickItem
                        anchors.fill: parent
                        contentWidth: headerRow.implicitWidth
                        contentHeight: headerRow.implicitHeight
                        clip: true
                        flickableDirection: Flickable.HorizontalFlick
                        interactive: false

                        Row {
                            id: headerRow
                            spacing: 2

                            Repeater {
                                id: headerRepeater
                                model: containerItemStack.headerModel

                                Item {
                                    id: hdrBackItem
                                    implicitWidth: text1.implicitWidth + (implicitHeight * 2)
                                    implicitHeight: text1.implicitHeight * 2

                                    Rectangle {
                                        id: rect1
                                        anchors.fill: parent
                                        radius: 5
                                        color: "#404040"
                                        visible: containerItemStack.currentIndex === _index
                                    }

                                    Rectangle {
                                        id: rect2
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: parent.height / 2
                                        color: "#404040"
                                        visible: containerItemStack.currentIndex === _index
                                    }

                                    Text {
                                        id: text1
                                        anchors.centerIn: parent
                                        color: "white"
                                        text: _text
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: function() {
                                            _dockableItem.detach();
                                            containerItemStack.updateHeaderModel();
                                        }

                                        onClicked: function() {
                                            containerItemStack.currentIndex = _index;
                                        }
                                    }

                                }
                            }
                        }


                    }

                    MouseArea {
                        anchors.fill: flickItem

                        onWheel: function(wheel) {
                            if (wheel.angleDelta.y > 0) {
                                flickItem.contentX -= 30;
                                if (flickItem.contentX < 0) {
                                    flickItem.contentX = 0;
                                }
                            } else {
                                flickItem.contentX += 30;
                                if (flickItem.contentX + flickItem.width > flickItem.contentWidth) {
                                    flickItem.contentX = flickItem.contentWidth -  flickItem.width;
                                }
                            }
                        }

                        onClicked: function(mouse) {mouse.accepted = false;};
                        onPressed:function(mouse) {mouse.accepted = false;};
                        onReleased:function(mouse) {mouse.accepted = false;};
                        onDoubleClicked:function(mouse) {mouse.accepted = false;};
                        onPositionChanged:function(mouse) {mouse.accepted = false;};
                        onPressAndHold:function(mouse) {mouse.accepted = false;};

                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 2
                    color: "#808080"

                    visible: containerItemStack.hasHeader
                }


                StackLayout {
                    id: containerItemStack
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    property bool hasHeader: false


                    property ListModel headerModel: ListModel {

                    }


                    function updateHeaderModel() {
                        headerModel.clear();
                        const len = containerItemStack.data.length;
                        if (len > 0) {
                            for (var i = 0; i < len; i++) {
                                const itm = containerItemStack.data[i];
                                const ci = i;
                                if (itm.title) {
                                    headerModel.append({_text: itm.title, _dockableItem: itm, _index: ci});
                                } else {
                                    headerModel.append({_text: "Empty", _dockableItem: itm, _index: ci});
                                }
                            }
                        }

                    }


                }
            }

            Rectangle {
                id: dropRect
                anchors.fill: parent
                color: "#606060"
                opacity: 0.8
                visible:false

                Image {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: 10
                    sourceSize: Qt.size(48, 48)
                    width: 48
                    height: 48
                    source: "qrc:///images/up_direction.png"
                    scale: rootItem.dropLoc === DockArea.DropLocTop ? 1.5 : 1.0
                }
                Image {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: 10
                    sourceSize: Qt.size(48, 48)
                    width: 48
                    height: 48
                    source: "qrc:///images/up_direction.png"
                    rotation: 180
                    scale: rootItem.dropLoc === DockArea.DropLocBottom ? 1.5 : 1.0
                }
                Image {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    sourceSize: Qt.size(48, 48)
                    width: 48
                    height: 48
                    source: "qrc:///images/up_direction.png"
                    rotation: -90
                    scale: rootItem.dropLoc === DockArea.DropLocLeft ? 1.5 : 1.0
                }
                Image {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    sourceSize: Qt.size(48, 48)
                    width: 48
                    height: 48
                    source: "qrc:///images/up_direction.png"
                    rotation: 90
                    scale: rootItem.dropLoc === DockArea.DropLocRight ? 1.5 : 1.0
                }
                Rectangle {
                    anchors.centerIn: parent
                    width:48
                    height:48
                    color: "black"
                    radius: 24
                    visible: containerItemStack.hasHeader
                    scale: rootItem.dropLoc === DockArea.DropLocCenter ? 1.5 : 1.0
                }
            }

            DropArea {
                id: dropArea
                anchors.fill: parent
                keys: ["text/xxx-custom"]
                onDropped: function(drag) {
                    dropRect.visible = false;

                    if (rootItem.dropLoc === DockArea.DropLocCenter) {
                        parentMainWindow.dockItem.detachDockArea = rootItem;
                        parentMainWindow.dockItem.attach(containerItemStack);
                        containerItemStack.currentIndex = containerItemStack.data.length - 1;
                        containerItemStack.updateHeaderModel();

                    } else {

                        if (rootItem.selfComp.status === Component.Ready) {
                            var sprite1 = rootItem.selfComp.createObject(rootItem, {parentMainWindow: rootItem.parentMainWindow});
                            var sprite2 = rootItem.selfComp.createObject(rootItem, {parentMainWindow: rootItem.parentMainWindow});


                            sprite1.parentDockArea = rootItem;
                            sprite2.parentDockArea = rootItem;
                            sprite1.siblingDockArea = sprite2;
                            sprite2.siblingDockArea = sprite1;

                            sprite1.stackContainer.hasHeader = containerItemStack.hasHeader;
                            const len = containerItemStack.data.length;
                            const ci1 = containerItemStack.currentIndex;
                            for (var i = 0; i < len; i++) {
                                const itm = containerItemStack.data[0];
                                itm.detachDockArea = sprite1;
                                itm.attach(sprite1.stackContainer);
                            }
                            sprite1.stackContainer.currentIndex = ci1;
                            sprite1.stackContainer.updateHeaderModel();
                            if(sprite1.stackContainer.currentndex >= sprite1.stackContainer.data.length) {
                                sprite1.stackContainer.currentndex = 0;
                            }

                            if (rootItem.isDefaultDockArea === true) {
                                sprite1.isDefaultDockArea = true;
                                rootItem.isDefaultDockArea = false;
                                parentMainWindow.defaultDockArea = sprite1;
                            }


                            sprite2.stackContainer.hasHeader = true;
                            parentMainWindow.dockItem.detachDockArea = sprite2;
                            sprite2.stackContainer.data = [];
                            parentMainWindow.dockItem.attach(sprite2.stackContainer);

                            sprite2.stackContainer.currentIndex = 0;
                            sprite2.stackContainer.updateHeaderModel();

                            sprite1.splitWidthScale = 0.5;
                            sprite1.splitHeightScale = 0.5;
                            sprite2.splitWidthScale = 0.5;
                            sprite2.splitHeightScale = 0.5;


                            const splitView = rootItem.splitViewComp.createObject(rootItem, {});
                            switch (rootItem.dropLoc) {
                            case DockArea.DropLocTop:
                                splitView.data.push(sprite2);
                                splitView.data.push(sprite1);
                                splitView.orientation = Qt.Vertical;
                                rootItem.firstChildDockArea = sprite2;
                                rootItem.secondChildDockArea = sprite1;
                                break
                            case DockArea.DropLocBottom:
                                splitView.data.push(sprite1);
                                splitView.data.push(sprite2);
                                splitView.orientation = Qt.Vertical;
                                rootItem.firstChildDockArea = sprite1;
                                rootItem.secondChildDockArea = sprite2;
                                break
                            case DockArea.DropLocLeft:
                                splitView.data.push(sprite2);
                                splitView.data.push(sprite1);
                                splitView.orientation = Qt.Horizontal;
                                rootItem.firstChildDockArea = sprite2;
                                rootItem.secondChildDockArea = sprite1;
                                break
                            default:
                                splitView.data.push(sprite1);
                                splitView.data.push(sprite2);
                                splitView.orientation = Qt.Horizontal;
                                rootItem.firstChildDockArea = sprite1;
                                rootItem.secondChildDockArea = sprite2;
                                break
                            }
                            rootItem.orientation = splitView.orientation;


                            splittedView.data = [];
                            splittedView.data.push(splitView);
                            splitView.anchors.fill = splittedView;

                            rootItem.isSplitted = true;

                            splitView.resizeTriggerChanged.connect(sprite1.onResizeTriggerChanged);
                            splitView.resizeTriggerChanged.connect(sprite2.onResizeTriggerChanged);

                            sprite1.parentSplitView = splitView;
                            sprite2.parentSplitView = splitView;

                        } else {
                            console.log(selfComp.errorString());
                        }
                    }

                    rootItem.dropLoc = DockArea.DropLocNone;
                }

                onEntered: function(drag) {
                    dropRect.visible = true;
                    rootItem.updateDropLocation(Qt.point(drag.x, drag.y));
                }
                onPositionChanged: function(drag) {
                    rootItem.updateDropLocation(Qt.point(drag.x, drag.y));
                }
                onExited: function() {
                    dropRect.visible = false;
                    rootItem.dropLoc = DockArea.DropLocNone;
                }
            }
        }

        Item {
            id: splittedView
            Layout.fillWidth: true
            Layout.fillHeight: true

        }
    }
}
