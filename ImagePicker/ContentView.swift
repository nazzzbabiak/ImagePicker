//
//  ContentView.swift
//  ImagePicker
//
//  Created by Nazar Babyak on 18.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var imgData = Data.init(count: 0)
    @State var shown = false
    var body: some View {
        VStack{
            
            if imgData.count != 0 {
                Image(uiImage: UIImage(data: imgData)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 400)
                    .padding()
                    .cornerRadius(22 )
                
            }
            
            Button(action: {
                self.shown.toggle()
            }) {
                Text("Виберіть зображення")
                    .frame(width: 155, height: 55)
                    .foregroundColor(.black)
                    .background(.gray.opacity(0.33))
                    .cornerRadius(11)
            }
            .sheet(isPresented: $shown) {
                picker(shown: self.$shown, imgData: self.$imgData)
            }
        }.animation(.easeIn)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct picker : UIViewControllerRepresentable {
    
    @Binding var shown: Bool
    @Binding var imgData: Data
    func makeCoordinator() -> Coordinator {
        
        return Coordinator(imgData1: $imgData, shown1: $shown)
        
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<picker>) -> UIImagePickerController  {
        
        let controler = UIImagePickerController()
        controler.sourceType = .photoLibrary
        controler.delegate = context.coordinator
        return controler
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        @Binding var imgData: Data
        @Binding var shown: Bool
        
        init(imgData1: Binding<Data>,shown1: Binding<Bool>) {
            
            _imgData = imgData1
            _shown = shown1
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            shown.toggle()
            
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let image = info[.originalImage] as! UIImage
            imgData = image.jpegData(compressionQuality: 80)!
            shown.toggle()
        }
    }
}
