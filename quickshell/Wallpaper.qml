import Quickshell
import QtQuick
Variants {
model: Quickshell.screens;
delegate: Component {
PanelWindow{
	required property var modelData
	screen: modelData
	anchors {
		top: true
		left: true
		right: true
		bottom: true
	}
	exclusionMode: ExclusionMode.Ignore
	aboveWindows: false
	Image {
		id: wallpaper
		source: "/home/rusu/Pictures/Wallpapers/1247F5D3-9BAF-47D2-BEBF-8084294865C1.jpg"
		fillMode: Image.PreserveAspectCrop
		anchors.fill: parent
	}
}
}
}
