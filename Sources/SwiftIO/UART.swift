/**
UART is a two-wire serial communication protocol used to communicate with serial devices. The devices must agree on a common transmisson rate before communication.

*/
public class UART {

    private var obj: UARTObject

    private let id: Id
    private var baudRate: Int {
        willSet {
            obj.baudRate = Int32(newValue)
        }
    }
    private var dataBits: DataBits {
        willSet {
            obj.dataBits = newValue.rawValue
        }
    }
    private var parity: Parity {
        willSet {
            obj.parity = newValue.rawValue
        }
    }
    private var stopBits: StopBits {
        willSet {
            obj.stopBits = newValue.rawValue
        }
    }
    private var readBufferLength: BufferLength {
        willSet {
            obj.readBufferLength = Int32(newValue.rawValue)
        }
    }

    private func objectInit() {
        obj.id = id.rawValue
        obj.baudRate = Int32(baudRate)
        obj.dataBits = dataBits.rawValue
        obj.parity = parity.rawValue
        obj.stopBits = stopBits.rawValue
        obj.readBufferLength = Int32(readBufferLength.rawValue)
        swiftHal_uartInit(&obj)
    }

    /**
     Initialize an interface for UART communication.
     - Parameter id: **REQUIRED** The name of the UART interface.
     - Parameter baudRate: **OPTIONAL**The communication speed. The default baud rate is 115200.
     - Parameter dataBits : **OPTIONAL**The length of the data being transmitted.
     - Parameter parity: **OPTIONAL**The parity bit to confirm the accuracy of the data transmission.
     - Parameter stopBits: **OPTIONAL**The bits reserved to stop the communication.
     - Parameter readBufferLength: **OPTIONAL**The length of the serial buffer to store the data.
     
     ### Usage Example ###
     ````
     // Initialize a UART interface UART0.
     let uart = UART(.UART0)
     ````
     */
    public init(_ id: Id,
                baudRate: Int = 115200,
                dataBits: DataBits = .eightBits,
                parity: Parity = .none,
                stopBits: StopBits = .oneBit,
                readBufferLength: BufferLength = .small) {
        self.id = id
        self.baudRate = baudRate
        self.dataBits = dataBits
        self.parity = parity
        self.stopBits = stopBits
        self.readBufferLength = readBufferLength
        obj = UARTObject()
        objectInit()
    }

    deinit {
        swiftHal_uartDeinit(&obj)
    }

    /**
     Set the baud rate for communication. It should be set ahead of time to ensure the same baud rate between two devices.
     - Parameter baudRate: The communication speed.

     */
    public func setBaudrate(_ baudRate: Int) {
        obj.baudRate = Int32(baudRate)
        swiftHal_uartConfig(&obj)
    }

    /**
     Clear all bytes from the buffer to store the incoming data.
     */
    public func clearBuffer() {
        swiftHal_uartClearBuffer(&obj)
    }

    /**
     Return the number of received data from the serial buffer.
     - Returns: The number of bytes received in the buffer.
     */
    public func checkBufferReceived() -> Int {
        return Int(swiftHal_uartCount(&obj))
    }

    /**
     Write a byte of data to the external device through the serial connection.
     - Parameter byte: One 8-bit binary data to be sent to the device.

     */
    @inline(__always)
    public func write(_ byte: UInt8) {
        swiftHal_uartWriteChar(&obj, byte)
    }

    /**
     Write a series of bytes to the external device through the serial connection.
     - Parameter data: A byte array to be sent to the device.

     */
    @inline(__always)
    public func write(_ data: [UInt8]) {
        swiftHal_uartWrite(&obj, data, Int32(data.count))
    }

    /**
     Write a string to the external device through the serial connection.
     - Parameter string: A string to be sent to the device.

     */
    @inline(__always)
    public func write(_ string: String) {
        let data: [UInt8] = string.utf8CString.map {UInt8($0)}
        swiftHal_uartWrite(&obj, data, Int32(data.count))
    }

    /**
     Read a byte of data receiving from the external device.
     - Returns: One 8-bit binary data read from the device.

     */
    @inline(__always)
    public func readByte() -> UInt8 {
        return swiftHal_uartReadChar(&obj)
    }

    /**
     Read a series of bytes receiving from the external device.
     - Returns: A byte array read from the device.

     */
    @inline(__always)
    public func read(_ count: Int) -> [UInt8] {
        var data: [UInt8] = Array(repeating: 0, count: count)
        swiftHal_uartRead(&obj, &data, Int32(count));
        return data
    }


}




extension UART {
    
    /**
     The interfaces UART0 to UART3 are used for UART communication. Two pins are necessary: TX is used to transmit data; RX is used to receive data.

     */
    public enum Id: UInt8 {
        case UART0 = 0, UART1, UART2, UART3
    }

    /**
     The parity bit is used to ensure the data transmission according to the number of logical-high bits.

     */
    public enum Parity: UInt8 {
        case none, odd, even
    }

    /**
     One or two stops bits are reserved to end the communication.

     */
    public enum StopBits: UInt8 {
        case oneBit, twoBits
    }

    /**
     This indicates the length of the data being transmitted.

     */
    public enum DataBits: UInt8 {
        case eightBits
    }

    /**
     This indicates the storage size of the serial buffer.

     */
    public enum BufferLength: Int32 {
        case small = 64, medium = 256, large = 1024
    }
}
