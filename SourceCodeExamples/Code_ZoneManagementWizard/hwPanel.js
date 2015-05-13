// todo - list of public methods
//
/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwZones.js
 * @Created: July 21 2010
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

var hwZonesUser = {
    problemMakingChanges : " ",
    httpError401Text : " ",
    httpError404Text : " ",
    httpError408Text : " ",
    httpError500Text : " ",
    httpError503Text : " ",
    httpErrorGenericText : " "
};


var HwPanel = function() {

    var startDiscoveryRestFunction = {};
    var cancelDiscoveryRestFunction = {};
    var discoveryStatusRestFunction = {};
    var addRemoteRestFunction = {};
    var getZoneListRestFunction = {};
    var getConnectionStatusRestFunction = {};

    var startDiscoveryErrorCallback = null;
    var cancelDiscoveryErrorCallback = null;
    var getDiscoveryStatusErrorCallback = null;
    var getConnectionStatusErrorCallback = null;
    var addRemoteErrorCallback = null;
    var deleteRemoteErrorCallback = null;
    var getZoneListErrorCallback = null;
    var updateZoneInfoErrorCallback = null;
    var addZonesErrorCallback = null;
    var renameRemoteErrorCallback = null;
    var deleteRemoteErrorCallback = null;

    var getRestFunctionSuccessCallback = null;
    var getRestFunctionsErrorCallback = null;

    var panelTypeLynx = false;

    var thisObj = this;

    extractStartDiscoveryFunction = function(xml, rest)
    {
        var uri = null;
        var verb = null;
        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("function[mediaType='discovery/start']").each(function()
            {
                rest.uri = $(this).attr("action");
                rest.method = $(this).attr("method");
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });

        return uri;
    };

    extractCancelDiscoveryFunction = function(xml, rest)
    {
        var uri = null;
        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("function[mediaType='discovery/stop']").each(function()
            {
                rest.uri = $(this).attr("action");
                rest.method = $(this).attr("method");
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });

        return uri;
    };

    extractConnectionStatusFunction = function(xml, rest)
    {
        var uri = null;
        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("point[mediaType='device/connection-status']").each(function()
            {
                rest.uri = $(this).attr("href");
                rest.method = null; // there is no 'method' attribute for points
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });

        return uri;
    };


    extractDiscoveryStatusFunction = function(xml, rest)
    {
        var uri = null;
        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("function[mediaType='discovery/status']").each(function()
            {
                rest.uri = $(this).attr("action");
                rest.method = $(this).attr("method");
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });

        return uri;
    };


    extractAddRemoteFunction = function(xml, rest)
    {
        var uri = null;

        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("function[mediaType='remote/add']").each(function()
            {
                rest.uri = $(this).attr("action");
                rest.method = $(this).attr("method");
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });

        return uri;

    };

    extractZoneListFunction = function(xml, rest)
    {
        var uri = null;

        $(xml).find("instance[hwtype$='security-panel']").each(function()
        {
            $(this).find("function[mediaType='zones/list']").each(function()
            {
                rest.uri = $(this).attr("action");
                rest.method = $(this).attr("method");
                return false; // break out of this .each (does not return out of method
            });

            if (uri != null)
                return false; // all done break out of this .each (does not return out of method)
        });


        return uri;
    };


    //////////////////////////////////////////////////
    // returns true if lynx, false otherwise
    parsePanelTypeLynx = function(xml)
    {
        var panelIsLynx = false;
        $(xml).find("instance[hwtype$='lynx-security-panel']").each(function()
        {
            panelIsLynx = true;
        });

        return panelIsLynx;
    };


    this.setupRestFunctionsCB = function(instancesXML)   // todo - is this being called correctly, setup correctly?
    {
        extractStartDiscoveryFunction(instancesXML, startDiscoveryRestFunction);
        extractCancelDiscoveryFunction(instancesXML, cancelDiscoveryRestFunction);
        extractDiscoveryStatusFunction(instancesXML, discoveryStatusRestFunction);
        extractConnectionStatusFunction(instancesXML, getConnectionStatusRestFunction);
        extractAddRemoteFunction(instancesXML, addRemoteRestFunction);
        extractZoneListFunction(instancesXML, getZoneListRestFunction);
        // also get panel type, since we have the xml
        panelTypeLynx = parsePanelTypeLynx(instancesXML);

        getRestFunctionSuccessCallback();

    }

    this.setupRestFunctions = function(successCallback, errorCallback)
    {
        getRestFunctionSuccessCallback = successCallback;
        hwRest.getInstancesXML(function(xml){thisObj.setupRestFunctionsCB(xml)}, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    }

    this.startDiscovery = function(successCallback, errorCallback) {
        startDiscoveryErrorCallback = errorCallback;
        hwRest.startDiscovery(startDiscoveryRestFunction, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };

     this.cancelDiscovery = function(successCallback, errorCallback) {
        cancelDiscoveryErrorCallback = errorCallback;
        hwRest.cancelDiscovery(cancelDiscoveryRestFunction, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };


    // on success, successCallback called with discovery status (example 'Waiting...', or 1 or 0
    //
    this.getDiscoveryStatus = function(successCallback, errorCallback) {
        getDiscoveryStatusErrorCallback = errorCallback;
        hwRest.getDiscoverStatus(discoveryStatusRestFunction, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };


    //
    this.getConnectionStatus = function(successCallback, errorCallback) {
        getConnectionStatusErrorCallback = errorCallback;
        hwRest.getConnectionStatus(getConnectionStatusRestFunction, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };

    //
    this.addRemote = function(remotesName, remotesZoneNumbers, successCallback, errorCallback) {
        addRemoteErrorCallback = errorCallback;
        hwRest.addRemote(addRemoteRestFunction, remotesName, remotesZoneNumbers, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };

     //
    this.deleteRemote = function(uri, uriVerb, successCallback, errorCallback) {
        deleteRemoteErrorCallback = errorCallback;
        var sCallback = successCallback || null;  // ok if this is null, hwRest simply will not make the call
        hwRest.deleteRemote(uri, uriVerb, sCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };

      //
    this.renameRemote = function(uri, uriVerb, remotesName, successCallback, errorCallback) {
        renameRemoteErrorCallback = errorCallback;
        hwRest.renameRemote(uri, uriVerb, remotesName, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };

    this.deleteRemoteForEditsCB = function(){
        hwRest.addRemote(addRemoteRestFunction, editRemotesName, editRemotesZoneNumbers,editRemotesSuccessCB,function(req, msg){thisObj.errorHandlerCB(req, msg)} );
    };


    this.editRemoteZones = function(deleteZonesUri, deleteZoneUriVerb, remotesName, remotesZoneNumbers, successCallback, errorCallback){
          editRemotesName = remotesName;
          editRemotesZoneNumbers = remotesZoneNumbers
          editRemotesSuccessCB = successCallback;
          addRemoteErrorCallback = errorCallback;
          hwRest.deleteRemote(deleteZonesUri, deleteZoneUriVerb, function(){thisObj.deleteRemoteForEditsCB()}, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };


    // returns zone list as xml in successCallback
    this.getZoneList = function(successCallback, errorCallback) {
        getZoneListErrorCallback = errorCallback;
       hwRest.getZoneListXML(getZoneListRestFunction, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});
    };


    // returns device instances xml as data passed to successCallback
    //
    this.getInstancesXML = function(successCallback, errorCallback) {
        //
        hwRest.getInstancesXML(successCallback, errorCallback);
    };

    // returns true if lynx panel ( or quick-connect), false otherwise
    //
    this.getPanelTypeLynx = function() {
        return panelTypeLynx;
    }

    //
    this.updateZoneInfo = function(zoneInfoURI, zoneInfoRestMethod, zonesNumber, deviceType, successCallback, errorCallback) {
        addZonesErrorCallback = errorCallback; //
        hwRest.updateZoneInfo(zoneInfoURI, zoneInfoRestMethod, zonesNumber, deviceType, successCallback, function(req, msg){thisObj.errorHandlerCB(req, msg)});

    };


    this.errorHandlerCB = function(req, errorText) {
        var errorMsg = null;
        var status = null;

        if(req != null && req != undefined){
            status = req.status;
        }

        if (status == null || status == undefined )
            return; // cannot process 

        if (status == 500) {

            var errorType = req.getResponseHeader("X-error"); // NB - not guaranteed to be non-null

            if (errorType != null) {
                // presently only iHub for SWP / Vista provides X-error headers
                // for these we need to process not here but in the callbacks that are passed 'req', such as addRemoteErrorCallback,
                // because need to take more specific action based on errorType
                // errorType = errorType.toLowerCase();
                // do not want to alert here and in the callback, by not setting errorMsg, the alert below will not happen,
                // errorMsg = errorType;
            } else { // 500 error but error type not defined
                errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + hwZonesUser.httpError500Text;
            }
        }
        else if (status == 401) {
            errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + hwZonesUser.httpError401Text;
        }
        else if (status == 404) {
            errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + hwZonesUser.httpError404Text;
        }
        else if (status == 408) {
            errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + hwZonesUser.httpError408Text;
        }
        else if (status == 503) {
            errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + hwZonesUser.httpError503Text;
        }
        else { // treat all others as errors, note errorHandlerCB would not be called for normal status code of 200

            var genericMsg = hwZonesUser.httpErrorGenericText;
            // replace placeholder with real error code
            // alert("status is " + status);
            // alert("error text is " + status);

            if (status !== undefined)
            {
                errorMsg = genericMsg.replace("[errorcode]", status);
            } else {
                errorMsg = errorText;
            }

            if (errorText != undefined && errorText.toLowerCase() == 'timeout') // jquery ajax timeout
            {
                errorMsg = "Timed out " + errorMsg; // Timed out (Code: WPR-[errorcode])
            }

            errorMsg = hwZonesUser.problemMakingChanges + "\n\n" + errorMsg;


        }

        // tell the user
        if(errorMsg != null)
        {
            alert(errorMsg);
        }

        // callback the error to the methods caller, to let each decide how to use the error info
        // this way we can use a single error handler here in hwPanel
        if (startDiscoveryErrorCallback != null) {
            startDiscoveryErrorCallback(status);
        }

        if (getDiscoveryStatusErrorCallback != null) {
            getDiscoveryStatusErrorCallback(status);
        }


        if (getConnectionStatusErrorCallback != null) {
            getConnectionStatusErrorCallback(status);
        }


        if (getConnectionStatusErrorCallback != null) {
            getConnectionStatusErrorCallback(status);
        }

        if (addRemoteErrorCallback != null) {
            addRemoteErrorCallback(req);
        }

        if (renameRemoteErrorCallback != null){
            renameRemoteErrorCallback(req);
        }

        if (deleteRemoteErrorCallback != null) {
            deleteRemoteErrorCallback(req);
        }

        if (updateZoneInfoErrorCallback != null) {
            updateZoneInfoErrorCallback(status);
        }

        if (addZonesErrorCallback != null) {
            addZonesErrorCallback(status);
        }

        if (getZoneListErrorCallback != null) {
            getZoneListErrorCallback(status);
        }

        if (cancelDiscoveryErrorCallback != null) {
            cancelDiscoveryErrorCallback(status);
        }

       
    };


}