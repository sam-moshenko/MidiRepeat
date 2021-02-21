//
//  MidiReceiver.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation
import CoreMIDI

struct Packet {
    let command: Command?
    let note: UInt8
    let speed: UInt8
    
    enum Command: UInt8 {
        case noteDown = 144, noteUp = 128
    }
}

protocol MidiReceiverProtocol {
    var packetBlock: ((Packet) -> Void)? { get set }
}

class MidiReceiver: MidiReceiverProtocol {
    var packetBlock: ((Packet) -> Void)?
    
    init() {
        let source = MIDIGetSource(0)
        let client: UnsafeMutablePointer<MIDIClientRef> = .allocate(capacity: 1)
        MIDIClientCreateWithBlock("My app client" as CFString, client) { event in
            print(event)
        }
        let inputPort: UnsafeMutablePointer<MIDIPortRef> = .allocate(capacity: 1)
        MIDIInputPortCreateWithBlock(client.pointee, "My app port" as CFString, inputPort) { [unowned self] (listRef, pointer) in
            let list = listRef.pointee
            let packet = Packet(
                command: Packet.Command.init(rawValue: list.packet.data.0),
                note: list.packet.data.1,
                speed: list.packet.data.2
            )
            self.packetBlock?(packet)
        }
        let connectionReference: UnsafeMutablePointer<MIDIThruConnectionRef> = .allocate(capacity: 1)
        MIDIPortConnectSource(inputPort.pointee, source, connectionReference)
    }
}
