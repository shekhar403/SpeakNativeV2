//
//  ContentView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 11/08/23.
//

import SwiftUI
import CoreData
import TipKit

// Our custom view modifier to track rotation and
// call our action
#if os(iOS)
// Code specific to iOS
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
#endif

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
#if os(iOS)
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    // Code specific to iOS
    @State private var orientation = UIDeviceOrientation.unknown
#endif
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
#if os(iOS)
            // Code specific to iOS
            ZStack(alignment: .center) {
                Color("darkBlack").ignoresSafeArea()
                if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                    if orientation.isPortrait {
                        VStack(alignment:.center) {
                            loginView(orientation: $orientation)
                                .padding(10)
                        }
                    }
                    else {
                        HStack(alignment:.center) {
                            loginView(orientation: $orientation)
                                .padding(10)
                        }
                    }
                }
                else if horizontalSizeClass == .regular {
                    HStack(alignment:.center) {
                        loginView(orientation: $orientation)
                            .padding(10)
                    }
                }
                else if horizontalSizeClass == .compact {
                    VStack(alignment:.center) {
                        loginView(orientation: $orientation)
                            .padding(10)
                    }
                }
            }
            .toolbarBackground(Color("darkBlack"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear(perform: {
                orientation = UIDevice.current.orientation
            })
            .onRotate { o in
                orientation = o
            }
#else
            // Code for other platforms (e.g., macOS, watchOS, tvOS)
            ZStack(alignment: .center) {
                Color("darkBlack").ignoresSafeArea()
                HStack(alignment: .center) {
                    loginView()
                        .padding(10)
                    Spacer()
                }
            }
#endif
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct loginView: View {
    @State var showLoginButtons = false
    
#if os(iOS)
    // Code specific to iOS
    @Binding var orientation: UIDeviceOrientation
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
#else
    // Code for other platforms (e.g., macOS, watchOS, tvOS)
#endif
    
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State var shouldEnableLinks: Bool = false
    @State var dq = false
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var isSignedIn: Bool = !(UserDefaults.standard.string(forKey: "username") ?? "").isEmpty
    
    @ViewBuilder
    var destinationView: some View {
        if dq {
            MainFeaturesView {
                self.resetCredentials()
            }
        } else {
            WelcomeView() {
                self.resetCredentials()
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, content: {
                Image("App-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .yellow, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                Text("Speak Native")
                    .font(.custom("Arial Rounded MT bold", size: 60).bold())
                    .minimumScaleFactor(0.1)
                    .padding()
                    .multilineTextAlignment(.center)
                Text("Learn New Languages")
                    .font(.custom("Arial Rounded MT bold", size: 40).italic())
                    .minimumScaleFactor(0.1)
                    .padding()
                    .multilineTextAlignment(.center)
            })
            .foregroundStyle(Color("button-color"))
            .accessibilityElement(children: .combine)
            .padding([.top, .bottom], 20)
            .onAppear(perform: {
                dq = UserDefaults.standard.bool(forKey: "doneWelcome")
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                    withAnimation {
                        showLoginButtons = true
                    }
                }
            })
            .frame(width: geo.size.width*0.8, height: geo.size.height*0.8)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        
        if showLoginButtons {
            HStack (alignment: .center, content: {
                if #available(macOS 14.0, iOS 17.0, *) {
                    LoginForm(username: $username, password: $password, showingAlert: $showingAlert, alertMessage: $alertMessage, alertTitle: $alertTitle, shouldEnableLinks: $shouldEnableLinks, isSignedIn: $isSignedIn)
    #if os(iOS)
                        .popoverTip(ShowButtonTip(idValue: "login_tip", titleValue: "Login", messageValue: "·Click the button to start learning."), arrowEdge:.bottom)
    #endif
                }
                else {
                    LoginForm(username: $username, password: $password, showingAlert: $showingAlert, alertMessage: $alertMessage, alertTitle: $alertTitle, shouldEnableLinks: $shouldEnableLinks, isSignedIn: $isSignedIn)
                }

            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
            }
            .onAppear(perform: {
                resetCredentials()
            })
            .navigationDestination(isPresented: $shouldEnableLinks) {
                destinationView
            }
        }
    }
    
    private func resetCredentials() {
        //        removePasswordFromKeychain()
//                UserDefaults.standard.removeObject(forKey: "doneWelcome")
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        password = ""
        
        if username.isEmpty {
            isSignedIn = false
        }
        else {
            isSignedIn = true
        }
    }
    
    //    func removePasswordFromKeychain() {
    //        let query: [String: Any] = [
    //            kSecClass as String: kSecClassGenericPassword,
    //            kSecAttrAccount as String: "passwordKC"
    //        ]
    //
    //        let status = SecItemDelete(query as CFDictionary)
    //        if status == errSecSuccess {
    //            print("Password removed from Keychain")
    //            UserDefaults.standard.removeObject(forKey: "username")
    //        } else {
    //            print("Failed to remove password from Keychain")
    //        }
    //    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
