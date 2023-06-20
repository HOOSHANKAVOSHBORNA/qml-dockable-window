import QtQuick
import QtQuick.Controls

SplitView {

    id: splitView

    property bool resizeTrigger

    handle: Rectangle {
        id: handleDelegate
        implicitWidth: 4
        implicitHeight: 4
        color: SplitHandle.pressed ? "#81e889" : "#101010"

        SplitHandle.onPressedChanged: function() {
            if (handleDelegate.SplitHandle.pressed === false) {
                splitView.resizeTrigger = !splitView.resizeTrigger;
            }
        }

//        containmentMask: Item {
//            x: (handleDelegate.width - width) / 2
//            width: 12
//            height: splitView.height
//        }
    }
}
