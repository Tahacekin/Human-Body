//
//  ContentView.swift
//  Human Body
//
//  Created by Taha Çekin on 14.04.2021.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var models: [String] = ["fender_stratocaster", "cup_saucer_set", "chair_swan", "toy_biplane", "toy_robot_vintage"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            ModelPickerView(models: self.models)
          
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    var models: [String]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0..<self.models.count) { index in
                    
                    Button(action: {
                        print("DEBUG: selected model with name \(self.models[index])")
                    }, label: {
                        Image(uiImage: UIImage(named: self.models[index])!)
                            .resizable()
                            .frame(height: 60)
                            .aspectRatio(1/1,contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        .padding(5)
        .background(Color.black.opacity(0.5))
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
