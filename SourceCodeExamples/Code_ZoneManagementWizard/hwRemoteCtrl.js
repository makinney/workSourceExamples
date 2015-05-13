/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwRemoteCtrl.js
 * @Created: August 2010
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

var hwRemotesState = {
    init : 0,
    remotesEnd : 1,
    lynxExistingRemoteDeleted : 2,
    actualState : 0

}

var hwRemotes = {

    hwUserRemotes : [],

    // creates and returns a remote object with the parameters and functions shown
    // not a user api
    //
    remoteFactory : function(id, remoteName, zoneNumbers, deleteURI, deleteVerb, renameURI, renameVerb, newRemote) {
        return  {  // this is the zone object
            name : remoteName,
            numbers : zoneNumbers,
            id : id,
            deleteUri : deleteURI,
            deleteMethod : deleteVerb,
            renameUri : renameURI,
            renameMethod : renameVerb,
            saved :  false,
            newOne : newRemote || false,
            nameChanged : false,
            zoneChanged : false,
            rawNumbers : "",    // unformatted zone numbers

            getDeleteUri : function() {
                return this.deleteUri;
            },

            getDeleteUriVerb : function() {
                return this.deleteMethod;
            },

            getRenameUri : function() {
                return this.renameUri;
            },

            getRenameUriVerb : function() {
                return this.renameMethod;
            },

            getSaved : function() {
                return this.saved;
            },

            getNameChanged : function() {
                return this.nameChanged;
            },

            getZoneChanged : function() {
                return this.zoneChanged;
            },

            getExisting : function() {
                return (!this.newOne); // if not new then it's existing
            },

            //
            getNew : function() {
                return this.newOne;
            },


            // returns an array of , deliminated zone numbers
            getZoneNumbers : function() {
                return this.numbers;
            },

            getRawZoneNumbers : function(){
                return this.rawNumbers;
            },

            // accepts separated string of zonenumbers
            setZoneNumbers : function(zoneNumbers) {
                this.rawNumbers = zoneNumbers; // in case formatting fails
                var zoneList = zoneNumbers.replace(/[^\d-]+/g,","); //replace anything that's not a digit or - by a ,
                zoneList = zoneList.replace(/^[,-]+|[,-]+$/g,""); //trim leading/trailing , or -
                this.numbers = zoneList.split(","); //split out zone # (or a range of zones separated by -) into array
                // following contributed by Ken S., modified by KevinK
                for (var i = 0; i < this.numbers.length; i++) {
                    var aNum = this.numbers[i];
                    var dashPos = aNum.indexOf("-");
                    if (dashPos != -1) { //if -1, it's just a #, so skip range logic
                        if (dashPos == 0 || dashPos == aNum.length - 1 || aNum.indexOf("-", dashPos + 1) > -1) //skip if invalid range (dash at start, end or > 1 dashes)
                            this.numbers[i] = "";
                        else { //if num is actually a valid range of nums
                            var startRange = parseInt(aNum.split("-")[0]);
                            var endRange = parseInt(aNum.split("-")[1]);
                            if (isNaN(startRange) || isNaN(endRange)) { //garbage value, skip it
                                this.numbers[i] = "";
                            } else if ((startRange > endRange) || (endRange > startRange + 7)) { //skip reverse ranges & ranges spanning > 8 #'s (likely a typo)
                                this.numbers[i] = "";
                            } else {
                                var range = "" + startRange; //save as string
                                for (var j = startRange + 1; j <= endRange; j++) range += "," + j; //add each #
                                this.numbers[i] = range;
                            }
                        }
                    }
                }
                zoneList = this.numbers.join(",");               //join together to do some cleanup
                zoneList = zoneList.replace(/,,+/g, ",");        //get rid of any multiple commas in a row (due to bad ranges above)
                zoneList = zoneList.replace(/^[,]+|[,]+$/g,"");  //trim leading/trailing comma one last time just in case
                this.numbers = zoneList.split(",");              //split again to insert ranges into array
                this.numbers.sort(function(a,b){return a - b});  //and finally, sort the zones array numerically

                this.zoneChanged = true;
            },

            setRemoteName : function(newName) {
                this.name = newName;
                this.nameChanged = true;
            },


            getRemoteName : function() {
                return this.name;
            },

            getRemoteNameEncoded : function(){
                return encodeURIComponent(this.name);
            },

            getId : function() {
                return this.id;
            }
        }
    },

    // user api to create a remote for use by gui / grid as a collection of remotes
    // these remotes may or may not yet exist in the iControl servers.
    // newRemote is optional. set to true for a new remote, defaults to false if not specified in the call
    createRemote : function(id, name, zoneNumbers, deleteUri, deleteVerb, renameUri, renameVerb, newRemote) {
        var remote = this.remoteFactory(id, name, zoneNumbers, deleteUri, deleteVerb, renameUri, renameVerb, newRemote);
        this.hwUserRemotes.push(remote);
        return remote;

    },

    getRemotes : function() {
        return this.hwUserRemotes;
    },

    getRemote : function(id) {
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;
        for (i = 0; i < numRemotes; i++) {
            var remote = remotes[i];
            if (remote != undefined) { // row may have been deleted earlier
                if (remote.getId() == id) {
                    return remote;
                }
            }
        }

        return null;
    },

    // delete from our local collection, only
    deleteRemote : function(id) {
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;
        for (i = 0; i < numRemotes; i++) {
            var remote = remotes[i];
            if (remote != undefined) { // row may have been deleted earlier
                if (remote.getId() == id) {
                    delete remotes[i];
                }
            }
        }

    },

    // returns true if remoteName already exists, except for its own name at remoteId
    isDuplicateName : function(remoteName, remoteId) {
        var remote;
        var id;
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;
        for (i = 0; i < numRemotes; i++) {
            remote = remotes[i];
            if (remote != undefined) { // row may have been deleted earlier
                if (remote.getRemoteName() == remoteName) {
                    // found a dup, make sure it's at a different location from myself
                    id = remote.getId();
                    if (id != remoteId) {
                        return true;
                    }
                }
            }
        }

        return false;
    },

    // returns true if all remotes have a name of length > 0
    // also colors any cells not named
    allRemotesNamed : function() {
        var remote;
        var id;
        var allRemotesDefined = true;
        var remoteNameColNumber = 1; // the grid's column
        var rowData;
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;

        // first set all cells black, effectively erasing a cell prior set to red
        // then below we set cells red as needed, this handles multiple unset names or zones
        for (i = 0;  i < numRemotes; i++){
            remote = remotes[i];
            if (remote != undefined) {
                id = remote.getId();
                jQuery("#idRemoteGridController").jqGrid('setCell', id, remoteNameColNumber, "", {'border': '1px #9DA4AA solid'}, "");
            }
        }

        for (i = 0; i < numRemotes; i++) { // check all remotes, high lighting those without remote names
            remote = remotes[i];
            if (remote != undefined) { // row may have been deleted earlier
                if (remote.getRemoteName().length <= 0) {
                    // found a remote without a name
                    allRemotesDefined =  false;
                    id = remote.getId();
                    // rowData = jQuery("#idRemoteGridController").jqGrid('getRowData', id);
                    // change the cell color for this remote
                    jQuery("#idRemoteGridController").jqGrid('setCell', id, remoteNameColNumber, "", {'border': '2px red solid'}, "");
                }
            }
        }

        return allRemotesDefined;
    },


    // returns true if all remotes have at least one zone number
    // also colors any cells without zone numbers
    allRemotesZoned : function() {
        var remote;
        var id;
        var zoneColNumber = 2;  // the grid's column
        var allZonesDefined = true;
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;
        var zoneNumbers;

        // first set all cells black, effectively erasing a cell prior set to red
        // then below we set cells red as needed, this handles multiple unset names or zones
        for (i = 0;  i < numRemotes; i++){
            remote = remotes[i];
            if (remote != undefined) {
                id = remote.getId();
                jQuery("#idRemoteGridController").jqGrid('setCell', id, zoneColNumber, "", {'border': '1px #9DA4AA solid'}, "");
            }
        }


        for (i = 0; i < numRemotes; i++) { // check all remotes, high lighting those without zone numbers
            remote = remotes[i];
            if (remote != undefined) { // row may have been deleted earlier
                 zoneNumbers = remote.getZoneNumbers().toString().split(",");
                if (zoneNumbers.length <= 1) {
                    // found a remote without at least two zones
                    allZonesDefined = false;
                    // high lite the cell for the user
                    id = remote.getId();
                    // rowData = jQuery("#idRemoteGridController").jqGrid('getRowData', id);
                    jQuery("#idRemoteGridController").jqGrid('setCell', id, zoneColNumber, "", {'border': '2px red solid'}, "");
                }
            }
        }

        return allZonesDefined;
    },


    // returns true if all zones in all remotes are only used once
    // returns false if any zone is used more than once
    // duplicatedZones must be an array and when false we populate duplicatedZones
    //
    allZonesUnique : function(duplicatedZones) {
        var remote;
        var id;
        var allZonesUnique = true;
        var zoneNumbers;
        var zoneNumber;
        var value;
        var numZones;
        var keyPrefix = "key";
        var key;
        var remoteIndex;
        var zoneIndex;
        var zonesUsed = {};
        
        var remotes = this.getRemotes();
        var numRemotes = remotes.length;

        for (remoteIndex = 0; remoteIndex < numRemotes; remoteIndex++) { // check all remotes,
            remote = remotes[remoteIndex];
            if (remote != undefined) { // row may have been deleted earlier
                // get all zone numbers for each remote and see if zone has been used more than once
                zoneNumbers = remote.getZoneNumbers().toString().split(",");
                numZones = zoneNumbers.length;
                for(zoneIndex = 0; zoneIndex < numZones; zoneIndex++){
                    zoneNumber = zoneNumbers[zoneIndex];
                    key = keyPrefix + zoneNumber.toString();
                    value = zonesUsed[key];
                    if(value == undefined){
                      // first time detected using this zone number
                      value = "x"; // any thing works, does not have to be unique, just need a value to map to the zoneNumber key
                      zonesUsed[key] = value; // add key to map with associated value
                    } else {
                      // since value exists zone has already been used at least once
                      //
                      allZonesUnique = false;
                      // used by caller to display duplicated zone numbers
                      //
                      duplicatedZones.push(zoneNumber); // the zoneNumber is not the array index

                    }
                }
            }
        }

        return allZonesUnique;
    },


    //    getZone : function(zoneNumber) {
    //        for (i = 0; i < this.hwUserRemotes.length; i ++) {
    //
    //            var zone = this.hwUserRemotes[i];
    //            if (zone.number == zoneNumber) {
    //                return zone;
    //            }
    //        }
    //        return null;
    //    },

    removeAllRemotes : function() {
        this.hwUserRemotes.length = 0;
    }

}


