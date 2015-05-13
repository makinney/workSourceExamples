/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwDiscovery.js
 * @Created: July 2010
 * @Author:  Michael A Kinney
 *
 *
 *
 * Description :
 *
 * @Usage     (Public Interfaces):
 *
 * @Method
 *
 * @Returns   nothing.
 *
 * @Method
 *
 *
 * @Param
 */

var hwDiscoveryState = {
    init:0,
    discoveryBegin: 1,
    discoveryRunning : 2,
    discoveryEnd : 3,
    discoverySuccess : 4,
    discoveryConnectionError : 5
}

var HwDiscoveryCtrl = function(hwPanel) {

    var panel = hwPanel;

    var runningStateCallback = null;

    var panelConnectionAttempts = 0;
    var panelDiscoveryAttempts = 0;
    var maxallowableAttempts = 100; //

    var thisObj = this;

    this.getDiscoveryStatusCB = function(status) {

        if (status == 0) // done done
        {
            // pass control back and let it know what we're doing
            runningStateCallback(hwDiscoveryState.discoveryEnd);
        } else if (status == 1) { // running
            // pass control back and let main know what we are doing
            runningStateCallback(hwDiscoveryState.discoveryRunning);
        } else {
            // keep trying.... todo timeout or max attempts timeout ???
            // DS added, copied implementation from below method and added doTimeout waits: no connection yet, try again ?
            panelDiscoveryAttempts++;
            if (panelDiscoveryAttempts < maxallowableAttempts) {
                $.doTimeout( 2000, function(){ panel.getDiscoveryStatus(function(status){thisObj.getDiscoveryStatusCB(status)}, function(status){thisObj.errorCB(status)}); } );
            } else {
                // since we stopped searching, remove progress dots
                hwViewCtrl.removeProgressDotsFromScreen();
                // pass control back and let caller know about the error
                runningStateCallback(hwDiscoveryState.discoveryConnectionError);
            }
        }

    };

    this.panelConnectedCB = function(status) {
        if (status == 0) {
            // connected, now see if discovery is truly running
            panel.getDiscoveryStatus(function(status){thisObj.getDiscoveryStatusCB(status)}, function(status){thisObj.errorCB(status)});
        } else {
            // no connection yet, try again ?
            panelConnectionAttempts++;
            if (panelConnectionAttempts < maxallowableAttempts) {
                $.doTimeout( 2000, function(){ panel.getConnectionStatus(function(status){thisObj.panelConnectedCB(status)}, function(status){thisObj.errorCB(status)}); } );

            } else {
               // alert("problem connecting to panel connection attempts " + panelConnectionAttempts + " max attempts " + maxallowableAttempts);
               // alert("There was a problem making a connection with the panel. Please exit and then try again"); // todo - restart ??
               // since we stopped searching, remove progress dots
                hwViewCtrl.removeProgressDotsFromScreen();
                // pass control back and let caller know about the error
                runningStateCallback(hwDiscoveryState.discoveryConnectionError);
            }
        }
    }

    this.startDiscoverySuccessCB = function() {

        panel.getConnectionStatus(function(status){thisObj.panelConnectedCB(status)}, function(status){thisObj.errorCB(status)});

    };

    this.cancelDiscoverySuccessCB = function() {

        panel.startDiscovery(function(){thisObj.startDiscoverySuccessCB()}, function(status){thisObj.errorCB(status)});

    };

    this.errorCB = function(status) {
        // hwPanel already alerted the user to the error, but here, we need to stop making requests
        // otherwise user will keep seeing error dialog
        // todo process status
    };

    // discoveryRunningStateCB called back whenever any change in this modules state.
    this.run = function(discoveryRunningStateCB) {

        runningStateCallback = discoveryRunningStateCB;   // todo fix this callback, as called from main
        panelConnectionAttempts = 0;
        panelDiscoveryAttempts = 0;
        // do a cancel before a start, takes care of interrupts to discovery process, in case installer canceled
        // out in middle of last discovery
        panel.cancelDiscovery(function(){thisObj.cancelDiscoverySuccessCB()}, function(status){thisObj.errorCB(status)});

        hwViewCtrl.enterDiscoveryScreen();
        

    };
}