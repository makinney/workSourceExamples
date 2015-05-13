/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwMainViews.js
 * @Created: July 24 2010
 * @Author:  Michael A Kinney
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
 *
 *
 * External variables
 *
 * hwZonesPanelInfo
 *
 */


var hwViewCtrl = {

    sideBar : {
        hiliteStep : function(stepNumber) {
            $("#sideBarTitleStep" + stepNumber).removeClass().addClass("subHeadOn");
        },
        normalLiteStep : function(stepNumber) {
            $("#sideBarTitleStep" + stepNumber).removeClass().addClass("subHeadInactive");
        },
        normalLiteAllSteps : function() {
            for (step = 1; step < 5; step += 1) {
                this.normalLiteStep(step);
            }
        },
        hiliteOnlyStep : function(stepNumber) {
            this.normalLiteAllSteps();
            this.hiliteStep(stepNumber);

        }
    },

    sideBarSetupLynx : function() {

        $('#sideBarTitleStep1').text("Step One");
        $('#sideBarDescriptionStep1').text("Enter Zone Discovery Mode");

        $('#sideBarTitleStep2').text("Step Two");
        $('#sideBarDescriptionStep2').text("Remotes Setup");

        $('#sideBarTitleStep3').text("Step Three");
        $('#sideBarDescriptionStep3').text("Select Device Types");

        $('#sideBarTitleStep4').text("Step Four");
        $('#sideBarDescriptionStep4').text("Exit Zone Discovery Mode");

        $('#sideBarTitleStep5').text("Step Five");
        $('#sideBarDescriptionStep5').text("Done");

    },

    sideBarSetupVista : function() {

        $('#sideBarTitleStep1').text("Step One");
        $('#sideBarDescriptionStep1').text("Remotes Setup");

        $('#sideBarTitleStep2').text("Step Two");
        $('#sideBarDescriptionStep2').text("Select Device Types");

        $('#sideBarTitleStep3').text("Step Three");
        $('#sideBarDescriptionStep3').text("Done");

    },

       // hide all buttons, except the cancel button
    hideAllButtons : function(){
        $("#addRemoteButton").hide();
        $("#goBackButton").hide();
        $("#continueButton").hide();
    },


    addProgressDotsToScreen : function() {

        $('#spinner').html("<img src=\"../images/animatedDots.gif\"/> ");

    },

    removeProgressDotsFromScreen : function() {

        $('#spinner').html(" ");

    },
    
    //
    //
    enterDiscoveryScreen : function() {

        if (!hwZonesPanelInfo.panelLynx) { // only valid for this panel
            return;
        }

        $("#continueButton").show();

        hwViewCtrl.sideBar.hiliteOnlyStep("1");

        $('#mainHeadingTitle').text("Step One");
        $('#mainHeadingTitleSubTitle').text("Enter Zone Discovery Mode");

        $('#stepInstructions').html("The next few steps assist you in managing zone devices.<br/><br/>" +
                "1. Confirm that you have armed and disarmed the security panel from the Web Portal since signing in.<br/>"+
                "IMPORTANT: If you have not performed this step, click <strong>Cancel</strong> below, perform an arm and disarm on the Summary tab, then re-launch this assistant. <br/><br/>" +
                "2. Put the Security Panel into Zone Discovery Mode then click <strong>Continue</strong>.<br/><br/>" +
                "<span><strong>Installer code + [#] + [6] + [6]</strong></span>");

        this.addProgressDotsToScreen();
    },


    determinePanelTypeScreen : function() {

        this.hideAllButtons();

        $('#mainHeadingTitle').text("");
        $('#mainHeadingTitleSubTitle').text("Determine Panel Type");

        $('#stepInstructions').html("Determining your security panel type. This may take a moment.<br/>");

        this.addProgressDotsToScreen();
    },

    remotesSetupScreen : function() {

        this.removeProgressDotsFromScreen(); 
        this.hideAllButtons();
        // now show the ones we need
        $("#addRemoteButton").show();
        $("#continueButton").show();

        // side pane - step name dependent on panel type
        // rather than two similar showRemotesSetup methods
        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step One");
            hwViewCtrl.sideBar.hiliteOnlyStep("1");

        } else {
            $('#mainHeadingTitle').text("Step Two");
            hwViewCtrl.sideBar.hiliteOnlyStep("2");
        }

        // main pane heading
        $('#mainHeadingTitleSubTitle').text("Multi-Button Wireless Remotes Setup");

        // details
        $('#stepInstructions').html("Create an entry below for every installed wireless remote with 2 or more buttons, such as keychain remotes" +
                " and handheld remotes. Enter the zone numbers associated with each remote, separated by commas.<br/><br/>" +
                "For example: Mom\'s Keyfob &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;30,31,32,33<br/>");

    },

     remotesSetupLoadingScreen : function() {

        this.hideAllButtons();

        // side pane - step name dependent on panel type
        // rather than two similar showRemotesSetup methods
        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step One");
            hwViewCtrl.sideBar.hiliteOnlyStep("1");

        } else {
            $('#mainHeadingTitle').text("Step Two");
            hwViewCtrl.sideBar.hiliteOnlyStep("2");
        }

        // main pane heading
        $('#mainHeadingTitleSubTitle').text("Multi-Button Wireless Remotes Setup");

        // details
        $('#stepInstructions').html("Looking for existing remotes. This may take a moment... <br/>");

        this.addProgressDotsToScreen();

    },


    addRemotesProgressScreen : function() {

        this.hideAllButtons();

        // side pane - step name dependent on panel type
        // rather than two similar showRemotesSetup methods
        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step One");
            hwViewCtrl.sideBar.hiliteOnlyStep("1");

        } else {
            $('#mainHeadingTitle').text("Step Two");
            hwViewCtrl.sideBar.hiliteOnlyStep("2");
        }

        // main pane heading
        $('#mainHeadingTitleSubTitle').text("Multi-Button Wireless Remotes Setup");

        // details
        $('#stepInstructions').html("Adding remotes...<br/>");

        this.addProgressDotsToScreen();

    },

    checkDiscoveryStatusScreen : function() {

        this.hideAllButtons();

        // side pane - step name dependent on panel type
        // rather than two similar showRemotesSetup methods
        // not since this screen occurs just before getting zones
        // we're going to show the step that correlates with selecting device tpes
        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step Two");
            hwViewCtrl.sideBar.hiliteOnlyStep("2");

        } else {
            $('#mainHeadingTitle').text("Step Three");
            hwViewCtrl.sideBar.hiliteOnlyStep("3");
        }

        // main pane heading
        $('#mainHeadingTitleSubTitle').text("Select Device Types");

        // details
        $('#stepInstructions').html("Retrieving zones from security panel. This may take several minutes...<br/>");

        this.addProgressDotsToScreen();

    },

    selectDeviceTypeScreen : function() {

        this.removeProgressDotsFromScreen();
        this.hideAllButtons(); //
        // show the ones we really need
        $("#continueButton").show();
        $("#goBackButton").show();

        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step Two");
            hwViewCtrl.sideBar.hiliteOnlyStep("2");

        } else {
            $('#mainHeadingTitle').text("Step Three");
            hwViewCtrl.sideBar.hiliteOnlyStep("3");
        }

        // main pane heading
        $('#mainHeadingTitleSubTitle').text("Select Device Types");

        // details
        $('#stepInstructions').html("All devices must have a Device Type selected before continuing.<br/>");

    },

    selectDeviceTypeLoadingScreen : function() {

         this.hideAllButtons();

         if (!hwZonesPanelInfo.panelLynx) {
             $('#mainHeadingTitle').text("Step Two");
             hwViewCtrl.sideBar.hiliteOnlyStep("2");

         } else {
             $('#mainHeadingTitle').text("Step Three");
             hwViewCtrl.sideBar.hiliteOnlyStep("3");
         }

         // main pane heading
         $('#mainHeadingTitleSubTitle').text("Select Device Types");

         // details
         $('#stepInstructions').html("Loading zones list. This may take a moment... <br/>");

         this.addProgressDotsToScreen();

     },

    selectDeviceTypeUpdateZonesScreen : function() {

          this.hideAllButtons();

          if (!hwZonesPanelInfo.panelLynx) {
              $('#mainHeadingTitle').text("Step Two");
              hwViewCtrl.sideBar.hiliteOnlyStep("2");

          } else {
              $('#mainHeadingTitle').text("Step Three");
              hwViewCtrl.sideBar.hiliteOnlyStep("3");
          }

          // main pane heading
          $('#mainHeadingTitleSubTitle').text("Select Device Types");

          // details
          $('#stepInstructions').html("Saving device types. This may take a moment... <br/>");

          this.addProgressDotsToScreen();
    },


    exitDiscoveryScreen : function() {

        this.removeProgressDotsFromScreen(); // maybe left over from progress screen...
        this.hideAllButtons();
        // the one we need for this screen
        $("#continueButton").show();
        
        if (!hwZonesPanelInfo.panelLynx) { // only valid for this panel
            return;
        }

        $('#mainHeadingTitle').text("Step Four");   // only care about this for Lynx
        $('#mainHeadingTitleSubTitle').text("Exit Zone Discovery Mode");
        hwViewCtrl.sideBar.hiliteOnlyStep("4");

        $('#stepInstructions').html("You must now take the Security Panel out of Zone Discovery Mode.<br/><br/>" +
                "<span><strong>Installer code + [OFF]</strong></span>");

    },

    doneScreen : function() {

        this.removeProgressDotsFromScreen(); // maybe left over from progress screen...

        this.hideAllButtons();
        $("#continueButton").show();

        if (!hwZonesPanelInfo.panelLynx) {
            $('#mainHeadingTitle').text("Step Three");
            hwViewCtrl.sideBar.hiliteOnlyStep("3");

        } else {
            $('#mainHeadingTitle').text("Step Five");
            hwViewCtrl.sideBar.hiliteOnlyStep("5");
        }

        $('#mainHeadingTitleSubTitle').text("Done");

        $('#stepInstructions').html("<br/><br/><br/><br/><br/>Changes were saved successfully.<br/>");

    },

    clearScreen : function() {
        // todo
        $('#mainHeadingTitle').text("");
        $('#mainHeadingTitleSubTitle').text("");
        $('#stepInstructions').html(""); // todo xxx should this, could this be .text instead ?

        // todo XXX what happens if grid not loaded yet ?
        $("#idRemoteGridController").GridUnload();
        $("#idZoneGridController").GridUnload();

        $("#addRemoteButton").hide();
        $("#goBackButton").hide();

        this.removeProgressDotsFromScreen();
    }



};


