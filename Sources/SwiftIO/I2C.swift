/**
 I2C (I square C) is a two wire protocol to communicate between different devices. The I2C class allows some operations through I2C protocol, including reading messages from a device and writing messages to a device.
 Currently the I2C ports support only master mode.
 
 - Note:
 Different I2C devices have different attributes. Please reference the device manual before using the functions below.
 This class allows the reading and writing of a byte `UInt8` or an array of bytes `[UInt8]`.

 */
 public class I2C {

    private var obj: I2CObject

    private let id: Id
    private var speed: Speed {
        willSet {
            obj.speed = newValue.rawValue
        }
    }

    private func objectInit() {
        obj.id = id.rawValue
        obj.speed = speed.rawValue
        swiftHal_i2cInit(&obj)
    }

    /**
     Initialize a specific I2C interface as a master device.
     - Parameter id: **REQUIRED** The name of the I2C interface.
     - Parameter speed: **OPTIONAL** The clock speed used to control the data transmission.
     
     ### Usage Example ###
     ````
     // Initialize an I2C interface I2C0.
     let i2cBus = I2C(.I2C0)
     ````
     */
    public init(_ id: Id,
                speed: Speed = .standard) {
        self.id = id
        self.speed = speed
        obj = I2CObject()
        objectInit()
    }

    deinit {
        swiftHal_i2cDeinit(&obj)
    }

    /**
     Get the current clock speed of the data transmission.
     
     - Returns: The current speed: `.standard`, `.fast` or `.fastPlus`.
     */
    public func getSpeed() -> Speed {
        return speed
    }

    /**
     Set the clock speed to change the transmission rate.
     - Parameter speed: The clock speed used to control the data transmission.
     */
    public func setSpeed(_ speed: Speed) {
        self.speed = speed
        swiftHal_i2cConfig(&obj)
    }

    /**
     Read one byte from a specified slave device with the given address.
     - Parameter address: The address of the slave device the board will communicate with.
     
     - Returns: One 8-bit binary number receiving from the slave device.
     */
    @inline(__always)
    public func readByte(from address: UInt8) -> UInt8 {
        var data = [UInt8](repeating: 0, count: 1)
        
        swiftHal_i2cRead(&obj, address, &data, 1)
        return data[0]
    }

    /**
     Read an array of data from a specified slave device with the given address.
     - Parameter count : The number of bytes to read.
     - Parameter address : The address of the slave device the board will communicate with.
     
     - Returns: An array of 8-bit binary numbers receiving from the slave device.
     */
    @inline(__always)
    public func read(count: Int, from address: UInt8) -> [UInt8] {
        var data = [UInt8](repeating: 0, count: count)

        swiftHal_i2cRead(&obj, address, &data, Int32(count))
        return data
    }

    /**
     Write a byte of data to a specified slave device with the given address.
     - Parameter byte : One 8-bit binary number to be sent to the slave device.
     - Parameter address : The address of the slave device the board will communicate with.
     */
    @inline(__always)
    public func write(_ byte: UInt8, to address: UInt8) {
        var _data = [UInt8](repeating: 0, count: 1)

        _data[0] = byte
        swiftHal_i2cWrite(&obj, address, _data, 1)
    }

    /**
     Write an array of data to a specified slave device with the given address.
     - Parameter data : A byte array to be sent to the slave device.
     - Parameter address : The address of the slave device the board will communicate with.
     */
    @inline(__always)
    public func write(_ data: [UInt8], to address: UInt8) {
        swiftHal_i2cWrite(&obj, address, data, Int32(data.count))
    }

    /**
     Write an array of bytes to the slave device with the given address and then read the bytes sent from the device.
     - Parameter data : A byte array to be sent to the slave device.
     - Parameter readCount : The number of bytes to read.
     - Parameter address : The address of the slave device the board will communicate with.
     
     - Returns: An array of 8-bit binary numbers receiving from the slave device.
     */
    @inline(__always)
    public func writeRead(_ data: [UInt8], readCount: Int, address: UInt8) -> [UInt8] {
        var receivedData = [UInt8](repeating:0, count: readCount)

        swiftHal_i2cWriteRead(&obj, address, data, Int32(data.count), &receivedData, Int32(readCount))
        return receivedData
    }

}

extension I2C {

    /**
     I2C0 and I2C1 are used  for I2C communication. SCL is for clock signal and SDA is for data signal.
     */
    public enum Id: UInt8 {
        case I2C0, I2C1
    }

    /**
     The clock signal is used to synchronize the data transmission between the devices.There are three available speed grades.
     */
    public enum Speed: Int32 {
        case standard = 100000, fast = 400000, fastPlus = 1000000
    }
}
