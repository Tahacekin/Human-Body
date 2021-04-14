//
//  ContentView.swift
//  Human Body
//
//  Created by Taha Çekin on 14.04.2021.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State var isPlacement = false
    @State var selectedModel: String?
    @State var modelConfirmedForPlacement: String?
    
    private var models: [String] = {
        let filemaneger = FileManager.default
        guard let path = Bundle.main.resourcePath, let files = try? filemaneger.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels: [String] = []
        for filename in files where
            filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            availableModels.append(modelName)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.isPlacement {
                PlacementButtonView(isPlacement: self.$isPlacement, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacement: self.$isPlacement, selectedModel: self.$selectedModel, models: self.models)
            }
        }
    }
}

struct PlacementButtonView: View {
    @Binding var isPlacement: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedForPlacement: String?
    
    var body: some View {
        
        HStack(spacing: 30) {
            Button(action: {
                print("DEBUG: Model placement declined")
                self.resetPlacementParametres()
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                
            })
            
            Button(action: {
                print("DEBUG: Model placement confirmed")
            
                self.modelConfirmedForPlacement = self.selectedModel
                
                self.resetPlacementParametres()
            }, label: {
                Image(systemName: "checkmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                
            })
        }
    }
    
    func resetPlacementParametres() {
        self.isPlacement = false
        self.selectedModel = nil
    }
    
    
    
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        if let modelname = self.modelConfirmedForPlacement {
            
            let filename = modelname + ".usdz"
            let modelEntity = try! ModelEntity.loadModel(named: filename)
            let anchor = AnchorEntity(plane: .any)
            anchor.addChild(modelEntity)
            uiView.scene.addAnchor(anchor)
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
            
        }
        
    }
    
}

struct ModelPickerView: View {
    @Binding var isPlacement: Bool
    @Binding var selectedModel: String?
    
    var models: [String]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0..<self.models.count) { index in
                    
                    Button(action: {
                        print("DEBUG: selected model with name \(self.models[index])")
                        
                        self.selectedModel = self.models[index]
                        
                        self.isPlacement = true
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
