/*
 * Copyright iControl Networks, All Rights Reserved.
 * 
 * @File:    hwAjax.js
 * @Created: July 2010
 * @Author:  Michael A Kinney
 *
 * Description : Developed specifically for support of Honeywell Zone Management.
 *               Uses jQuery ajax methods
 *
 * @Usage     (Public Interfaces):
 *
 * @Method    getLoginToken
 *
 *
 * @Method    getChangeDeviceTypeURI
 *
 * @Returns   REST URI for function getChangeDeviceType
 *
 * @Method
 *
 *
 * @Param
 */

// i18n support. actual text defined elsewhere
//


var hwRest = {

    loginToken : null,
    saToken : null,
    loginTokenTimeout : null,
    userName : null,
    deviceInstances : null,

    // ajax call to get token pin using rest
    // on success,  returns token in callback
    // on failure, calls hwZonesAjax.errorCallback with xhr request result and jQuery error text
    //
    getLoginToken :function(callback, errorCallback) {
        try
        {
            $.ajax({
                type: 'get',
                url: "../myaccount/GetAuthToken?sat=" + hwRest.saToken + "&duration=" + hwRest.loginTokenTimeout,
                success: function(resp)
                {

                },
                error: function(req, errorText)
                {
                    if (errorCallback != null)
                        errorCallback(req, errorText);
                },
                complete: function(xhr)
                {
                    callback(xhr.getResponseHeader("X-Token"));
                }
            });
        } catch(e) {

        }
    },



    // this is as it sounds, an xml file of device instances, from a rest call
    // used for further searching...
    getDeviceInstancesXML : function(parserCallback, successCallback, errorCallback)
    {

        $.ajax({
            type: 'get',
            url: hwRest.deviceInstances,
            cache: false,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            success: function(data, status, req)
            {
                parserCallback(data, successCallback);
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            },
            dataType: "xml"
        });

    },

    // this is as it sounds, an xml file of instances, from a rest call
    // this is very similar to getDeviceInstancesXML, except it does not first parse the xml
    // if this was java rather than js, I would overload getDeviceInstancesXML and leave parserCallback out of the method parms
    getInstancesXML : function(successCallback, errorCallback)
    {

        $.ajax({
            type: 'get',
            url: hwRest.deviceInstances,
            cache: false,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);       
            },
            success: function(data, status, req)
            {
                successCallback(data);
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            },
            dataType: "xml"
        });

    },


    // start actual discovery process
    startDiscovery : function(rest, successCallback, errorCallback) {
        $.ajax({
            url: rest.uri,
            type: rest.method,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            data: "mode=" + 1,
            success: function(resp) {
                successCallback();
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });
    },

     // cancel discovery process
    cancelDiscovery : function(rest, successCallback, errorCallback) {
        $.ajax({
            url: rest.uri,
            type: rest.method,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            success: function(resp) {
                successCallback();
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });
    },

    getDiscoverStatus : function(rest, successCallback, errorCallback)
    {
      $.ajax({
            url: rest.uri,
            type: rest.method,
            cache : false,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            complete: function(xhr)
            {
                successCallback(xhr.responseText);
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    },

    addRemote : function(rest, remoteName, remoteZones, successCallback, errorCallback)
    {

        $.ajax({
            url: rest.uri,
            type: rest.method,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            data: "name=" + remoteName +  "&zones=" + remoteZones,
            success: function(resp) {
                successCallback();
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    },


    deleteRemote : function(uri, uriVerb, successCallback,  errorCallback)
    {

        $.ajax({
            url: uri,
            type: uriVerb,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },

             success: function(resp) {
                if(successCallback != null){
                    successCallback();
                }
            },
          
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    },


    renameRemote : function(uri, uriVerb, remoteName, successCallback, errorCallback)
    {

        $.ajax({
            url: uri,
            type: uriVerb,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            data: "name=" + remoteName,
            success: function(resp) {
                successCallback();
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    },

    updateZoneInfo : function(uri, method, zoneNumber, deviceType, successCallback, errorCallback)
    {
  
        $.ajax({
            url: uri,
            type: method,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            data: "zoneNo=" + zoneNumber +  "&deviceType=" + deviceType,
            success: function(resp) {
                successCallback();
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    },

    getZoneListXML : function(rest, callback, errorCallback)
    {

        $.ajax({
            url: rest.uri,
            type: rest.method,
            cache: false,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);       
            },
            success: function(data, status, req)
            {
                callback(data);
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            },
            dataType: "xml"
        });

    },

    getConnectionStatus : function(rest, successCallback, errorCallback)
    {

        $.ajax({
            type: 'get', // hard coded because there is no 'method' attribute in the instances xml for connection status
            url: rest.uri,
            cache: false,
            beforeSend: function(xmlhttp) {
                xmlhttp.setRequestHeader('X-login', hwRest.userName);
                xmlhttp.setRequestHeader('X-token', hwRest.loginToken);
            },
            complete: function(xhr)
            {
                successCallback(xhr.responseText);
            },
            error: function(req, errorText) {
                if (errorCallback != null)
                    errorCallback(req, errorText);
            }
        });

    }

}