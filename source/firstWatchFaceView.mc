import Toybox.Application;
import Toybox.Attention; 
import Toybox.Graphics;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Sensor;
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
        var clockTime = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        // var sensorData = Sensor.getInfo();

        // Get the current time 
        // var clockTime = System.getClockTime();

        // Update the view
        initTimeText(clockTime);
        initSecondsText(clockTime, isAwake);
        initDateText(clockTime);
        initGreetingText(clockTime, isAwake);
        initBatteryText(); 
        // initHeartRate(sensorData);
        

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
    function initGreetingText(clockTime, isAwake) as Void {
        var greeting = View.findDrawableById("Greeting") as Text; 
        if (!isAwake) { 
            greeting.setText("");
            return;
        }
        greeting.setText(greetingToDisplay(clockTime, true) + " " + owner + "!");
    }

    function greetingToDisplay(clockTime, isAwake) { 
        if (!isAwake) { 
            return ""; 
        }
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
        var dayOrNight = "am";
        var timeFormat = "$1$ :$2$ $3$";
        var hours = clockTime.hour;

        if (hours >= 12) { 
            dayOrNight = "pm";
        }

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
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d"), dayOrNight]);


        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
    }   

    function initSecondsText(clockTime, isAwake) as Void { 
        var view = View.findDrawableById("secondLabel") as Text;
        if (!isAwake) { 
            view.setText("");
            return;
        }
        view.setText(":" + clockTime.sec.format("%02d"));
    }

    function initDateText(clockTime) as Void { 
        var view = View.findDrawableById("dateText") as Text; 
        var dateFormat = "$1$\n$2$ $3$";
        // System.println(clockTime.day.format("%02u"));
        // System.println(clockTime.month.format("%02u"));
        var dateString = Lang.format(dateFormat, [clockTime.day_of_week , clockTime.day.format("%02u"), clockTime.month]);
        view.setText(dateString);
    }

    // Battery functions 
    function initBatteryText() as Void {
        var batteryStatus = System.getSystemStats().battery.format("%02d");
        var batteryText = View.findDrawableById("BatteryText") as Text; 
        batteryText.setText(batteryStatus.toString() + "%");
    }

    

    // HeartRate function 
    // function initHeartRate(sensorData) as Void {
    //     var heartRate = sensorData.heartRate;
    //     var heartRateText = View.findDrawableById("heartRate") as Text; 
    //     heartRateText.setText(heartRate.toString()); 
    // }

}
