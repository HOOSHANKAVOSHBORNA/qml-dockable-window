
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import XFoo

MainWindow {

    id: mainWnd
    width: 800
    height: 600
    visible: true
    title: qsTr("XFoo")
    color: "#303030"
    property Component dockableItemComp: Qt.createComponent("DockableItem.qml");

    property DockableItem dockItem: null
    property DockArea defaultDockArea: mainDockArea


    DockArea {
        id: mainDockArea
        anchors.fill: parent
        parentMainWindow: mainWnd
        isDefaultDockArea: true

        Component.onCompleted: function() {
//            var obj = mainWnd.dockableItemComp.createObject(mainWnd, {x: 300, y: 300, attachWindow: mainWnd, tmpColor:"#104020", title: "def"});
//            mainWnd.defaultDockArea.setDefaultDockableItemIfIsDefault(obj);

//            var dock1 = mainWnd.dockableItemComp.createObject(mainWnd, {x: 100, y: 100, attachWindow: mainWnd, tmpColor:"#102040", title: "First"});
//            mainWnd.defaultDockArea.attachDockItemIfIsDefault(true, true, dock1, 0.25);

//            var dock2 = mainWnd.dockableItemComp.createObject(mainWnd, {x: 100, y: 100, attachWindow: mainWnd, tmpColor:"#402010", title: "Second"});
//            mainWnd.defaultDockArea.attachDockItemIfIsDefault(false, false, dock2, 0.35);
        }
    }

    function setCentralDockItemImpl(item) {
        mainWnd.defaultDockArea.setDefaultDockableItemIfIsDefault(item);
    }

    function attachToCentralDockItemImpl(item, horizontalAttach, attachAsFirst, splitScale) {
        mainWnd.defaultDockArea.attachDockItemIfIsDefault(horizontalAttach, attachAsFirst, item, splitScale);

    }

    function wrapItemWithDockableImpl(_item, _title) {
        var obj = mainWnd.dockableItemComp.createObject(mainWnd, {attachWindow: mainWnd, tmpColor:"#104020", title: _title});
        obj.wrapItem(_item);
        return obj;
    }


    function startTabDrag(item) {
        mainWnd.dockItem = item;
    }

    function finishTabDrag() {
        mainWnd.dockItem = null;
    }

}
