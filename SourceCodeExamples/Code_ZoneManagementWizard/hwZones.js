/*
 * Copyright iControl Networks, All Rights Reserved.
 *
 * @File:    hwZones.js
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


var hwZonesState = {
    init : 0,
    goBackButtonPressed : 1
}

var hwDeviceTypeDisplayableNames = {

    select : "--Select--",
    door : "Door or Window",
    motion : "Motion",
    glass : "Glass Break",
    shock : "Shock",
    fire : "Fire (Smoke/Heat)",
    carbon : "Carbon Monoxide",
    water : "Water/Flood",
    freeze : "Freeze",
    temperature : "High/Low Temperature",
    pressureMat : "Pressure Mat",
    buttonArmAway : "Button: Arm-Away",
    buttonArmStay : "Button: Arm-Stay",
    buttonDisarm : "Button: Disarm",
    buttonAudible : "Button: Audible Alarm",
    buttonFire : "Button: Fire Alarm",
    buttonPersonal : "Button: Personal Emergency",
    buttonSilent :"Button: Silent Alarm",
    buttonControl : "Button: Control (No Alarm)",
    buttonAudible24h : "Single-Button Audible Alarm",
    buttonSilent24h : "Single-Button Silent Alarm",
    buttonPersonal24h : "Single-Button Personal Emergency",
    siren : "Siren",
    buttonSystem : "System Zone"

}

var SupportedDeviceTypes = function(panelTypeLynx) {  //

    //
    var zoneSelectOptions = [];
    var deviceTypes;

    var lynxDeviceTypes = {
        none : hwDeviceTypeDisplayableNames.select,
        DWSZone : hwDeviceTypeDisplayableNames.door,
        PIRZone : hwDeviceTypeDisplayableNames.motion,
        GLASSBREAKZone : hwDeviceTypeDisplayableNames.glass,
        SHOCKZone  : hwDeviceTypeDisplayableNames.shock,
        FIREZone  : hwDeviceTypeDisplayableNames.fire,
        SmokeZone  : hwDeviceTypeDisplayableNames.fire,
        COZone : hwDeviceTypeDisplayableNames.carbon,
        FLOODZone : hwDeviceTypeDisplayableNames.water,
        FREEZEZone : hwDeviceTypeDisplayableNames.freeze,
        TEMPERATUREZone  : hwDeviceTypeDisplayableNames.temperature,
        BUTTONARMSTAYZone : hwDeviceTypeDisplayableNames.buttonArmStay,
        BUTTONARMAWAYZone : hwDeviceTypeDisplayableNames.buttonArmAway,
        BUTTONDISARMZone  : hwDeviceTypeDisplayableNames.buttonDisarm,
        BUTTONAUDIBLEZone : hwDeviceTypeDisplayableNames.buttonAudible,
        BUTTONSILENTZone : hwDeviceTypeDisplayableNames.buttonSilent,
        BUTTONFIREZone   : hwDeviceTypeDisplayableNames.buttonFire,
        BUTTONPERSONALZone  : hwDeviceTypeDisplayableNames.buttonPersonal,
        BUTTONCONTROLZone : hwDeviceTypeDisplayableNames.buttonControl,
        AUDIBLE24HZone : hwDeviceTypeDisplayableNames.buttonAudible24h,
        SILENT24HZone : hwDeviceTypeDisplayableNames.buttonSilent24h,
        PERSONAL24HZone : hwDeviceTypeDisplayableNames.buttonPersonal24h,
        SYSTEMZone : hwDeviceTypeDisplayableNames.buttonSystem

    }

    var vistaDeviceTypes = {

        none : hwDeviceTypeDisplayableNames.select,
        DoorWindowZone : hwDeviceTypeDisplayableNames.door,
        MotionZone : hwDeviceTypeDisplayableNames.motion,
        GlassBreakZone : hwDeviceTypeDisplayableNames.glass,
        ShockZone  : hwDeviceTypeDisplayableNames.shock,
        FireZone  : hwDeviceTypeDisplayableNames.fire,
        SmokeZone  : hwDeviceTypeDisplayableNames.fire,
        COZone : hwDeviceTypeDisplayableNames.carbon,
        WaterFloodZone : hwDeviceTypeDisplayableNames.water,
        FreezeZone : hwDeviceTypeDisplayableNames.freeze,
        TemperatureZone  : hwDeviceTypeDisplayableNames.temperature,
        PressureMatZone : hwDeviceTypeDisplayableNames.pressureMat,
        ButtonArmStayZone : hwDeviceTypeDisplayableNames.buttonArmStay,
        ButtonArmAwayZone : hwDeviceTypeDisplayableNames.buttonArmAway,
        ButtonDisarmZone  : hwDeviceTypeDisplayableNames.buttonDisarm,
        ButtonAudibleZone : hwDeviceTypeDisplayableNames.buttonAudible,
        ButtonSilentZone : hwDeviceTypeDisplayableNames.buttonSilent,
        ButtonFireZone   : hwDeviceTypeDisplayableNames.buttonFire,
        ButtonPersonalZone  : hwDeviceTypeDisplayableNames.buttonPersonal,
        ButtonControlZone : hwDeviceTypeDisplayableNames.buttonControl,

        Audible24hZone : hwDeviceTypeDisplayableNames.buttonAudible24h,
        Silent24hZone : hwDeviceTypeDisplayableNames.buttonSilent24h,
        Personal24hZone : hwDeviceTypeDisplayableNames.buttonPersonal24h,

        SirenZone : hwDeviceTypeDisplayableNames.siren,

        SystemZone : hwDeviceTypeDisplayableNames.buttonSystem
        
    }

    if (panelTypeLynx == true) {
        deviceTypes = lynxDeviceTypes;
    } else {
        deviceTypes = vistaDeviceTypes;
    }

    // given optionValue (as downloaded from zone list) return the option name for the option
    //
    this.getDisplayableDeviceTypeName = function(optionValue) {

        var name = deviceTypes[optionValue];
        if (name != undefined) {
            return name;
        }

        return "";
    }

    // build a select pick list from the available device type options for this zone and save it with the zone
    // only need to call this one time for each zone
    this.buildSelectOptionsHTML = function(zone) {

        var selectedDeviceType; // = zone.getSelectedDeviceType(); // may already have a setting
        var selectOptions = '<select>';

        var deviceTypeOption;
        var deviceTypeName;
        var deviceTypeOptions;
        var length;


        // if an option value is selected='true' when pulling zone info from xml
        // then this returns the corresponding option value
        // otherwise it's null or undefined
        selectedDeviceType = zone.getSelectedDeviceType(); //

        if (selectedDeviceType == null || selectedDeviceType.length == 0)
        {
            zone.setSelectedDeviceType('none'); // this will force --Select-- to display in the picklist
        }

        // make sure we have the latest
        selectedDeviceType = zone.getSelectedDeviceType();
        deviceTypeOptions = zone.getDeviceTypeOptions()
        length = deviceTypeOptions.length;
        // now build options html
        for (var i = 0; i < length; i++) {

            deviceTypeOption = deviceTypeOptions[i];
            deviceTypeName = this.getDisplayableDeviceTypeName(deviceTypeOption);
            if (deviceTypeName.length > 0) {
                if (selectedDeviceType == deviceTypeOption) { // will not match if selectedDeviceType == 'none'
                    selectOptions += "<option selected=\'true\' value=\'" + deviceTypeOption + "\'>" + deviceTypeName + "</option>";
                } else {
                    selectOptions += "<option value=\'" + deviceTypeOption + "\'>" + deviceTypeName + "</option>";
                }
            }
        }


        selectOptions += "</select>";

        zone.setDeviceTypeOptionsHTML(selectOptions);  //

        return selectOptions;

    }

}


var hwZones = {

    hwPanelZones : [],


    // creates a zone object with the parameters and functions shown
    // not a user api
    zoneFactory : function(o) {
        return  {  // this is the zone object
            name : o.name,
            number : o.number,
            containerName : o.containerName,
            deviceTypeHTML : null,
            updateZoneRestURI : null,
            updateZoneRestMethod : null,
            deviceTypeOptions : [],
            deviceType : null,

            getUpdateZoneRestURI : function() {
                return this.updateZoneRestURI;
            },

            setUpdateZoneRestURI : function(uri) {
                this.updateZoneRestURI = uri;
            },

            getUpdateZoneRestMethod : function() {
                return this.updateZoneRestMethod;
            },

            setUpdateZoneRestMethod : function(uri) {
                this.updateZoneRestMethod = uri;
            },

            getName : function() {
                return this.name;
            },

            setName : function(newName) {
                this.name = newName;
            },

            getContainerName : function() {
                return this.containerName;
            },

            getNumber : function() {
                return this.number;
            },

            getSelectedDeviceType : function() {
                return this.deviceType;
            },

            setSelectedDeviceType :function(type) {


                if (type.length <= 0 || type.toLowerCase() == "otherzone")
                {
                    type = 'none';
                }
                this.deviceType = type;

               // alert("set device type of zone is " + type);
            },

            getDeviceTypeOptionsHTML : function() {
                return this.deviceTypeHTML;
            },

            setDeviceTypeOptionsHTML :function(type) {
                this.deviceTypeHTML = type;
            },

            getDeviceTypeOptions : function() {
                return this.deviceTypeOptions;
            },

            addDeviceTypeOption : function(option) {
                this.deviceTypeOptions.push(option);
            }


        }
    },

    // user api to create a zone,
    // o has these fields : number, name, deviceType, containerName
    createZone : function(o) {
        zone = this.zoneFactory(o);
        this.hwPanelZones.push(zone); // collection of zones
        return zone;

    },

    getZones : function() {
        return this.hwPanelZones;
    },


    getZone : function(zoneNumber) {
        for (i = 0; i < this.hwPanelZones.length; i ++) {

            var zone = this.hwPanelZones[i];
            if (zone.number == zoneNumber) {
                return zone;
            }
        }
        return null;
    },

    // sorts zones in array from smallest to largest zone number
    sortAscendingNumerically :function() {
        // a, b are values at zone indexes and therefore a,b are zones
        //
        this.hwPanelZones.sort(function(a, b) {
            return a.getNumber() - b.getNumber()
        });
    },


    removeAllZones : function() {
        this.hwPanelZones.length = 0;
    },

    allZonesDefined : function() {

        zones = hwZones.getZones();

        var zone;
        var id;
        var zoneNameColNumber = 1; // in the grid
        var allZonesHaveTypes = true;
        var numZones;

        if (zones == null || zones == undefined) {
            return false;
        }

        if (zones.length == 0) {
            return true; // no zones should not prevent continuing
        }

        numZones = zones.length;

        // first set all cells black, effectively erasing a cell prior set to red
        // then below we set cells red as needed, this handles multiple unset names or zones
        for (i = 0;  i < numZones; i++){
            zone = zones[i];
            if (zone != null) {
                id = zone.getNumber();
                jQuery("#idZoneGridController").jqGrid('setCell', id, zoneNameColNumber, "", {'border': '1px #D3D3D3 solid'}, "");
            }
        }


        for (i = 0; i < numZones; i ++) {
            zone = zones[i];
            if (zone.getSelectedDeviceType() == 'none') {
//                alert("first zone detected without a device type is " + zone.getName());
                id = zone.getNumber();
                jQuery("#idZoneGridController").jqGrid('setCell', id, zoneNameColNumber, "", {'border': '2px red solid'}, "");
                allZonesHaveTypes =  false;
            }
        }

        return allZonesHaveTypes;
    }


}

var HwZonesCtrl = function(hwPanel) {

    var panel = hwPanel;
    var thisObj = this;

    var panelTypeLynx = true;  // default
    var numberOfZonesAdded = 0;
    var mainCallback = null;
    //   var numCapturedEvents = 0;
    var supportedDeviceTypes = null;

    this.errorCallback = function() {
        // hwPanel alerted the user to the error... do not want multiple alerts to user

    }

    addPanelZonesToGrid = function(zones, gridCtrl) {

        var zoneName;
        var zoneNameColNumber = 1;  // the grid's column
        var selectedDeviceTypeName;
        for (i = 0; i < zones.length; i ++) {
            zone = zones[i];
            // if it exists use containername for zonename, otherwise just regular zone name, per prd
            zoneName = zone.getContainerName();
            if (zoneName == null || zoneName.length == 0 || zoneName.toLowerCase() == 'sensor') {
                zoneName = zone.getName();
            }

            selectedDeviceTypeName = supportedDeviceTypes.getDisplayableDeviceTypeName(zone.getSelectedDeviceType());
            gridCtrl.addRow(zone.getNumber(), zoneName, selectedDeviceTypeName);

            // color any text that has 'check' in it.  This is for corner case where lynx is displaying 'check' on it's
            // display (due to a sensor problem). When in discovery mode, it uses 'check' as the zone name, not the real name
            if(zoneName.indexOf("Check",0) >= 0 ){
                jQuery("#idZoneGridController").jqGrid('setCell', zone.getNumber(), zoneNameColNumber, "", {'color': 'red'}, "");
            }
        }
    };

    // for all zones get available device type options and create select pick list ready for rendering
    //
    createSelectOptionsHTML = function(zones) {
        var zone = null;
        for (i = 0; i < zones.length; i ++) {
            zone = zones[i];
            if (zone != null) {
                supportedDeviceTypes.buildSelectOptionsHTML(zone);
            }
        }

    }

     this.saveAllZones = function() {

        if (saveAzone() != true) {
            // all done
            mainCallback();
        }
    }

    // if saves a zone returns true
    // returning false means no more zone to save
    saveAzone = function() {
        var zone;
        var zoneAdded = false;
        var zones = hwZones.getZones();
        zone = zones.shift(); // this removes elements from array to where eventually it returns null (or undefined ?)
        if (zone != null && zone != undefined)
        {
            panel.updateZoneInfo(zone.getUpdateZoneRestURI(), zone.getUpdateZoneRestMethod(), zone.getNumber(), zone.getSelectedDeviceType(),
                    function() {thisObj.saveAllZones()}, function() {thisObj.errorCallback()});
            zoneAdded = true;
        }

        return zoneAdded;
    }




    // todo not be used anymore...
    this.processZoneTypeChanged = function(devicetype, selectedRow, selectedCol) {
        //    alert("in processZoneTypeChanged deviceType is " + deviceType + " and row and col is " + selectedRow + " " + selectedCol);
        //    numCapturedEvents++; // todo for debug only
        if (selectedCol === 2) { // make sure in correct cell

            var zone = hwZones.getZone(selectedRow); // . is zone number,
            // console.log("zone is " + zone);
            if (zone !== null)
            {
                zone.setSelectedDeviceType(devicetype);   // update with user selected type
            }
            else
            {
                //            alert("DEBUG : zone is null in processZoneTypeChanged"); // todo
            }
        }
    };

    //
    createZonesFromXML = function(xml)
    {
        var uri = null;
        var zone = null;
        var iteration = 0;
        var selectedType = null;

        $(xml).find("zone").each(function() {
            zone = hwZones.createZone({
                name : $(this).attr("name"),
                number : $(this).attr("zoneno"),
                containerName : $(this).attr("containerName")
            })

            $(this).find("function[mediaType='zone/add']").each(function() {
                zone.setUpdateZoneRestURI($(this).attr("action"));   // UpdateZoneInfo
                zone.setUpdateZoneRestMethod($(this).attr("method"));

                $(this).find("input[name='deviceType']").each(function() {

                    $(this).find("option").each(function() {
                        zone.addDeviceTypeOption($(this).text());
                        selectedType = $(this).attr("selected");
                        if (selectedType != null && selectedType != undefined) {
                            zone.setSelectedDeviceType($(this).text());
                        }
                    });
                });


            });
        });

    }


    this.gotZoneListCB = function(data) {

        createZonesFromXML(data);
        // sort so lowest zones with lowest numbers appear first in grid
        // note this is not using grid sorting and thus grid sorting should be turned off
        hwZones.sortAscendingNumerically(); // per prd so

        createSelectOptionsHTML(hwZones.getZones());

        // now that progress screen is finished and we are ready to use these buttons
        // enable these buttons
        var buttonElement = document.getElementById("continueButton");
        buttonElement.onclick = onZoneContinueButton;
        btnEnable(buttonElement, 1); //

        buttonElement = document.getElementById("goBackButton");
        buttonElement.onclick = onGoBackButton; // on click processing
        btnEnable(buttonElement, 1); // enable

        // now actually show the screen and buttons
        //
        hwViewCtrl.selectDeviceTypeScreen();

        // init the zone select grid MUST come after setting the continueButton or the dynamic drop down lists will not work
        // for device type.  Might be a this ptr is thrown off, something about writing the dom messes up the grid
        // even displaying an alert box will stop the grid from working
        // 
        hwZoneGridCtrl.initZoneSelectGrid(changedCallback, hwZones);

        $("#zoneSelectGrid").show();

        addPanelZonesToGrid(hwZones.getZones(), hwZoneGridCtrl); //
    }


    onZoneContinueButton = function() {

        if (hwZones.allZonesDefined())
        {
            // do not let user click continue twice
            var buttonElement = document.getElementById("continueButton");
            btnEnable(buttonElement, 0); //
            // save everything
            // it takes time to save all the zones..
            $("#idZoneGridController").GridUnload();  // be tidy
            hwViewCtrl.selectDeviceTypeUpdateZonesScreen();
            thisObj.saveAllZones();
            
        } else {
            alert("All devices must have a Device Type selected before continuing.");
            // must do this here, after the alert box, or grid will stop functioning
            hwZoneGridCtrl.initZoneSelectGrid(null, hwZones);
        }
    }


    onGoBackButton = function() {
        //    alert("onGoBackButton click in hwZones");
        // be tidy
        $("#idZoneGridController").GridUnload();
        // controller will switch to correct screen
        mainCallback(hwZonesState.goBackButtonPressed);
    }


    this.run = function(callback) {
        //    alert("in zones run 1");
        mainCallback = callback;
        panelTypeLynx = panel.getPanelTypeLynx();
        //   var zoneList;

        changedCallback = this.processZoneTypeChanged;  //  todo not used

        supportedDeviceTypes = new SupportedDeviceTypes(panelTypeLynx);

        // show loading message and progress dots
        hwViewCtrl.selectDeviceTypeLoadingScreen();

        // remove any possible old zones
        hwZones.removeAllZones();
        // get list of zones to populate grid
        // we init zone select grid out of a in the following callback... see methods comments
        // zoneList = panel.getZoneList(gotZoneListCB);

        panel.getZoneList(function(data) {thisObj.gotZoneListCB(data)});

    };

}

//         $("#continueButton").removeAttr("disabled");  // enable button
//         $("#continueButton").removeClass().addClass("p_btn p_btnMnormal");
//         $("#continueButton").attr("disabled", "disabled");
//            $("#continueButton").removeClass().addClass("p_btn p_btnMdisabled");