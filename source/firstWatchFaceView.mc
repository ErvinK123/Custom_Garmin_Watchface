import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class firstWatchFaceView extends WatchUi.WatchFace {

    var isAwake = true;
    var owner = "Ervin";

    enum { 
        Morning, 
        Afternoon,
        Evening, 
        Night
    }

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time 
        var clockTime = System.getClockTime();

        // Update the view
        initTimeText(clockTime);
        initGreetingText(clockTime);

        initBatteryText(); 

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        isAwake = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        isAwake = false; 
    }


    // Greeting functions 
    function initGreetingText(clockTime) as Void { 
        var greeting = View.findDrawableById("Greeting") as Text; 
        greeting.setText(greetingToDisplay(clockTime) + " " + owner + "!");
    }

    function greetingToDisplay(clockTime) { 
        var hourOfDay = clockTime.hour;
        if (hourOfDay >= 0  && hourOfDay < 12 ) { 
            return "Good Morning";
        } else if (hourOfDay >= 12 && hourOfDay < 18) { 
            return "Good Afternoon";
        } else if (hourOfDay >= 18 && hourOfDay < 20) { 
            return "Good Evening"; 
        } else { 
            return "Good Night";  
        }
    }

    // Time functions 
    function initTimeText(clockTime) as Void { 
        var timeFormat = "$1$:$2$";
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
    }

    // Battery functions 
    function initBatteryText() as Void {
        var batteryStatus = System.getSystemStats().battery.format("%02d");
        var batteryText = View.findDrawableById("BatteryText") as Text; 
        batteryText.setText(batteryStatus.toString() + "%");
    }


}
