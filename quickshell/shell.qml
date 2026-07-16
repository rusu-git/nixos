import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Scope{

property int text_font: 12

PanelWindow {
	anchors {
    	top: true
    	left: true
    	right: true
	}
	implicitHeight: 37
	color: "transparent"
	Rectangle {
		id: panel
		color: "#000000"
		width: 100
		implicitHeight: 30
		radius: 15
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
			Text {
				id: workspace
				visible: false
				font.pixelSize: text_font
				color: "#ffffff"
				anchors.centerIn: parent
				text: {
					if (Hyprland.focusedWorkspace.id == 1) {
						return "一"
					}
					else if (Hyprland.focusedWorkspace.id == 2) {
						return "二"
					}
					else if (Hyprland.focusedWorkspace.id == 3) {
						return "三"
					}
					else if (Hyprland.focusedWorkspace.id == 4) {
						return "四"
					}
					else if (Hyprland.focusedWorkspace.id == 5) {
						return "五"
					}
					else if (Hyprland.focusedWorkspace.id == 6) {
						return "六"
					}
					else if (Hyprland.focusedWorkspace.id == 7) {
						return "七"
					}
					else if (Hyprland.focusedWorkspace.id == 8) {
						return "八"
					}
					else if (Hyprland.focusedWorkspace.id == 9) {
						return "九"
					}
					else if (Hyprland.focusedWorkspace.id == 10) {
						return "十"
					}
					else {
						return Hyprland.focusedWorkspace.id
					}
				}
			}
			Connections {
				target: Hyprland
				function onRawEvent(event) {
					if (event.name == "workspacev2" || event.name =="focusedmonv2") {
						clock.visible = false
						workspace.visible = true
						wstimer.restart()
					}    
				}
			}
		  		Timer {
		  			id: wstimer 
		  	   		interval: 1500
			   	    running: false
		  	   	    repeat: false
		  	   	 	onTriggered: {
		  	      	workspace.visible = false;
		  	      	clock.visible = true;
		  	      	
		  	      }	
		  	    }					
			
		  Text {
		    id: clock
		    color: "#ffffff"
		    anchors.centerIn: parent
		    font.pixelSize: text_font
		    Process {
		      id: time
		      command: ["date", "+%H:%M"]
		      running: true

		      stdout: StdioCollector {
		        onStreamFinished: clock.text = this.text
		      }
		    }

		    Timer {
		      interval: 1000
		      running: true
		      repeat: true
		      onTriggered: time.running = true
		    }
		  }	

		  Text {
		  	id: date
		  	color: "#ffffff"
		  	anchors.left: parent.left
		  	anchors.verticalCenter: parent.verticalCenter
		  	visible: false
		  	font.pixelSize: font_size
		  	Process {
		  	id: day
		  	command: ["date", "+%a, %B %d"]
		  	running: true
		    stdout: StdioCollector {
		  		onStreamFinished: date.text = "   " + this.text
		  	}
		  }

//Date and time timer		  
		  	Timer {
		  	      interval: 1000
		  	      running: true
		  	      repeat: true
		  	      onTriggered: {
		  	      	time.running = true
		  	      	day.running = true
		  	      }	
		  	    }
		  	  }	

//Battery
			Row {
			id: batteryRow
			spacing : 2
			anchors.right: panel.right
			anchors.verticalCenter: panel.verticalCenter
			visible: false
			Image{
				source: {
					if (UPower.displayDevice.percentage <= 0.80 && UPower.displayDevice.percentage >= 0.71) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_5_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
					else if (UPower.displayDevice.percentage <= 0.70 && UPower.displayDevice.percentage >= 0.51) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_4_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
					else if (UPower.displayDevice.percentage <= 0.50 && UPower.displayDevice.percentage >= 0.31) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_3_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
					else if (UPower.displayDevice.percentage <= 0.30 && UPower.displayDevice.percentage >= 0.10) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_2_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
					else if (UPower.displayDevice.percentage <= 0.10 && UPower.displayDevice.percentage >= 0.01) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_1_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
					else if (UPower.displayDevice.percentage > 0.8) {
						return "/home/rusu/.dotfiles/quickshell/battery_android_frame_full_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
					}
				} 
				anchors.verticalCenter: parent.verticalCenter
				height: 20
				width: 20
			}
			Text {
				id: battery
				anchors.verticalCenter: parent.verticalCenter
				color: "#ffffff"
				text: Math.round(UPower.displayDevice.percentage*100)  + "%   "
				font.pixelSize: text_font
			}
			}

			Connections {
				target: UPower.displayDevice
				function onStateChanged() {
					if (UPower.displayDevice.state == UPowerDeviceState.Charging) {
						chargingshow.start()
					}
				}
			}
			NumberAnimation {
			    id: chargingshow
			    target: panel
			    property: "width"
			    to: 200
			    duration: 300
			    onStarted: {
			    	panel.border.width = 1
			    	panel.border.color = "#5BC236"
			    }
			    onFinished:{
			    	btimer.start()
			    }
			    easing.type: Easing.InOutQuad
			}
			NumberAnimation {
			    id: chargingclose
			    target: panel
			    property: "width"
			    to: 100
			    duration: 300
			    onFinished: {
			    		panel.border.width = 0
			    }
			    easing.type: Easing.InOutQuad
				}
			Timer{
				id: btimer
				interval: 2000
				running: false
				repeat: false
				onTriggered: chargingclose.start()
			}
			
			MouseArea {
			    anchors.fill: parent
				hoverEnabled: true
			    onEntered: {
					ctimer.stop()
			    	openinganimation.start()
			    }
			    onExited: {ctimer.running = true}
			}

//Closing animation timer
			Timer { 
				id: ctimer
				interval:2000
				repeat: false
				onTriggered: closinganimation.start()
			}
			
			NumberAnimation {
			    id: openinganimation
			    target: panel
			    property: "width"
			    to: 400
			    duration: 300
			    onFinished: {
			    	batteryRow.visible = true
			    	date.visible = true
			    }
			    easing.type: Easing.InOutQuad
			}
			NumberAnimation {
			    id: closinganimation
			    target: panel
			    property: "width"
			    to: 100
			    duration: 300
			    onStarted: {
			    	batteryRow.visible = false
			    	date.visible = false
			    }
			    easing.type: Easing.InOutQuad
			}
		}
	}

Wallpaper{}

}