var lastsel = -1;
hwRemoteGridCtrl = {

    deviceTypeColumnNumber : "2", // starting at column 0
    selectedRow : -1,
    selectedCol : -1,
    rowDeletedCB : null,
 
    rowDeleted : function(row){
      rowDeletedCB(row);  // callback to hwRemoteCtrl
    },

    initRemoteGrid : function(remoteNameChangeCallback, zoneChangeCallback, rowDeletedCallback) {

        rowDeletedCB = rowDeletedCallback;
        // must assign these two here to fix scope closure problem where both undefined until user makes a grid selection
        selectedRow = 1;

        jQuery("#idRemoteGridController").jqGrid({
            editurl:'clientArray',
            datatype: 'local',
            colNames:['ID', 'Remote Name', 'Zone Numbers', ' '],
            colModel:[
                {name:'id', index:'id', width:25, hidden:true, editable:false, sortable:false, classes:'jqGridText'},
                {name:'name', index:'name', width:250, sorttype:"text", editable:true, classes:'jqGridText',
                    editoptions:{size:"37", maxlength:gMaxLenDeviceName,
                        dataEvents:[
                            {type: 'blur', fn: function(event) {
                           //     alert("calling remoteNameChangeCallback with callback " + remoteNameChangeCallback + " value " + this.value + " row " + selectedRow);
                                remoteNameChangeCallback(this.value, selectedRow, event);
                                selectedCol = 1;
                            }}// ,
                            //                        {type: 'blur', fn: function(event) {
                            //                            selectedCol = 1;
                            //                            keydownCallback(this.value, selectedRow, selectedCol, event);
                            //                        }}
                        ]}},
                {name:'number', index:'number', width:250, sorttype:"text", editable:true, classes:'jqGridText',
                    editoptions:{size:"37", maxlength:50,
                        dataEvents:[
                            //                        {type: 'blur', fn: function(event) {
                            //                            selectedCol = 2;
                            //                            keydownCallback(this.value, selectedRow, selectedCol, event);
                            //                       }},
                            {type: 'blur', fn: function(event) {
                               zoneChangeCallback(this.value, selectedRow, event);
    
                            }}
                        ]}},
                {name:'act', index:'act', width:101, sortable:false, classes:'jqGridText'}
            ],
            altRows : false,
            scrollrows : true,
            height : '161',

            onSelectRow: function(id) {
                if (id && id !== lastsel) {
                    jQuery(this).saveRow(lastsel, false, 'clientArray'); // don't save to server, let client handle it
                    lastsel = id;
                }
                selectedRow = id;
                jQuery(this).editRow(id, false);
            },
            // one way to get selected row and col when data changes and user closes select control
            //            onCellSelect: function(rowid, iCol) {
            //                console.log("on cell select rowid " + rowid + ' col id ' + iCol);
            //                selectedRow = rowid;
            //                selectedCol = iCol;
            //            },
            gridComplete: function() {
                var ids = jQuery("#idRemoteGridController").jqGrid('getDataIDs');
                for (var i = 0; i < ids.length; i++) {
                    var cl = ids[i]; // cl is row number
                    ce = "<input class='p_btn p_btnMnormal' type='button' value='Delete' alt='Delete' onclick=\"hwRemoteGridCtrl.rowDeleted('" + cl + "');\" "
                        + "onmouseover=\"javascript:btnHover(this,'M')\" onmouseout=\"javascript:btnNormal(this,'M')\" onmousedown=\"javascript:btnDown(this,'M')\" onmouseup=\"javascript:btnNormal(this,'M')\" />";
                    jQuery("#idRemoteGridController").jqGrid('setRowData', ids[i], {act:ce});
                }
            }
        })

        //Set header text alignment
        jQuery("#idRemoteGridController").jqGrid('setLabel', 'name', '', {'text-align':'left'});
        jQuery("#idRemoteGridController").jqGrid('setLabel', 'number', '', {'text-align':'left'});

    },

    addRow : function(rowId, remoteName, zoneNumbers) {
        var newRowData = {id:rowId,name:remoteName,number:zoneNumbers};
        jQuery("#idRemoteGridController").jqGrid('addRowData', newRowData.id, newRowData);
    }



    //    destroyGrid : function(gridId) {
    //        jQuery("#zoneSelect")
    //    }

}

