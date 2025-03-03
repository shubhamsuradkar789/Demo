import SwiftUI
import PhotosUI

// MARK: - RegisterRestaurantView
/// View for registering a restaurant with details, operating hours, and an optional image
struct RegisterRestaurantView: View {
    @EnvironmentObject var userManager: UserManager // Accessing the logged-in user's details
    @StateObject private var viewModel: RestaurantRegistrationViewModel
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    init(userManager: UserManager) {
        _viewModel = StateObject(wrappedValue: RestaurantRegistrationViewModel(ownerId: userManager.userId))
    }

    var body: some View {
        VStack {
            Text("Restaurant Registration")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top)

            // MARK: - Form Section
            Form {
                // MARK: Restaurant Details Section
                Section(header: Text("Restaurant Details")
                    .font(.headline)
                    .foregroundColor(.red)) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                    TextField("Street Address", text: $viewModel.streetAddress)
                    TextField("Additional Address", text: $viewModel.additionalAddress)
                    TextField("City", text: $viewModel.city)
                    TextField("State", text: $viewModel.state)
                    TextField("Pincode", text: $viewModel.pincode)
                }

                // MARK: Operating Hours Section
                Section(header: Text("Operating Hours")
                    .font(.headline)
                    .foregroundColor(.red)) {
                    TextField("Opening Time (e.g., 7am)", text: $viewModel.openingTime)
                    TextField("Closing Time (e.g., 7pm)", text: $viewModel.closingTime)
                }

                // MARK: Image Selection Section
                Section(header: Text("Image")
                    .font(.headline)
                    .foregroundColor(.red)) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    Button("Select Image") {
                        showImagePicker = true
                    }
                }
            }

            // MARK: - Register Button
            Button(action: {
                Task {
                    // Convert selected image to JPEG data before sending it for registration
                    let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                    await viewModel.registerRestaurant(imageData: imageData)
                }
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showMessage) {
            Alert(title: Text(viewModel.message))
        }
        .sheet(isPresented: $showImagePicker) {
            // Show ImagePicker to select an image
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

// MARK: - ImagePicker
/// Image picker for selecting an image from the photo library using PHPickerViewController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Only allow image selection
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

