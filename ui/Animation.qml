import QtQuick.Controls 2.5
import QtQuick 2.15

Rectangle {
    id: animation

    color: "#000000"

    MouseArea{
        anchors.fill: parent
        onClicked: {
            //console.log("animation clicked");
            stack.pop();
        }
    }

    //property var array : [
    //      { msg : "line1", duration: 1000, type: 'ghost'},
    //      { msg : "line2", duration: 1000, type: 'ghost' },
    //      { msg : "line3", duration: 4000, type: 'mq' },
    //      { msg : "line4", duration: 3000, type: 'ghost' }
    //];
    property var array;
    property int ai: -1;

    Component.onCompleted: {
        // workaround. need to trigger one animation to get the sig slot connection working
        //console.log(array);
        theGhost.msg = "foo";
        theGhost.duration = 1;
        theGhost.isRunning = true;
    }

    function nextAni()
    {
        ai++;
        if (ai >= array.length)
        {
            ai = 0;
        }

        //console.log("nextAni: start:" + ai);
        if (array[ai].type === 'ghost') {
            theGhost.visible = true;
            theMq.visible = false;

            theGhost.msg = array[ai].msg;
            theGhost.duration = array[ai].duration;
            theGhost.isRunning = true;
        }
        else {
            theGhost.visible = false;

            theMq.visible = true;
            theMq.msg = array[ai].msg;
            theMq.duration = array[ai].duration;
            theMq.isRunning = true;
        }
        //console.log("nextAni: end: " + ai);
    }

    Connections {
        target: theGhost
        onAnimationDone: {
            //console.log("ghost: next ani")
            nextAni();
        }
    }

    Connections {
        target: theMq
        onAnimationDone: {
            //console.log("mq: next ani")
            nextAni();
        }
    }


    Marquee {
        id:theMq

        visible: false;
        width:  parent.width;
        height: parent.height;
        fontSize: 80;
    }

    Ghost {
        id: theGhost

        width:  parent.width;
        height: parent.height;
        fontSize: 80;
    }
}
