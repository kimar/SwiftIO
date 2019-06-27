public class RGBLED {	

	public init() {
		swiftHal_pinConfig(RGBLEDColor.red.rawValue, DigitalOutMode.pushPull.rawValue)
		swiftHal_pinConfig(RGBLEDColor.green.rawValue, DigitalOutMode.pushPull.rawValue)
		swiftHal_pinConfig(RGBLEDColor.blue.rawValue, DigitalOutMode.pushPull.rawValue)

		swiftHal_pinWrite(RGBLEDColor.red.rawValue, RGBLEDState.off.rawValue)
		swiftHal_pinWrite(RGBLEDColor.green.rawValue, RGBLEDState.off.rawValue)
		swiftHal_pinWrite(RGBLEDColor.blue.rawValue, RGBLEDState.off.rawValue)
	}

	public func on(_ color: RGBLEDColor) {
		swiftHal_pinWrite(color.rawValue, RGBLEDState.on.rawValue)
	}

	public func off(_ color: RGBLEDColor) {
		swiftHal_pinWrite(color.rawValue, RGBLEDState.off.rawValue)
	}

	public func set(red: RGBLEDState, green: RGBLEDState, blue: RGBLEDState) {
		swiftHal_pinWrite(RGBLEDColor.red.rawValue, red.rawValue)
		swiftHal_pinWrite(RGBLEDColor.green.rawValue, green.rawValue)
		swiftHal_pinWrite(RGBLEDColor.blue.rawValue, blue.rawValue)
	}

}