var HwRemoteCtrl = function(hwPanel) {

    var panel = hwPanel;
    var mainCallback = null;
    var thisObj = this;
    var lynxExistingRemoteDeleted = false;

    var addingRemoteError = "adding a remote";
    var deletingRemoteError = "deleting the remote";
    var editingRemoteError =  "editing a remote";
    var renamingRemoteError = "renaming a remote";

    var lastRemoteSavedName = " ";

    // all done
    setExitState = function(){

        if(lynxExistingRemoteDeleted){ // special case, see usage in mainCallback
            hwRemotesState.actualState = hwRemotesState.lynxExistingRemoteDeleted;
            // alert has to go here and not in hwMainCtrl. If in hwMainCtrl the alert will block partial clearing of screen and it will looks corrupted
            // by doing this here, the alert will popup over a complete fully painted non-corrupted screen
            alert("NOTE: A remote was deleted. You will need to take the security panel out of discovery mode and re-start this assistant to continue.\n" +"Click OK to proceed");
        } else {
            hwRemotesState.actualState = hwRemotesState.remotesEnd;
        }

    }

    // req is XmlHttpRequest type
    this.errorCallback = function(req, remoteOperationError) { // remoteOperationError not presently used, but left in code

        var status = req.status;
        var errorType = null;

        if(status == 500){ // only error code we care about here, others are processed in hwPanel.js errorHandlerCB
            errorType = req.getResponseHeader("X-error");
            if(errorType != null){

                // alert("errorType is " + errorType + " and response text is " + req.responseText);

                if(errorType.toString().toLowerCase() == "panel.badzone"){
                    alert("Failed to add remote named \"" + lastRemoteSavedName + "\" because zone " + req.responseText + " is not enabled on the security panel.\n" + "Click \"OK\", then click the \"Go Back\" button to return to the Remotes Setup step and correct the problem.");
                    // continue trying to add any other remotes
                    this.saveRemoteSuccessCB("status"); // even if we keep getting errorCallbacks, this call will eventually exit
                }
            }

        } else if(status != 200){ // some other error type that we cannot process, stop trying to add remotes
 
            hwViewCtrl.removeProgressDotsFromScreen(); // ok to call even if no dots displaying
            // informs user if deleted existing lynx and set's actualState
            setExitState(); // must come before grid unload, otherwise a partially cleared screen will show under setExitState alert
            // be tidy
            $("#idRemoteGridController").GridUnload();
            mainCallback(hwRemotesState.actualState); // continue to next screen...
        }

     }

    // this is adding a remote to the grid for user entry - not adding it to the server yet
    onAddRemoteButton = function() {
        // create default remote naming and numbering
        //
        var remoteName = "";
        var numRemotes = hwRemotes.getRemotes().length;
        var zoneNumber = "";
        // use numRemotes for index because it increases for each added remote
        var newRemote = true;
        var remote = hwRemotes.createRemote(numRemotes, remoteName, zoneNumber, null, null, null, null, newRemote); // not creating on server, but for local use
        // display it in the grid
        hwRemoteGridCtrl.addRow(numRemotes, remoteName, zoneNumber);

    }


    this.remoteNameChangeCB = function(value, row, event) {
        //    alert("in remoteNameChangeCB with value and row of  " + value + " "  + row);
        var remote = hwRemotes.getRemote(row);
        if (remote != null) {
            
            if ((value.length > 0) && !validNameFormat(value)) {
                alert("Remote Name contains invalid characters.\n" + "Remote Name can contain letters A-Z, a-z, numbers 0-9, and most symbols except for \" (double-quote) and | (vertical bar).");
                return;
            }

            if (!hwRemotes.isDuplicateName(value, row)) {
                remote.setRemoteName(value);
            } else {
                alert("Remote names must be unique.");
            }
        }
    }

    this.zoneNumberChangeCB = function(value, row, event) {
        //  alert("in zoneNumberChagneCB with value and row of " + value + " " + row);
        var zoneNumbers;
        var rawZoneNumbers;
        var remote = hwRemotes.getRemote(row);
        if (remote != null) {
            remote.setZoneNumbers(value);

            // make sure zone numbers entered were acceptable and if not inform user
            // when setZoneNumbers cannot not parse the rawZoneNumbers, it returns a empty string
            zoneNumbers = remote.getZoneNumbers().toString();
            zoneNumbers = $.trim(zoneNumbers); // 
            if(zoneNumbers == null || zoneNumbers == undefined || zoneNumbers.length == 0){ //
                rawZoneNumbers = remote.getRawZoneNumbers().toString();
                rawZoneNumbers = $.trim(rawZoneNumbers);
                if(rawZoneNumbers.length > 0){ // make sure user entered something, otherwise we alert as user clicks between empty cells
                    alert("\"" + rawZoneNumbers + "\" is not valid for Zone Numbers.");
                }
            }
            // write formatted value back to grid
            // this takes cell out of edit mode so we cannot use it
            // jQuery("#idRemoteGridController").jqGrid('setCell', row, 'number', remote.getZoneNumbers());
        }
    }

//    // not presently used by grid control
//    this.keydownCallback = function(value, row, col, event)
//    {
//        //      alert("blur with value " + value + " row " + row + " and evenType " + event.type + " and eventWhich " + event.which + " and keycode " + event.keyCode + " and charcode " + event.charCode);
//    }


    // continue saving the remotes.... e.g. adding them to the system
    // save one per callback until nothing more to save
    // note how saveOneRemote forms a control loop by calling this very saveRemoteSuccessCB
    this.saveRemoteSuccessCB = function(status) {

        var remoteSaved = saveOneRemote();

        // anything added this loop ?
        if (!remoteSaved) {
            // done adding remotes
            setExitState(); // informs user if deleted existing lynx and set's actualState
            // continue to next screen, note grid has already been unloaded and we been showing the adding remotes screen
            mainCallback(hwRemotesState.actualState); // continue to next screen...
        }
    }

    // only saves one remote, if any, per call
    // returns true if a remote saved, false otherwise
    // false means nothing more to save... all done
    //
    saveOneRemote = function() {
        var usedThisRemote = false;
        var remoteName;
        var zoneNumbers;

        //
        var remotes = hwRemotes.getRemotes();
        var numRemotes = remotes.length;
        while (numRemotes > 0 && !usedThisRemote) {
            var remote = remotes.shift();
            if (remote != undefined) { // row may have been deleted earlier
                remoteName = remote.getRemoteNameEncoded(); // since remoteName will be used in url post data (fixes bug 10491)
                zoneNumbers = remote.getZoneNumbers();
                // anything to save ?
                if (remote.getNew()) { // new ones must be saved into the system
                    // must pass thisObj, not 'this' to following so as to avoid global this during callback
                    lastRemoteSavedName = remote.getRemoteName(); // in case we have to report error cause
                    panel.addRemote(remoteName, zoneNumbers, function(status){thisObj.saveRemoteSuccessCB(status)}, function(req){thisObj.errorCallback(req, addingRemoteError)});
                    usedThisRemote = true;   // all done this time
                } else {
                    // existing remotes only take action if something has changed
                    if (remote.getZoneChanged()) {

                        if(remote.getDeleteUri() != null){ // in case iHub does not support function
                            // must pass thisObj, not 'this' to following so as to avoid global this during callback
                            // zone numbers changing require a delete and an add, cannot use rename
                            // editRemoteZones does a delete, waits for successful REST response, then does the add, then does the callback to here
                            lastRemoteSavedName = remote.getRemoteName(); // in case we have to report error cause
                            panel.editRemoteZones(remote.getDeleteUri(),remote.getDeleteUriVerb(), remoteName, zoneNumbers, function(status){thisObj.saveRemoteSuccessCB(status)}, function(req){thisObj.errorCallback(req, editingRemoteError)});
                            usedThisRemote = true;   // all done this time
                        } else {
                            alert("Cannot edit zone name or zone number");
                        }
                    } else if (remote.getNameChanged()) {
                        // if just the name changed, then we do not have to delete it first
                        if(remote.getRenameUri() != null){
                            // must pass thisObj, not 'this' to following so as to avoid global this during callback
                            lastRemoteSavedName = remote.getRemoteName(); // in case we have to report error cause
                            panel.renameRemote(remote.getRenameUri(), remote.getRenameUriVerb(), remoteName, function(status){thisObj.saveRemoteSuccessCB(status)}, function(req){thisObj.errorCallback(req, renamingRemoteError)});
                            usedThisRemote = true;   // all done this time
                        } else {
                            alert("Cannot edit zone name");
                        }
                    }
                }
            }
            // must update each loop since we're shifting out array elements
            numRemotes = remotes.length;
        }

        return usedThisRemote;

    }

    // user has clicked continue button
    // begin adding new remotes, saving changed remotes
    onRemoteContinueButton = function() {

        // must call both of these methods to insure all grid cells are error formatted if something not defined
        var remotesNamed = hwRemotes.allRemotesNamed();
        var remotesZoned = hwRemotes.allRemotesZoned();

        if (!remotesNamed || !remotesZoned) {
            alert("All remotes must have a name and at least two zone numbers assigned");
            return;
        }

        // any zone used more than once, get the list of same and display
        var duplicatedZones = [];
        var numDuplicates;
        var duplicatedZonesList = "";
        if(!hwRemotes.allZonesUnique(duplicatedZones)){
            numDuplicates = duplicatedZones.length;
            if(numDuplicates > 0) { // be cautious just in case.. so we do not display a alert with no numbers
                for(i = 0; i < numDuplicates; i++){
                    if(duplicatedZonesList.length == 0){
                        duplicatedZonesList = duplicatedZones[i].toString();
                    } else {
                        duplicatedZonesList += ", " + duplicatedZones[i].toString();
                    }
                }
                
                if(numDuplicates == 1){
                    alert("Zone " + duplicatedZonesList + " is listed more than once.");
                } else {
                    alert("Zones " + duplicatedZonesList + " are listed more than once.");
                }
                return; // cannot proceed until fixed
            }
        }

        // only allow user one click on continue button then disable it
        // otherwise they could try and add remotes multiple times....
        buttonElement = document.getElementById("continueButton");
        btnEnable(buttonElement, 0);

        var remoteSaved = saveOneRemote();  // this starts callbacks

        // anything ?
        if (!remoteSaved)
        {
            // exit to show next screen
            // be tidy
            // informs user if deleted existing lynx and set's actualState
            setExitState(); // must come before grid unload, otherwise a partially cleared screen will show under setExitState alert
            $("#idRemoteGridController").GridUnload();
            mainCallback(hwRemotesState.actualState); // continue to next screen...
          } else {
            // at least one remote added.... show progress screen
            // be tidy (also no need to call setExitState here, as we are not done adding remotes
            $("#idRemoteGridController").GridUnload();
            hwViewCtrl.addRemotesProgressScreen();
        }

    }


    //
    //
    // get existing remotes...
    createExistingRemotesFromXmlLynx = function(xml)
    {

        //       alert("in createExistinRemotesfromXML");
        var deleteUri = null;
        var deleteVerb = null;
        var renameUri = null;
        var renameVerb = null;
        var remote = null;
        var name;
        var zones;
        var rowIndex = 0;

        $(xml).find("instance[hwtype$='REMOTE']").each(function() {
            $(this).find("name").each(function() {
                name = $(this).text();
                return false; // breaks out of this .each, does not return from method
            });

            $(this).find("function[mediaType='instances/delete']").each(function() {
                deleteUri = $(this).attr("action");
                deleteVerb = $(this).attr("method");
                return false; // breaks out of this .each
            });

            $(this).find("function[mediaType='instances/rename']").each(function() {
                renameUri = $(this).attr("action");
                renameVerb = $(this).attr("method");
                return false; // breaks out of t his .each
            });

            $(this).find("point[mediaType='container/zones']").each(function() {
                zones = $(this).text();
                remote = hwRemotes.createRemote(rowIndex, name, zones, deleteUri, deleteVerb, renameUri, renameVerb);
                rowIndex++;
                return false; // break out of this .each, does not return from method
            });

        });

    }

    createExistingRemotesFromXmlVista = function(xml)
    {

        //       alert("in createExistinRemotesfromXML");
        var deleteUri = null;
        var deleteVerb = null;
        var renameUri = null;
        var renameVerb = null;
        var remote = null;
        var name;
        var zones;
        var rowIndex = 0;

        $(xml).find("instance[hwtype$='Remote']").each(function() {
            $(this).find("name").each(function() {
                name = $(this).text();
                return false; // breaks out of this .each, does not return from method
            });

            $(this).find("function[mediaType='instances/delete']").each(function() {
                deleteUri = $(this).attr("action");
                deleteVerb = $(this).attr("method");
                return false; // breaks out of this .each
            });

            $(this).find("function[mediaType='instances/rename']").each(function() {
                renameUri = $(this).attr("action");
                renameVerb = $(this).attr("method");
                return false; // breaks out of t his .each
            });

            $(this).find("point[mediaType='container/zones']").each(function() {
                zones = $(this).text();
                remote = hwRemotes.createRemote(rowIndex, name, zones, deleteUri, deleteVerb, renameUri, renameVerb);
                rowIndex++;
                return false; // break out of this .each, does not return from method
            });

        });

    }


    this.gotRemotesCB = function(data) {

        var remoteName;
        var zoneNumbers;
        var remotes;

        //
        if(panel.getPanelTypeLynx()){
            createExistingRemotesFromXmlLynx(data);
        } else {
           createExistingRemotesFromXmlVista(data); 
        }

        // now that we have gotten and parsed the xml
        // switch from the progress screen previously set
        // and setup buttons, but do not show..
        var buttonElement = document.getElementById("addRemoteButton");
        btnEnable(buttonElement, 1);
        buttonElement.onclick = onAddRemoteButton;

        //
        buttonElement = document.getElementById("continueButton");
        btnEnable(buttonElement, 1);
        buttonElement.onclick = onRemoteContinueButton;

        // the actual grid
        //
        hwRemoteGridCtrl.initRemoteGrid(function(value, row, event){thisObj.remoteNameChangeCB(value, row, event)},
                function(value, row, event){thisObj.zoneNumberChangeCB(value, row, event)}, function(row){thisObj.rowDeleted(row)});
        $("#idRemoteGridController").jqGrid('hideCol', "id"); // this column means nothing to the user, but we need it for indexing
        $("#idRemoteGridController").show();

        // now display the screen  and the buttons
        hwViewCtrl.remotesSetupScreen();

        // add to display grid
        var numRemotes = hwRemotes.getRemotes().length;
        for (var i = 0; i < numRemotes; i++) {

            // display it in the gird
            remotes = hwRemotes.getRemotes();
            remoteName = remotes[i].getRemoteName();
            zoneNumbers = remotes[i].getZoneNumbers();
            // add rows of existing remotes to grid
            hwRemoteGridCtrl.addRow(i, remoteName, zoneNumbers);
        }

    }

//    this.rowDeletedCB = function() {
//        // could use this to confirm the delete happened
//    }
//
//
   // delete button clicked in grid at location 'row'
    this.rowDeleted = function(row) {
        var remote = hwRemotes.getRemote(row);
        // var meObj = this;

        if (remote != null) {

            if (remote.getExisting() == true) {// if not existing nothing to delete
                if(remote.getDeleteUri() != null){
                    if(panel.getPanelTypeLynx()){
                     lynxExistingRemoteDeleted = true; // flag for later use when we exit
                    }
                    panel.deleteRemote(remote.getDeleteUri(), remote.getDeleteUriVerb(), function(msg){thisObj.errorCallback(msg, deletingRemoteError)});
                } else {
                    alert("Delete remote not supported by panel. Still removing from grid");
                }
            }
            // remove remote from our collection of remotes, so we don't try and add it back later
            hwRemotes.deleteRemote(row);
        }

        // always remove row, even if there's no remote
        $('#idRemoteGridController').delRowData(row);   // remove from grid
    }

    this.run = function(callback) {

        mainCallback = callback;  //
        lynxExistingRemoteDeleted = false; // make sure reset every time we run
        // var meObj = this;
        // make sure no remotes around from previous run
        // we reload the present state next
        hwRemotes.removeAllRemotes();
        // it can take time to get all the remotes, so show a progress screen
        hwViewCtrl.remotesSetupLoadingScreen();
        // start getting existing before showing setup screen
        // 
        panel.getInstancesXML(function(data){thisObj.gotRemotesCB(data)}, function(){thisObj.errorCallback()});


    };
}