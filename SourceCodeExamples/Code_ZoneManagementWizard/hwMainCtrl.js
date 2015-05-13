/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwMainCtrl.js
 * @Created: July 2010
 * @Author:  Michael A Kinney
 *
 * hwManageZones is a controller.
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

//
var hwMainCtrl = null;
var hwZonesCtrl = null;
var hwRemotesCtrl = null;
var hwDiscoveryCtrl = null;
var hwPanel = null;


var hwZonesPanelInfo = {
    panelLynx : false
}


var hwButtonQuit = function() { // need a quit button available before hwMainCtrl is up and running
    self.close();
}

var hwCtrlState = {
    actualState : 0, // keeping this in enumeration rather than separate variable
    inDiscoveryScreen:1,
    inAddRemotesScreen:2,
    inZonesDeviceTypeScreen:3,
    inExitDiscoveryScreen: 4,
    checkingDiscoveryStatus:5,
    exitEarlyLynxRemoteDeleted : 6
}

var HoneywellMainCtrl = function() {

    var discoveryComplete = false;
    var thisObj = this;

    var restPath = {
        deviceInstances : null
    }

    var hwTokens = {
        loginToken:null,
        changePanelPinServAction : null
    }

    setState = function(state) {
        hwCtrlState.actualState = state;

    }

    getState = function() {
        return hwCtrlState.actualState;
    }


    changeContinueButtonToCloseButton = function() {
        var buttonElement = document.getElementById("continueButton");
        buttonElement.value = "Close";
        buttonElement.onclick = hwMainCtrl.close;
        btnEnable(buttonElement, 1);
        // cannot cancel anymore since we're done
        btnEnable(document.getElementById("quitb"), 0);

    }

    this.errorCB = function(status) {
        // hwPanel already alerted the user to the error
        // todo process and handle the error
        // 

    }

    this.getDiscoveryStatusCallback = function(status) {
        if (status == 0) {
            discoveryComplete = true;
            processCtrlStates();
        } else {
            // try again - note several second delay between asking for status
            //
            $.doTimeout( 2000, function(){hwPanel.getDiscoveryStatus(function(status){thisObj.getDiscoveryStatusCallback(status)}, function(status){thisObj.errorCB(status)}); } );
        }
    }

    processCtrlStates = function() {
        switch (getState()) {
            //
            case hwCtrlState.inDiscoveryScreen :
                setState(hwCtrlState.inAddRemotesScreen);
                hwRemotesCtrl.run(function(state){thisObj.addRemotesProgressCB(state)});
                break;

            case hwCtrlState.inAddRemotesScreen:
                // do we have to wait for discovery to end ? (applies to lynx only)
                //      alert("in process ctrl states in case and discovery complete is " + discoveryComplete);
                if (!discoveryComplete && hwZonesPanelInfo.panelLynx == true) {
                    setState(hwCtrlState.checkingDiscoveryStatus);
                    //          alert("getting discovery status the first time and getDiscoveryStatusCB is " + getDiscoveryStatusCallback);
                    hwPanel.getDiscoveryStatus(function(status){thisObj.getDiscoveryStatusCallback(status)}, function(status){thisObj.errorCB(status)});
                    // change screens
                    hwViewCtrl.checkDiscoveryStatusScreen();
                }
                else
                {
                    setState(hwCtrlState.inZonesDeviceTypeScreen);
                    hwZonesCtrl.run(function(state){thisObj.zoneTypesDoneCB(state)});
                    break;
                }

            case hwCtrlState.checkingDiscoveryStatus: // only executes for lynx panels
                if (discoveryComplete) {    // todo XXX if this is false, nothing happens on this switch statement
                    setState(hwCtrlState.inZonesDeviceTypeScreen);
                    hwZonesCtrl.run(function(state){thisObj.zoneTypesDoneCB(state)});
                } else {
                   // need to do something since hwZonesCtrl is not running as planned.
                }

                break;

            case hwCtrlState.inZonesDeviceTypeScreen:
            case hwCtrlState.exitEarlyLynxRemoteDeleted:
                if (hwZonesPanelInfo.panelLynx != true)
                {   // for anything but lynx we're done
                    changeContinueButtonToCloseButton();
                    hwViewCtrl.doneScreen();
                } else {
                    // for lynx we need an additional screen
                    // or we are exiting early, see comments in addRemotesProgressCB
                    var buttonElement = document.getElementById("continueButton");
                    btnEnable(buttonElement, 1);
                    buttonElement.onclick = onContinueButton; //
                    // show screen and continue button
                    setState(hwCtrlState.inExitDiscoveryScreen);
                    hwViewCtrl.exitDiscoveryScreen();
                }
                break;

            case hwCtrlState.inExitDiscoveryScreen:
                changeContinueButtonToCloseButton();
                hwViewCtrl.doneScreen();
                break;

            default:
                break;
        }
    }

    //
    onContinueButton = function() {
        processCtrlStates();
    }


    this.close = function() {
        self.close();
    }

    this.quit = function() {
        self.close();
    }


    this.discoveryDoneCB = function(state) {

        if (state == hwDiscoveryState.discoveryConnectionError) {
            // connection error between gateway and lynx
            // give user a chance to run again
            var startover = confirm('There was a problem connecting to the Security Panel. \n\nClick "OK" to try again.');
            if (startover) { //confirm that it's ok
                setState(hwCtrlState.inDiscoveryScreen);
                hwDiscoveryCtrl.run(function(state){thisObj.discoveryDoneCB(state)});
            } else {
                // nothing todo but clear screens, if that...
            }
        } else {
            // set continue button so user can proceed....
            var buttonElement = document.getElementById("continueButton");
            buttonElement.onclick = onContinueButton; // clicking forces processCtrlStates which takes us to next screen
            btnEnable(buttonElement, 1);
        }
    }

    // we have just been called back from hwRemoteCtrl
    this.addRemotesProgressCB = function(state) {

        if(state == hwRemotesState.lynxExistingRemoteDeleted){
            // bug 10130 Race condition when deleting remotes in the zone management wizard
            // user has deleted an existing lynx remote. lynx cannot properly process deleting existing remotes while it is in zone discovery
            // normally from here processCtrlStates would get the zone list and lynx would not provide correct device-types
            // the workaround is force the installer to exit the wizard and start again. Then list will be correct.
            //
            // this makes processCtrlStates display the exit discovery screen next
            setState(hwCtrlState.exitEarlyLynxRemoteDeleted);
        }

        processCtrlStates();

    }

    this.zoneTypesDoneCB = function(state) {

        if (state == hwZonesState.goBackButtonPressed) {
            // go back to add remotes and back sure we indicate state
            setState(hwCtrlState.inAddRemotesScreen);
            hwRemotesCtrl.run(function(state){thisObj.addRemotesProgressCB(state)});
        } else {
            // normal processing
            processCtrlStates();
        }
    }

    //
    //
    this.setupRestFunctionCB = function() {

        hwZonesPanelInfo.panelLynx = hwPanel.getPanelTypeLynx();

        // now we can display screens
        // show sidebar based on panel type
        if (hwZonesPanelInfo.panelLynx == true) {
            hwViewCtrl.sideBarSetupLynx();
        } else {
            hwViewCtrl.sideBarSetupVista();
        }
        //
        // RUN! - panel specific start up
        if (hwZonesPanelInfo.panelLynx == true) {
            setState(hwCtrlState.inDiscoveryScreen);
            hwDiscoveryCtrl.run(function(state){thisObj.discoveryDoneCB(state)});
        } else {
            setState(hwCtrlState.inAddRemotesScreen);
            hwRemotesCtrl.run(function(state){thisObj.addRemotesProgressCB(state)});
        }

    }


    this.getTokenCallback = function(token) {
        hwRest.loginToken = token;
        // get all rest functions upfront
        hwPanel.setupRestFunctions(function(){thisObj.setupRestFunctionCB()}, function(status){thisObj.errorCB(status)});
    }

    this.run = function() {

        var buttonElement;
        //
        // from jsp...
        restPath.deviceInstances = restDeviceInstancesURI; 
        hwRest.saToken = signinAuthToken; 
        hwRest.loginTokenTimeout = loginTokenTimeout; 
        hwRest.deviceInstances = restDeviceInstancesURI;
        hwRest.userName = theUserName;

        // create all the  controllers up front
        hwPanel = new HwPanel();
        //
        hwDiscoveryCtrl = new HwDiscoveryCtrl(hwPanel);
        hwRemotesCtrl = new HwRemoteCtrl(hwPanel);
        hwZonesCtrl = new HwZonesCtrl(hwPanel);

        //
        buttonElement = document.getElementById("continueButton");
        buttonElement.onclick = onContinueButton;
        btnEnable(buttonElement, 0); // till wanted

        hwViewCtrl.determinePanelTypeScreen();
 
        // get log in token now so we have it when needed -
        // callbacks from here keep everything going...
        hwRest.getLoginToken(function(token){thisObj.getTokenCallback(token)});


    }

};

//
// main entry point
//
$(document).ready(function() {
    hwMainCtrl = new HoneywellMainCtrl();

    hwMainCtrl.run();
})