// dummy placeholder required by grid else events will not work correctly for 'select' device type editing
var supportedSelectOptions = {
    none: "--Select--"
}

hwZoneGridCtrl = {

    deviceTypeColumnNumber : "2", // starting at column 0
    selectedRow : -1,
    selectedCol : -1,
    zones : null,
    changedCallback : null,
   
    //  zoneChangedCallback : null,

    selectFunctionCB : function(req)
    {
     //   alert("a select Function CB");
        var selectedOptions = "";
        var zoneNumber = jQuery("#idZoneGridController").jqGrid('getCell', selectedRow, 0);   // 0 is first column
        var zone = zones.getZone(zoneNumber);
        if(zone != null){
            selectedOptions = zone.getDeviceTypeOptionsHTML();
        }
        
        return selectedOptions;
    },

//    selectChangeCallback : function(value, row, col){
//        alert("in select change callback callback is " + changedCallback);
//        changedCallback(value, row, col);
//    },

    initZoneSelectGrid : function(callback, zonesCtrl) {

        changedCallback = callback; // todo not used

        // must assign these two here to fix scope closure problem where both undefined until user makes a grid selection
        selectedRow = 1;
        selectedCol = 2;
        zones = zonesCtrl;


        jQuery("#idZoneGridController").jqGrid({
            datatype: 'local',
            colNames:['Zone', 'Name', 'Device Type'],
            colModel:[

                {name:'id', index:'id', width:50, sorttype:"int", editable:false, classes:'jqGridText', align:'center'},
                {name:'name', index:'name', width:250, sorttype:"text", editable:false, classes:'jqGridText', editoptions:{size:"50",maxlength:"50"}},
                {name:'device', index:'device', width:300, editable:true, edittype:"select", classes:'jqGridText', editoptions:{value:supportedSelectOptions,
                    dataUrl:"../wizard/HWselectOptionsServ", buildSelect:this.selectFunctionCB,
                    dataEvents:[
                        {type: 'blur', fn: function() {
                            // alert("callback from grid for device select with value " + this.value + " selected row and col " + selectedRow + " " + selectedCol);
                            var zone = zones.getZone(selectedRow); // . is zone number,
                            if (zone !== null)
                            {
                                //alert("calling zone.setSelectedDeviceType with value " + this.value);
                                zone.setSelectedDeviceType(this.value);   // update with user selected type
                            }

                        }}
                    ]}}
            ],
            altRows : false,
            scrollrows : true,
            height : '250',
            cellEdit: true,

            cellsubmit:'clientArray',

            // one way to get selected row and col when data changes and user closes select control
            onCellSelect: function(rowid, iCol) {
        //        alert("on cell select rowid " + rowid + ' col id ' + iCol);
                selectedRow = rowid;
                selectedCol = iCol;

                //        alert("on cell select selectedRow is " + selectedRow);
            }

        })

        //Set header text alignment
        jQuery("#idZoneGridController").jqGrid('setLabel', 'id', '', {'text-align':'center'});
        jQuery("#idZoneGridController").jqGrid('setLabel', 'name', '', {'text-align':'left'});
        jQuery("#idZoneGridController").jqGrid('setLabel', 'device', '', {'text-align':'left'});

    },

    addRow : function(zoneNumber, zoneName, selectedDeviceTypeName) {
        var newRowData = {id:zoneNumber,name:zoneName, device:selectedDeviceTypeName};
        jQuery("#idZoneGridController").jqGrid('addRowData', newRowData.id, newRowData);
    },


    editDeviceTypeCell  : function(rowNumber) {
        $("#idZoneGridController").jqGrid('editCell', rowNumber, this.deviceTypeColumnNumber, false);
    }

    //    destroyGrid : function(gridId) {
    //        jQuery("#zoneSelect")
    //    }

}
