//
//  ContentView.swift
//  MacDragging
//
//  Created by April Rogers-Kent on 8/21/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let customType = UTType(exportedAs: "com.april.mac.dragging.customType")
}

struct CustomType: Codable, Hashable {
    let id: UUID
    let title: String
    
    func nsItemProvider() -> NSItemProvider {
        NSItemProvider(item: asData() as NSSecureCoding, typeIdentifier: UTType.customType.identifier)
    }
    
    private func asData() -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(self)
            return data
        } catch {
            preconditionFailure("could not encode custom type")
        }
    }
}

struct TextType: Codable, Hashable {
    let id: UUID
    let description: String
    
    func nsItemProvider() -> NSItemProvider {
        return NSItemProvider(object: description as NSString)
    }
}

struct ContentView: View {
    @State private var typeOneDrops = 0
    @State private var typeTwoDrops = 0
    private let typeOne = CustomType(id: UUID(), title: "Custome Type Identifier")
    private let typeTwo = TextType(id: UUID(), description: "Text Type Identifier")

    var body: some View {
        HStack {
            VStack {
                TextView(title: typeOne.title)
                    .onDrag(typeOne.nsItemProvider)
                
                DropView(title: "Custom Type Drop Zone", count: typeOneDrops)
                    .onDrop(of: [.customType], delegate: CustomTypeDropDelegate(count: $typeOneDrops))
            }
            
            VStack {
                TextView(title: typeTwo.description)
                    .onDrag(typeTwo.nsItemProvider)
                
                DropView(title: "Text Type Drop Zone", count: typeTwoDrops)
                    .onDrop(of: [.text], delegate: TextDropDelegate(count: $typeTwoDrops))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

private struct TextView: View {
    let title: String

    var body: some View {
        Text(title)
            .padding(12)
            .background(Color(.secondarySystemFill))
            .cornerRadius(8)
            .shadow(radius: 1, x: 1, y: 1)
    }
}

private struct DropView: View {
    let title: String
    let count: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.secondarySystemFill))
            
            VStack {
                Text(title).font(.headline.bold())
                
                Text("Drop Count: \(count)")
            }
        }
    }
}
