<%@include file= "../template/docType.template"%>
<%@include file= "../template/i18nHeader.template"%>
<icg:bundle id="icg" basename="commons, portal">
<% // ---

    String PROBLEM_MAKING_CHANGES = "There was a problem. Try again in a few seconds.";

    String HTTP_ERROR_401_TEXT = "Unable to authenticate with the server. (Code: WPT-401)";
    String HTTP_ERROR_404_TEXT = "(Code: WPT-404)";
    String HTTP_ERROR_408_TEXT = "Unable to communicate with the gateway. (Code: WPT-408)";
    String HTTP_ERROR_500_TEXT = "Unable to communicate with the server. (Code: WPR-500)";
    String HTTP_ERROR_503_TEXT = "Gateway went offline during update. (Code: WPR-503)";
    String HTTP_ERROR_GENERIC_TEXT = "(Code: WPR-[errorcode])";

    //refresh the cache key if needed so we get the latest information when this page loads
    Utilities.syncRefresh(request);

    //Button string constants:
    String STR_BTN_QUIT = "Cancel";
    String STR_BTN_PREVIOUS = "Go Back";
    String STR_BTN_NEXT = "Continue";
    String STR_BTN_FINISH = "Finish";
    String STR_BTN_SKIP = "Skip";
    String STR_BTN_TRYAGAIN = "Try Again";
    String STR_BTN_ADDMORE = "Add More";

    String technologyHTML = "Vista";
    NetworkUIPreferences nuiprefs = CacheUtility.getNUIPrefs(session);

//    boolean allowHW = (nuiprefs.getAllowHWAdd() && (nuiprefs.getAllowHWSensorAdd()));
//    boolean canEditDevices = nuiprefs.displayManageDevices();
//    if (!canEditDevices || (canEditDevices && !allowHW)) {
//        String username = (String) session.getAttribute("username");
//        Utilities.logSecurityWarning("User '" + username + "' attempted to access hwZonesManager.jsp but does not have permission.");
//        response.sendRedirect(request.getContextPath() + "/access/accessdenied.jsp");
//        return;
//    }

    //find partner preferences to may affect what we show
    User userobj = (User) session.getAttribute("user");

    //see if we're allowed to add more HW devices
    int maxHWDevices = nuiprefs.getMaxHoneywellDevices();
    String maxstr = userobj.getPreference(Util.SERVICE_LIMIT_MAX_HONEYWELL_DEVICES);
    if (maxstr != null && maxstr.length() > 0) {
        maxHWDevices = Integer.parseInt(maxstr);
    }


    int lynxDevices = Utilities.getDeviceCount(session, "lynxgsm", null);
    if (lynxDevices > 0) {
        technologyHTML = "lynxgsm"; // todo - probably do not need this
        %>
          <%--<script type="text/javascript">--%>
              <%--var panelTypeLynx = true;--%>
          <%--</script>--%>
        <%
    }


    int currHWDevices = Utilities.getDeviceCount(session, "HW", null) + lynxDevices;
    if (currHWDevices >= maxHWDevices) {
        //disallow add -- max reached
        session.setAttribute("errormsg", "Maximum number of Honeywell devices have been added.");
        response.sendRedirect("../access/error.jsp");
        return;
    }

    //lookup all device id's to find already taken zone numbers
    String networkManagerURL = (String) session.getAttribute("networkManagerURL");
    String sNetwork = (String) session.getAttribute("networkid");
    String partner = (String) session.getAttribute("partner");
    NetworkManager nm = NetworkManager.getInstance(networkManagerURL, partner, sNetwork);

    String userid    = (String)session.getAttribute("userid");
    if ((java.lang.Boolean)session.getAttribute("installerimpersonate"))
    {
        userid = (String)session.getAttribute("installerUsername");
    }
    else if ((java.lang.Boolean)session.getAttribute("adminimpersonate"))
    {
        userid = (String)session.getAttribute("adminUsername");
    }

    // needed to find REST functions later....
    String deviceInstancesURI = "/rest/" + partner + "/nw/" + sNetwork + "/instances/";




%>

<%@include file="../template/browserSpecificWizardHtmlTag.template" %>
        <link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/jqGrid/css/ui.jqgrid.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="<%=request.getContextPath()%>/jqGrid/css/jquery-ui.css" />
        <script language="JavaScript" type="text/javascript">
            var gMaxLenDeviceName = '<%=ICFieldConstants.MAXLEN_DEVICE_NAME%>'; //Used to constrain max len of Remote names
            if (gMaxLenDeviceName == null || gMaxLenDeviceName == '')
                gMaxLenDeviceName = 30;
        </script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/jquery.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/jqGrid/js/i18n/grid.locale-en.js"></script>
        <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/jqGrid/js/jquery.jqGrid.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/jquery.ba-dotimeout.js"></script>

        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwAjax.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwPanel.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwZones.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwRemoteCtrl.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwDiscovery.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwMainViews.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/icjs/hwMainCtrl.js"></script>

        <script language="javascript" type="text/javascript">
            hwZonesUser.problemMakingChanges = "<%=PROBLEM_MAKING_CHANGES%>";
            hwZonesUser.httpError401Text = "<%=HTTP_ERROR_401_TEXT%>";
            hwZonesUser.httpError404Text = "<%=HTTP_ERROR_404_TEXT%>";
            hwZonesUser.httpError408Text = "<%=HTTP_ERROR_408_TEXT%>";
            hwZonesUser.httpError500Text = "<%=HTTP_ERROR_500_TEXT%>";
            hwZonesUser.httpError503Text = "<%=HTTP_ERROR_503_TEXT%>";
            hwZonesUser.httpErrorGenericText = "<%=HTTP_ERROR_GENERIC_TEXT%>";
        </script>

        <script language="javascript" type="text/javascript">
            // this signin token is used in a REST call to get the logintoken, used by further rest calls
            var signinAuthToken='<%=SessionManager.getActionToken(request,SessionManager.ACTION_GETAUTHTOKEN_SERV)%>'
            // used in REST request, wizard token will timeout, expire. Before this fix it was 1/2 hour, same as portal
            // per KK, use a default value of 8 hrs = 8 X 60 X 60 = 28800 seconds. There is no requirement now to use a preference
            // to change this default, but we can still specify a preference name now.
            var loginTokenTimeout = <%=Preferences.get("hwZoneManagerLoginTokenTimeout", "28800") %>  // seconds
            var restDeviceInstancesURI ='<%=deviceInstancesURI%>'
            var theUserName ='<%=userid%>'
        </script>

        <title>Honeywell Assistant</title>
    </head>

<body onload="window.resizeTo( 859, 564);">
<div id="hwcontainer">
    <div id="hwleftSide">
        <div id="hwBkStripes">
            <div id="leftSideTop" align="center">
                <img src="../images/honeywellsetup2.gif" width=85 height=41 alt="Honeywell"/>
                    <span class="wizTitle">
                        <br/>
                        Manage Zones
                        <br/>
                    </span>
            </div>
            <div id="leftSideInside">
                <br/>
                <br/>
                    <span>
                        <a class="subHeadOn" name="steps" id="sideBarTitleStep1"></a>
                    </span>
                <br/>
                <span class="text indentSteps" id="sideBarDescriptionStep1"></span>
                <br/>
                <br/>
                    <span>
                        <a class="subHeadInactive" name="steps" id="sideBarTitleStep2"></a>
                    </span>
                <br/>
                <span class="text indentSteps" id="sideBarDescriptionStep2"></span>
                <br/>
                <br/>
                   <span>
                        <a class="subHeadInactive" name="steps" id="sideBarTitleStep3"></a>
                    </span>
                <br/>
                <span class="text indentSteps" id="sideBarDescriptionStep3"></span>
                <br/>
                <br/>
                   <span>
                        <a class="subHeadInactive" name="steps" id="sideBarTitleStep4"></a>
                    </span>
                <br/>
                <span class="text indentSteps" id="sideBarDescriptionStep4"></span>
                <br/>
                <br/>
                    <span>
                        <a class="subHeadInactive" name="steps" id="sideBarTitleStep5"></a>
                    </span>
                 <br/>
                <span class="text indentSteps" id="sideBarDescriptionStep5"></span>
                <br/>
                <br/>
                <div class="quit" id="quitOn" style="">
                    <%=Button.getButton("quitb", STR_BTN_QUIT, "javascript:hwButtonQuit()")%>
                </div>
            </div>
            <!-- leftSideInside -->
        </div>
        <!-- bk_stripes -->
    </div>
    <!-- leftSide -->
    <input type="hidden" id="technology" value="<%=technologyHTML%>">

    <div id="hwrightSide">
        <%-- ------------------------- --%>
        <div class="hwposition" id="stepDescriptionRS" name="sec">
            <div id="hwhead">
                <%=logoHTML%>
                <br/>
                <span id="mainHeadingTitle" class="steps"></span>
                <br/>
                <br/>
                <span id="mainHeadingTitleSubTitle" class="margin"></span>
            </div>
            <%-- head --%>
            <div id="stepDetails" class="hwcontent">
                <div class="infoText">
                    <span id="stepInstructions"></span>
                </div>
                <div class="hwgrid">
                    <table id="idZoneGridController"></table>
                    <table id="idRemoteGridController"></table>
                    <br/>
                </div>
                <div class="hwgridCenter">
                    <%=Button.getButtonDisabled("addRemoteButton", "Add Remote", "javascript:hwButtonQuit();")%>
                    <span id="spinner"></span>
                </div>
            </div>
            <%-- content --%>
             <div id="hwfoot">
                <div align="center">
                    <%=Button.getButtonDisabled("goBackButton", "Go Back", "javascript:hwButtonQuit();")%>&nbsp;&nbsp;
                    <%=Button.getButtonDisabled("continueButton", "Continue", "javascript:hwButtonQuit();")%>
                </div>
                <%-- footerButtons --%>
            </div>
            <%-- foot --%>
        </div>
        <%-- sec1 --%>
    </div>
    <%-- rightSide --%>
</div>
<!-- container -->

</body>
</html>
</icg:bundle>
